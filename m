Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37477 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2I2PRU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Sep 2012 11:17:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120929143205.GN4587@mwanda>
References: <20120929071253.GD10993@elgon.mountain>
	<5066D2F6.10800@bfs.de>
	<20120929143205.GN4587@mwanda>
Date: Sat, 29 Sep 2012 12:17:18 -0300
Message-ID: <CALF0-+XotD0ag4J3RwBP8i7pMVwr9q2Bv_x826jzYiWyOaQ5Nw@mail.gmail.com>
Subject: Re: [patch] [media] cx25821: testing the wrong variable
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: walter harms <wharms@bfs.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
	Thomas Meyer <thomas@m3y3r.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 29, 2012 at 11:32 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> On Sat, Sep 29, 2012 at 12:52:38PM +0200, walter harms wrote:
>>
>>
>> Am 29.09.2012 09:12, schrieb Dan Carpenter:
>> > ->input_filename could be NULL here.  The intent was to test
>> > ->_filename.
>> >
>> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> > ---
>> > I'm not totally convinced that using /root/vid411.yuv is the right idea.
>> >
>> > diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream.c b/drivers/media/pci/cx25821/cx25821-video-upstream.c
>> > index 52c13e0..6759fff 100644
>> > --- a/drivers/media/pci/cx25821/cx25821-video-upstream.c
>> > +++ b/drivers/media/pci/cx25821/cx25821-video-upstream.c
>> > @@ -808,7 +808,7 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
>> >     }
>> >
>> >     /* Default if filename is empty string */
>> > -   if (strcmp(dev->input_filename, "") == 0) {
>> > +   if (strcmp(dev->_filename, "") == 0) {
>> >             if (dev->_isNTSC) {
>> >                     dev->_filename =
>> >                             (dev->_pixel_format == PIXEL_FRMT_411) ?
>> > diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
>> > index c8c94fb..d33fc1a 100644
>> > --- a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
>> > +++ b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
>> > @@ -761,7 +761,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
>> >     }
>> >
>> >     /* Default if filename is empty string */
>> > -   if (strcmp(dev->input_filename_ch2, "") == 0) {
>> > +   if (strcmp(dev->_filename_ch2, "") == 0) {
>> >             if (dev->_isNTSC_ch2) {
>> >                     dev->_filename_ch2 = (dev->_pixel_format_ch2 ==
>> >                             PIXEL_FRMT_411) ? "/root/vid411.yuv" :
>> >
>>
>> In this case stcmp seems a bit of a overkill. A simple
>> *(dev->_filename_ch2) == 0
>> should be ok ?
>
> I prefer strcmp() actually.  More readable.
>

... and by no means an overkill.
First, it's not a hotpath or a core component. So readability is the priority.
Second, strcmp over empty string should be very very cheap (right?).
In some arches it's even some asm code.

"Premature optimization is the root of all evil".

Regards,
Ezequiel.
