Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13327 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751989AbdHLWc2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Aug 2017 18:32:28 -0400
Date: Sun, 13 Aug 2017 06:32:09 +0800
From: kbuild test robot <lkp@intel.com>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: kbuild-all@01.org, Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 5/5] [media] cxusb: add analog mode support for Medion
 MD95700
Message-ID: <201708130619.vuq0fThc%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a74971c-171f-7336-065c-59cede29f624@maciej.szmigiero.name>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maciej,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.13-rc4 next-20170811]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Maciej-S-Szmigiero/Add-analog-mode-support-for-Medion-MD95700/20170813-041742
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)


vim +359 drivers/media/usb/dvb-usb/cxusb-analog.c

   198	
   199	static bool cxusb_medion_copy_field(struct dvb_usb_device *dvbdev,
   200					    struct cxusb_medion_auxbuf *auxbuf,
   201					    struct cxusb_bt656_params *bt656,
   202					    bool firstfield,
   203					    unsigned int maxlines,
   204					    unsigned int maxlinesamples)
   205	{
   206		while (bt656->line < maxlines &&
   207		       !cxusb_auxbuf_isend(auxbuf, bt656->pos)) {
   208	
   209			unsigned char val;
   210	
   211			if (!cxusb_auxbuf_copy(auxbuf, bt656->pos, &val, 1))
   212				return false;
   213	
   214			if ((char)val == CXUSB_BT656_COMMON[0]) {
   215				char buf[3];
   216	
   217				if (!cxusb_auxbuf_copy(auxbuf, bt656->pos + 1,
   218						       buf, 3))
   219					return false;
   220	
   221				if (buf[0] != (CXUSB_BT656_COMMON)[1] ||
   222				    buf[1] != (CXUSB_BT656_COMMON)[2])
   223					goto normal_sample;
   224	
   225				if (bt656->line != 0 && (!!firstfield !=
   226							 ((buf[2] & CXUSB_FIELD_MASK)
   227							  == CXUSB_FIELD_1))) {
   228					if (bt656->fmode == LINE_SAMPLES) {
   229						cxusb_vprintk(dvbdev, BT656,
   230							      "field %c after line %u field change\n",
   231							      firstfield ? '1' : '2',
   232							      bt656->line);
   233	
   234						if (bt656->buf != NULL &&
   235							maxlinesamples -
   236							bt656->linesamples > 0) {
   237	
   238							memset(bt656->buf, 0,
   239								maxlinesamples -
   240								bt656->linesamples);
   241	
   242							bt656->buf +=
   243								maxlinesamples -
   244								bt656->linesamples;
   245	
   246							cxusb_vprintk(dvbdev, BT656,
   247								      "field %c line %u %u samples still remaining (of %u)\n",
   248								      firstfield ?
   249								      '1' : '2',
   250								      bt656->line,
   251								      maxlinesamples -
   252								      bt656->
   253								      linesamples,
   254								      maxlinesamples);
   255						}
   256	
   257						bt656->line++;
   258					}
   259	
   260					if (maxlines - bt656->line > 0 &&
   261						bt656->buf != NULL) {
   262						memset(bt656->buf, 0,
   263							(maxlines - bt656->line)
   264							* maxlinesamples);
   265	
   266						bt656->buf +=
   267							(maxlines - bt656->line)
   268							* maxlinesamples;
   269	
   270						cxusb_vprintk(dvbdev, BT656,
   271							      "field %c %u lines still remaining (of %u)\n",
   272							      firstfield ? '1' : '2',
   273							      maxlines - bt656->line,
   274							      maxlines);
   275					}
   276	
   277					return true;
   278				}
   279	
   280				if (bt656->fmode == START_SEARCH) {
   281					if ((buf[2] & CXUSB_SEAV_MASK) ==
   282					    CXUSB_SEAV_SAV &&
   283					    (!!firstfield == ((buf[2] &
   284							       CXUSB_FIELD_MASK)
   285							      == CXUSB_FIELD_1))) {
   286	
   287						if ((buf[2] & CXUSB_VBI_MASK) ==
   288						    CXUSB_VBI_OFF) {
   289							cxusb_vprintk(dvbdev,
   290								      BT656,
   291								      "line start @ pos %x\n",
   292								      bt656->pos);
   293	
   294							bt656->linesamples = 0;
   295							bt656->fmode = LINE_SAMPLES;
   296						} else {
   297							cxusb_vprintk(dvbdev,
   298								      BT656,
   299								      "VBI start @ pos %x\n",
   300								      bt656->pos);
   301	
   302							bt656->fmode = VBI_SAMPLES;
   303						}
   304					}
   305	
   306					bt656->pos =
   307						cxusb_auxbuf_advance(auxbuf,
   308								     bt656->pos, 4);
   309					continue;
   310				} else if (bt656->fmode == LINE_SAMPLES) {
   311					if ((buf[2] & CXUSB_SEAV_MASK) ==
   312					    CXUSB_SEAV_SAV)
   313						cxusb_vprintk(dvbdev, BT656,
   314							      "SAV in line samples @ line %u, pos %x\n",
   315							      bt656->line, bt656->pos);
   316	
   317					if (bt656->buf != NULL && maxlinesamples -
   318					    bt656->linesamples > 0) {
   319	
   320						memset(bt656->buf, 0,
   321						       maxlinesamples -
   322						       bt656->linesamples);
   323						bt656->buf += maxlinesamples -
   324							bt656->linesamples;
   325	
   326						cxusb_vprintk(dvbdev, BT656,
   327							      "field %c line %u %u samples still remaining (of %u)\n",
   328							      firstfield ? '1' : '2',
   329							      bt656->line,
   330							      maxlinesamples -
   331							      bt656->linesamples,
   332							      maxlinesamples);
   333					}
   334	
   335	
   336					bt656->fmode = START_SEARCH;
   337					bt656->line++;
   338					continue;
   339				} else if (bt656->fmode == VBI_SAMPLES) {
   340					if ((buf[2] & CXUSB_SEAV_MASK) ==
   341					    CXUSB_SEAV_SAV)
   342						cxusb_vprintk(dvbdev, BT656,
   343							      "SAV in VBI samples @ pos %x\n",
   344							      bt656->pos);
   345	
   346					bt656->fmode = START_SEARCH;
   347					continue;
   348				}
   349	
   350				bt656->pos =
   351					cxusb_auxbuf_advance(auxbuf, bt656->pos, 4);
   352				continue;
   353			}
   354	
   355	normal_sample:
   356			if (bt656->fmode == START_SEARCH && bt656->line != 0) {
   357				unsigned char buf[64];
   358				unsigned int idx;
 > 359				unsigned int tocheck = min(sizeof(buf),
   360							   max(sizeof(buf),
   361							       maxlinesamples / 4));
   362	
   363				if (!cxusb_auxbuf_copy(auxbuf, bt656->pos + 1,
   364						       buf, tocheck)) {
   365					bt656->pos =
   366						cxusb_auxbuf_advance(auxbuf,
   367								     bt656->pos, 1);
   368					continue;
   369				}
   370	
   371				for (idx = 0; idx <= tocheck - 3; idx++)
   372					if (memcmp(buf + idx, CXUSB_BT656_COMMON, 3)
   373					    == 0)
   374						break;
   375	
   376				if (idx <= tocheck - 3) {
   377					bt656->pos =
   378						cxusb_auxbuf_advance(auxbuf,
   379								     bt656->pos, 1);
   380					continue;
   381				}
   382	
   383				cxusb_vprintk(dvbdev, BT656,
   384					      "line %u early start, pos %x\n",
   385					      bt656->line, bt656->pos);
   386	
   387				bt656->linesamples = 0;
   388				bt656->fmode = LINE_SAMPLES;
   389				continue;
   390			} else if (bt656->fmode == LINE_SAMPLES) {
   391				if (bt656->buf != NULL)
   392					*(bt656->buf++) = val;
   393	
   394				bt656->linesamples++;
   395				bt656->pos =
   396					cxusb_auxbuf_advance(auxbuf,
   397							     bt656->pos, 1);
   398	
   399				if (bt656->linesamples >= maxlinesamples) {
   400					bt656->fmode = START_SEARCH;
   401					bt656->line++;
   402				}
   403	
   404				continue;
   405			}
   406			/* TODO: copy VBI samples */
   407	
   408			bt656->pos =
   409				cxusb_auxbuf_advance(auxbuf,
   410						     bt656->pos, 1);
   411		}
   412	
   413		if (bt656->line < maxlines) {
   414			cxusb_vprintk(dvbdev, BT656, "end of buffer, pos = %u\n",
   415				      bt656->pos);
   416			return false;
   417		}
   418	
   419		return true;
   420	}
   421	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
