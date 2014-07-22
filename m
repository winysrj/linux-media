Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:46134 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaGVAvr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 20:51:47 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N93009749297H60@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Jul 2014 20:51:45 -0400 (EDT)
Date: Mon, 21 Jul 2014 21:51:40 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL] SDR stuff
Message-id: <20140721215140.35935811.m.chehab@samsung.com>
In-reply-to: <53CDAB73.8050108@iki.fi>
References: <53C874F8.3020300@iki.fi>
 <20140721205005.28e2e784.m.chehab@samsung.com> <53CDAB73.8050108@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 22 Jul 2014 03:08:19 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> So what. Those were mostly WARNING only and all but long lines were some 
> new checks added to checkpatch recently. chekcpatch gets all the time 
> new and new checks, these were added after I have made that driver. I 
> will surely clean those later when I do some new changes to driver and 
> my checkpatch updates.

Antti,

I think you didn't read my comments in the middle of the checkpatch stuff.
Please read my email again. I'm not requiring you to fix the newer checkpatch
warning (Missing a blank line after declarations), and not even about the
80-cols warning. The thing is that there are two issues there:

1) you're adding API bits at msi2500 driver, instead of moving them
   to videodev2.h (or reusing the fourcc types you already added there);

2) you're handling jiffies wrong inside the driver.

As you may know, adding a driver at staging is easier than at the main
tree, as we don't care much about checkpatch issues (and not even about
some more serious issues). However, when moving stuff out of staging,
we review the entire driver again, to be sure that it is ok.

Regards,
Mauro

