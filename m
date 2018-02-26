Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:40410 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752172AbeBZHtR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 02:49:17 -0500
Date: Mon, 26 Feb 2018 15:49:00 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: kbuild-all@01.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] media: ttpci/ttusb: add extra parameter to filter
 callbacks
Message-ID: <201802261522.Dolnjq5Z%fengguang.wu@intel.com>
References: <06bf50688ac75f5ee7af2cd2a9ae0d292f3002b9.1519404222.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <06bf50688ac75f5ee7af2cd2a9ae0d292f3002b9.1519404222.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Mauro,

I love your patch! Yet something to improve:

[auto build test ERROR on linuxtv-media/master]
[also build test ERROR on v4.16-rc3 next-20180223]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Mauro-Carvalho-Chehab/media-ttpci-ttusb-add-extra-parameter-to-filter-callbacks/20180226-144150
base:   git://linuxtv.org/media_tree.git master
config: i386-randconfig-x019-201808 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

   drivers/media/usb/ttusb-dec/ttusb_dec.c: In function 'ttusb_dec_audio_pes2ts_cb':
>> drivers/media/usb/ttusb-dec/ttusb_dec.c:430:2: error: too many arguments to function 'dec->audio_filter->feed->cb.ts'
     dec->audio_filter->feed->cb.ts(data, 188, NULL, 0,
     ^~~
   drivers/media/usb/ttusb-dec/ttusb_dec.c: In function 'ttusb_dec_video_pes2ts_cb':
>> drivers/media/usb/ttusb-dec/ttusb_dec.c:440:2: error: too many arguments to function 'dec->video_filter->feed->cb.ts'
     dec->video_filter->feed->cb.ts(data, 188, NULL, 0,
     ^~~
   drivers/media/usb/ttusb-dec/ttusb_dec.c: In function 'ttusb_dec_process_pva':
   drivers/media/usb/ttusb-dec/ttusb_dec.c:492:4: error: too many arguments to function 'dec->video_filter->feed->cb.ts'
       dec->video_filter->feed->cb.ts(pva, length, NULL, 0,
       ^~~
   drivers/media/usb/ttusb-dec/ttusb_dec.c:553:4: error: too many arguments to function 'dec->audio_filter->feed->cb.ts'
       dec->audio_filter->feed->cb.ts(pva, length, NULL, 0,
       ^~~
   drivers/media/usb/ttusb-dec/ttusb_dec.c: In function 'ttusb_dec_process_filter':
>> drivers/media/usb/ttusb-dec/ttusb_dec.c:591:3: error: too many arguments to function 'filter->feed->cb.sec'
      filter->feed->cb.sec(&packet[2], length - 2, NULL, 0,
      ^~~~~~

vim +430 drivers/media/usb/ttusb-dec/ttusb_dec.c

^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  425  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  426  static int ttusb_dec_audio_pes2ts_cb(void *priv, unsigned char *data)
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  427  {
f961e71a0 drivers/media/dvb/ttusb-dec/ttusb_dec.c Alex Woods            2006-01-09  428  	struct ttusb_dec *dec = priv;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  429  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16 @430  	dec->audio_filter->feed->cb.ts(data, 188, NULL, 0,
daaf93025 drivers/media/usb/ttusb-dec/ttusb_dec.c Mauro Carvalho Chehab 2018-02-23  431  				       &dec->audio_filter->feed->feed.ts, NULL);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  432  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  433  	return 0;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  434  }
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  435  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  436  static int ttusb_dec_video_pes2ts_cb(void *priv, unsigned char *data)
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  437  {
f961e71a0 drivers/media/dvb/ttusb-dec/ttusb_dec.c Alex Woods            2006-01-09  438  	struct ttusb_dec *dec = priv;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  439  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16 @440  	dec->video_filter->feed->cb.ts(data, 188, NULL, 0,
daaf93025 drivers/media/usb/ttusb-dec/ttusb_dec.c Mauro Carvalho Chehab 2018-02-23  441  				       &dec->video_filter->feed->feed.ts, NULL);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  442  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  443  	return 0;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  444  }
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  445  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  446  static void ttusb_dec_set_pids(struct ttusb_dec *dec)
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  447  {
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  448  	u8 b[] = { 0x00, 0x00, 0x00, 0x00,
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  449  		   0x00, 0x00, 0xff, 0xff,
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  450  		   0xff, 0xff, 0xff, 0xff };
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  451  
d4f979a9e drivers/media/dvb/ttusb-dec/ttusb_dec.c Al Viro               2008-05-21  452  	__be16 pcr = htons(dec->pid[DMX_PES_PCR]);
d4f979a9e drivers/media/dvb/ttusb-dec/ttusb_dec.c Al Viro               2008-05-21  453  	__be16 audio = htons(dec->pid[DMX_PES_AUDIO]);
d4f979a9e drivers/media/dvb/ttusb-dec/ttusb_dec.c Al Viro               2008-05-21  454  	__be16 video = htons(dec->pid[DMX_PES_VIDEO]);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  455  
e9815ceea drivers/media/dvb/ttusb-dec/ttusb_dec.c Harvey Harrison       2008-04-08  456  	dprintk("%s\n", __func__);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  457  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  458  	memcpy(&b[0], &pcr, 2);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  459  	memcpy(&b[2], &audio, 2);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  460  	memcpy(&b[4], &video, 2);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  461  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  462  	ttusb_dec_send_command(dec, 0x50, sizeof(b), b, NULL, NULL);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  463  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  464  	dvb_filter_pes2ts_init(&dec->a_pes2ts, dec->pid[DMX_PES_AUDIO],
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  465  			       ttusb_dec_audio_pes2ts_cb, dec);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  466  	dvb_filter_pes2ts_init(&dec->v_pes2ts, dec->pid[DMX_PES_VIDEO],
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  467  			       ttusb_dec_video_pes2ts_cb, dec);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  468  	dec->v_pes_length = 0;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  469  	dec->v_pes_postbytes = 0;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  470  }
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  471  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  472  static void ttusb_dec_process_pva(struct ttusb_dec *dec, u8 *pva, int length)
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  473  {
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  474  	if (length < 8) {
e9815ceea drivers/media/dvb/ttusb-dec/ttusb_dec.c Harvey Harrison       2008-04-08  475  		printk("%s: packet too short - discarding\n", __func__);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  476  		return;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  477  	}
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  478  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  479  	if (length > 8 + MAX_PVA_LENGTH) {
e9815ceea drivers/media/dvb/ttusb-dec/ttusb_dec.c Harvey Harrison       2008-04-08  480  		printk("%s: packet too long - discarding\n", __func__);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  481  		return;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  482  	}
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  483  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  484  	switch (pva[2]) {
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  485  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  486  	case 0x01: {		/* VideoStream */
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  487  		int prebytes = pva[5] & 0x03;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  488  		int postbytes = (pva[5] & 0x0c) >> 2;
d4f979a9e drivers/media/dvb/ttusb-dec/ttusb_dec.c Al Viro               2008-05-21  489  		__be16 v_pes_payload_length;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  490  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  491  		if (output_pva) {
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16 @492  			dec->video_filter->feed->cb.ts(pva, length, NULL, 0,
daaf93025 drivers/media/usb/ttusb-dec/ttusb_dec.c Mauro Carvalho Chehab 2018-02-23  493  				&dec->video_filter->feed->feed.ts, NULL);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  494  			return;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  495  		}
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  496  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  497  		if (dec->v_pes_postbytes > 0 &&
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  498  		    dec->v_pes_postbytes == prebytes) {
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  499  			memcpy(&dec->v_pes[dec->v_pes_length],
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  500  			       &pva[12], prebytes);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  501  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  502  			dvb_filter_pes2ts(&dec->v_pes2ts, dec->v_pes,
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  503  					  dec->v_pes_length + prebytes, 1);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  504  		}
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  505  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  506  		if (pva[5] & 0x10) {
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  507  			dec->v_pes[7] = 0x80;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  508  			dec->v_pes[8] = 0x05;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  509  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  510  			dec->v_pes[9] = 0x21 | ((pva[8] & 0xc0) >> 5);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  511  			dec->v_pes[10] = ((pva[8] & 0x3f) << 2) |
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  512  					 ((pva[9] & 0xc0) >> 6);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  513  			dec->v_pes[11] = 0x01 |
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  514  					 ((pva[9] & 0x3f) << 2) |
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  515  					 ((pva[10] & 0x80) >> 6);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  516  			dec->v_pes[12] = ((pva[10] & 0x7f) << 1) |
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  517  					 ((pva[11] & 0xc0) >> 7);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  518  			dec->v_pes[13] = 0x01 | ((pva[11] & 0x7f) << 1);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  519  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  520  			memcpy(&dec->v_pes[14], &pva[12 + prebytes],
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  521  			       length - 12 - prebytes);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  522  			dec->v_pes_length = 14 + length - 12 - prebytes;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  523  		} else {
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  524  			dec->v_pes[7] = 0x00;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  525  			dec->v_pes[8] = 0x00;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  526  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  527  			memcpy(&dec->v_pes[9], &pva[8], length - 8);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  528  			dec->v_pes_length = 9 + length - 8;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  529  		}
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  530  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  531  		dec->v_pes_postbytes = postbytes;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  532  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  533  		if (dec->v_pes[9 + dec->v_pes[8]] == 0x00 &&
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  534  		    dec->v_pes[10 + dec->v_pes[8]] == 0x00 &&
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  535  		    dec->v_pes[11 + dec->v_pes[8]] == 0x01)
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  536  			dec->v_pes[6] = 0x84;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  537  		else
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  538  			dec->v_pes[6] = 0x80;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  539  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  540  		v_pes_payload_length = htons(dec->v_pes_length - 6 +
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  541  					     postbytes);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  542  		memcpy(&dec->v_pes[4], &v_pes_payload_length, 2);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  543  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  544  		if (postbytes == 0)
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  545  			dvb_filter_pes2ts(&dec->v_pes2ts, dec->v_pes,
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  546  					  dec->v_pes_length, 1);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  547  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  548  		break;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  549  	}
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  550  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  551  	case 0x02:		/* MainAudioStream */
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  552  		if (output_pva) {
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  553  			dec->audio_filter->feed->cb.ts(pva, length, NULL, 0,
daaf93025 drivers/media/usb/ttusb-dec/ttusb_dec.c Mauro Carvalho Chehab 2018-02-23  554  				&dec->audio_filter->feed->feed.ts, NULL);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  555  			return;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  556  		}
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  557  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  558  		dvb_filter_pes2ts(&dec->a_pes2ts, &pva[8], length - 8,
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  559  				  pva[5] & 0x10);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  560  		break;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  561  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  562  	default:
e9815ceea drivers/media/dvb/ttusb-dec/ttusb_dec.c Harvey Harrison       2008-04-08  563  		printk("%s: unknown PVA type: %02x.\n", __func__,
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  564  		       pva[2]);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  565  		break;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  566  	}
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  567  }
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  568  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  569  static void ttusb_dec_process_filter(struct ttusb_dec *dec, u8 *packet,
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  570  				     int length)
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  571  {
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  572  	struct list_head *item;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  573  	struct filter_info *finfo;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  574  	struct dvb_demux_filter *filter = NULL;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  575  	unsigned long flags;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  576  	u8 sid;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  577  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  578  	sid = packet[1];
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  579  	spin_lock_irqsave(&dec->filter_info_list_lock, flags);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  580  	for (item = dec->filter_info_list.next; item != &dec->filter_info_list;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  581  	     item = item->next) {
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  582  		finfo = list_entry(item, struct filter_info, filter_info_list);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  583  		if (finfo->stream_id == sid) {
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  584  			filter = finfo->filter;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  585  			break;
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  586  		}
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  587  	}
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  588  	spin_unlock_irqrestore(&dec->filter_info_list_lock, flags);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  589  
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  590  	if (filter)
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16 @591  		filter->feed->cb.sec(&packet[2], length - 2, NULL, 0,
daaf93025 drivers/media/usb/ttusb-dec/ttusb_dec.c Mauro Carvalho Chehab 2018-02-23  592  				     &filter->filter, NULL);
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  593  }
^1da177e4 drivers/media/dvb/ttusb-dec/ttusb_dec.c Linus Torvalds        2005-04-16  594  

:::::: The code at line 430 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--sm4nu43k4a2Rpi4c
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--sm4nu43k4a2Rpi4c--