> 
> 
> regards
> Antti
> 
> 
> 
> On 07/22/2014 02:50 AM, Mauro Carvalho Chehab wrote:
> > Em Fri, 18 Jul 2014 04:14:32 +0300
> > Antti Palosaari <crope@iki.fi> escreveu:
> >
> >> * AirSpy SDR driver
> >> * all SDR drivers moved out of staging
> >> * few new SDR stream formats
> >>
> >> regards
> >> Antti
> >>
> >>
> >> The following changes since commit 3445857b22eafb70a6ac258979e955b116bfd2c6:
> >>
> >>     [media] hdpvr: fix two audio bugs (2014-07-04 15:13:02 -0300)
> >>
> >> are available in the git repository at:
> >>
> >>     git://linuxtv.org/anttip/media_tree.git sdr_pull
> >>
> >> for you to fetch changes up to 1c3378e1c17d6acd9b6d392ff75addad4c63cc6c:
> >>
> >>     MAINTAINERS: add airspy driver (2014-07-18 04:12:27 +0300)
> >>
> >> ----------------------------------------------------------------
> >> Antti Palosaari (23):
> >>         v4l: uapi: add SDR format RU12LE
> >>         DocBook: V4L: add V4L2_SDR_FMT_RU12LE - 'RU12'
> >>         airspy: AirSpy SDR driver
> >>         v4l: uapi: add SDR format CS8
> >>         DocBook: V4L: add V4L2_SDR_FMT_CS8 - 'CS08'
> >>         v4l: uapi: add SDR format CS14
> >>         DocBook: V4L: add V4L2_SDR_FMT_CS14LE - 'CS14'
> >>         msi001: move out of staging
> >>         MAINTAINERS: update MSI001 driver location
> >>         Kconfig: add SDR support
> >>         Kconfig: sub-driver auto-select SPI bus
> >>         msi2500: move msi3101 out of staging and rename
> >
> > There are several issues pointed by checkpath on this driver:
> >
> > WARNING: line over 80 characters
> > #55: FILE: drivers/media/usb/msi2500/msi2500.c:55:
> > +#define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
> >
> > WARNING: line over 80 characters
> > #56: FILE: drivers/media/usb/msi2500/msi2500.c:56:
> > +#define V4L2_PIX_FMT_SDR_S12    v4l2_fourcc('D', 'S', '1', '2') /* signed 12-bit */
> >
> > WARNING: line over 80 characters
> > #57: FILE: drivers/media/usb/msi2500/msi2500.c:57:
> > +#define V4L2_PIX_FMT_SDR_S14    v4l2_fourcc('D', 'S', '1', '4') /* signed 14-bit */
> >
> > WARNING: line over 80 characters
> > #58: FILE: drivers/media/usb/msi2500/msi2500.c:58:
> > +#define V4L2_PIX_FMT_SDR_MSI2500_384 v4l2_fourcc('M', '3', '8', '4') /* Mirics MSi2500 format 384 */
> >
> > The above are OK, however those formats should be moved to videodev2.h,
> > where those API bits belong.
> >
> > There are several warnings, not all are mandatory for moving it out of
> > staging. I'll point the critical ones below:
> >
> > WARNING: Missing a blank line after declarations
> > #135: FILE: drivers/media/usb/msi2500/msi2500.c:135:
> > +	struct urb *urbs[MAX_ISO_BUFS];
> > +	int (*convert_stream)(struct msi3101_state *s, u8 *dst, u8 *src,
> >
> > WARNING: line over 80 characters
> > #188: FILE: drivers/media/usb/msi2500/msi2500.c:188:
> > +		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
> >
> > WARNING: Comparing jiffies is almost always wrong; prefer time_after, time_before and friends
> > #211: FILE: drivers/media/usb/msi2500/msi2500.c:211:
> > +	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
> >
> > This one is a real bug, as jiffies may reset to zero. you should, instead,
> > use the time macros, like time_is_before_jiffies() and
> > time_is_after_jiffies().
> >
> > WARNING: line over 80 characters
> > #213: FILE: drivers/media/usb/msi2500/msi2500.c:213:
> > +		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
> >
> > This also seems wrong for the same reasons.
> >
> > WARNING: Missing a blank line after declarations
> > #215: FILE: drivers/media/usb/msi2500/msi2500.c:215:
> > +		unsigned int samples = sample_num[i_max - 1] - s->sample;
> > +		s->jiffies_next = jiffies_now;
> >
> > WARNING: line over 80 characters
> > #242: FILE: drivers/media/usb/msi2500/msi2500.c:242:
> > +		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
> >
> > WARNING: Missing a blank line after declarations
> > #272: FILE: drivers/media/usb/msi2500/msi2500.c:272:
> > +		unsigned int samples = sample_num[i_max - 1] - s->sample;
> > +		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
> >
> > WARNING: line over 80 characters
> > #339: FILE: drivers/media/usb/msi2500/msi2500.c:339:
> > +		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
> >
> > WARNING: Comparing jiffies is almost always wrong; prefer time_after, time_before and friends
> > #363: FILE: drivers/media/usb/msi2500/msi2500.c:363:
> > +	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
> >
> > Same here.
> >
> > WARNING: line over 80 characters
> > #365: FILE: drivers/media/usb/msi2500/msi2500.c:365:
> > +		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
> >
> > Same here.
> >
> > WARNING: Missing a blank line after declarations
> > #367: FILE: drivers/media/usb/msi2500/msi2500.c:367:
> > +		unsigned int samples = sample_num[i_max - 1] - s->sample;
> > +		s->jiffies_next = jiffies_now;
> >
> > WARNING: line over 80 characters
> > #405: FILE: drivers/media/usb/msi2500/msi2500.c:405:
> > +		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
> >
> > WARNING: Comparing jiffies is almost always wrong; prefer time_after, time_before and friends
> > #428: FILE: drivers/media/usb/msi2500/msi2500.c:428:
> > +	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
> >
> > Same here.
> >
> > WARNING: line over 80 characters
> > #430: FILE: drivers/media/usb/msi2500/msi2500.c:430:
> > +		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
> >
> > WARNING: Missing a blank line after declarations
> > #432: FILE: drivers/media/usb/msi2500/msi2500.c:432:
> > +		unsigned int samples = sample_num[i_max - 1] - s->sample;
> > +		s->jiffies_next = jiffies_now;
> >
> > WARNING: line over 80 characters
> > #468: FILE: drivers/media/usb/msi2500/msi2500.c:468:
> > +		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
> >
> > WARNING: Comparing jiffies is almost always wrong; prefer time_after, time_before and friends
> > #491: FILE: drivers/media/usb/msi2500/msi2500.c:491:
> > +	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
> >
> > Same here.
> >
> > WARNING: line over 80 characters
> > #493: FILE: drivers/media/usb/msi2500/msi2500.c:493:
> > +		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
> >
> > Same here.
> >
> > WARNING: Missing a blank line after declarations
> > #495: FILE: drivers/media/usb/msi2500/msi2500.c:495:
> > +		unsigned int samples = sample_num[i_max - 1] - s->sample;
> > +		s->jiffies_next = jiffies_now;
> >
> > ERROR: space required after that ';' (ctx:VxV)
> > #515: FILE: drivers/media/usb/msi2500/msi2500.c:515:
> > +	struct {signed int x:14;} se;
> >   	                       ^
> >
> > Better to declare it as:
> > 	struct {
> > 		signed int x:14;
> > 	} se;
> >
> > That makes easier to read, IMHO, and follows Kernel CodingStyle.
> >
> > WARNING: line over 80 characters
> > #521: FILE: drivers/media/usb/msi2500/msi2500.c:521:
> > +		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
> >
> > WARNING: Missing a blank line after declarations
> > #567: FILE: drivers/media/usb/msi2500/msi2500.c:567:
> > +		unsigned int samples = sample_num[i_max - 1] - s->sample;
> > +		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
> >
> > WARNING: Missing a blank line after declarations
> > #661: FILE: drivers/media/usb/msi2500/msi2500.c:661:
> > +	int i;
> > +	dev_dbg(&s->udev->dev, "%s:\n", __func__);
> >
> > WARNING: Missing a blank line after declarations
> > #676: FILE: drivers/media/usb/msi2500/msi2500.c:676:
> > +	int i;
> > +	dev_dbg(&s->udev->dev, "%s:\n", __func__);
> >
> > WARNING: Missing a blank line after declarations
> > #709: FILE: drivers/media/usb/msi2500/msi2500.c:709:
> > +	int i, j, ret;
> > +	dev_dbg(&s->udev->dev, "%s:\n", __func__);
> >
> > WARNING: Missing a blank line after declarations
> > #775: FILE: drivers/media/usb/msi2500/msi2500.c:775:
> > +	unsigned long flags = 0;
> > +	dev_dbg(&s->udev->dev, "%s:\n", __func__);
> >
> > WARNING: Missing a blank line after declarations
> > #814: FILE: drivers/media/usb/msi2500/msi2500.c:814:
> > +	struct msi3101_state *s = video_drvdata(file);
> > +	dev_dbg(&s->udev->dev, "%s:\n", __func__);
> >
> > WARNING: Missing a blank line after declarations
> > #831: FILE: drivers/media/usb/msi2500/msi2500.c:831:
> > +	struct msi3101_state *s = vb2_get_drv_priv(vq);
> > +	dev_dbg(&s->udev->dev, "%s: *nbuffers=%d\n", __func__, *nbuffers);
> >
> > WARNING: line over 80 characters
> > #879: FILE: drivers/media/usb/msi2500/msi2500.c:879:
> > +			_i & 0xff, _i >> 8, l & 0xff, l >> 8, direction, l, b); \
> >
> > WARNING: line over 80 characters
> > #915: FILE: drivers/media/usb/msi2500/msi2500.c:915:
> > +	bandwidth_auto = v4l2_ctrl_find(&s->hdl, V4L2_CID_RF_TUNER_BANDWIDTH_AUTO);
> >
> > WARNING: line over 80 characters
> > #917: FILE: drivers/media/usb/msi2500/msi2500.c:917:
> > +		bandwidth = v4l2_ctrl_find(&s->hdl, V4L2_CID_RF_TUNER_BANDWIDTH);
> >
> > WARNING: line over 80 characters
> > #1012: FILE: drivers/media/usb/msi2500/msi2500.c:1012:
> > +			__func__, f_sr, f_vco, div_n, div_m, div_r_out, reg3, reg4);
> >
> > WARNING: Missing a blank line after declarations
> > #1053: FILE: drivers/media/usb/msi2500/msi2500.c:1053:
> > +	int ret;
> > +	dev_dbg(&s->udev->dev, "%s:\n", __func__);
> >
> > WARNING: Missing a blank line after declarations
> > #1116: FILE: drivers/media/usb/msi2500/msi2500.c:1116:
> > +	struct msi3101_state *s = video_drvdata(file);
> > +	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, f->index);
> >
> > WARNING: Missing a blank line after declarations
> > #1131: FILE: drivers/media/usb/msi2500/msi2500.c:1131:
> > +	struct msi3101_state *s = video_drvdata(file);
> > +	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
> >
> > WARNING: Missing a blank line after declarations
> > #1146: FILE: drivers/media/usb/msi2500/msi2500.c:1146:
> > +	int i;
> > +	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
> >
> > WARNING: Missing a blank line after declarations
> > #1171: FILE: drivers/media/usb/msi2500/msi2500.c:1171:
> > +	int i;
> > +	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
> >
> > WARNING: Missing a blank line after declarations
> > #1190: FILE: drivers/media/usb/msi2500/msi2500.c:1190:
> > +	int ret;
> > +	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, v->index);
> >
> > WARNING: Missing a blank line after declarations
> > #1206: FILE: drivers/media/usb/msi2500/msi2500.c:1206:
> > +	int ret;
> > +	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, v->index);
> >
> > WARNING: Missing a blank line after declarations
> > #1229: FILE: drivers/media/usb/msi2500/msi2500.c:1229:
> > +	int ret  = 0;
> > +	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d\n",
> >
> > WARNING: Missing a blank line after declarations
> > #1250: FILE: drivers/media/usb/msi2500/msi2500.c:1250:
> > +	int ret;
> > +	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d frequency=%u\n",
> >
> > WARNING: Missing a blank line after declarations
> > #1274: FILE: drivers/media/usb/msi2500/msi2500.c:1274:
> > +	int ret;
> > +	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d index=%d\n",
> >
> > total: 1 errors, 45 warnings, 1517 lines checked
> >
> > drivers/media/usb/msi2500/msi2500.c has style problems, please review.
> >
> > Regards,
> > Mauro
> >
> 
