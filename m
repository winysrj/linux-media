Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:23343 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaIBBmy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Sep 2014 21:42:54 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NB900MYO3FHL270@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 01 Sep 2014 21:42:53 -0400 (EDT)
Date: Mon, 01 Sep 2014 22:42:49 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Changbing Xiong <cb.xiong@samsung.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] media: check status of dmxdev->exit in poll functions
 of demux&dvr
Message-id: <20140901224249.49246419.m.chehab@samsung.com>
In-reply-to: <5405083A.3010207@iki.fi>
References: <1408586740-2169-1-git-send-email-cb.xiong@samsung.com>
 <5405083A.3010207@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 02 Sep 2014 02:58:50 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Moikka Changbing and thanks to working that.
> 
> I reviewed the first patch and tested all these patches. It does not 
> deadlock USB device anymore because of patch #1 so it is improvement. 
> However, what I expect that patch, it should force device unregister but 
> when I use tzap and unplug running device, it does not stop tzap, but 
> continues zapping until app is killed using ctrl-c.
> I used same(?) WinTV Aero for my tests.

...

> Is there any change to close all those /dev file handles when device 
> disappears?

Well, we may start returning -ENODEV when such event happens. 

At the frontend, we could use fe->exit = DVB_FE_DEVICE_REMOVED to
signalize it. I don't think that the demod frontend has something
similar.

Yet, it should be up to the userspace application to properly handle 
the error codes and close the devices on fatal non-recovery errors like
ENODEV. 

So, what we can do, at Kernel level, is to always return -ENODEV when
the device is known to be removed, and double check libdvbv5 if it
handles such error properly.

Regards,
Mauro

> 
> regards
> Antti
> 
> 
> On 08/21/2014 05:05 AM, Changbing Xiong wrote:
> > when usb-type tuner is pulled out, user applications did not close device's FD,
> > and go on polling the device, we should return POLLERR directly.
> >
> > Signed-off-by: Changbing Xiong <cb.xiong@samsung.com>
> > ---
> >   drivers/media/dvb-core/dmxdev.c |    6 +++++-
> >   1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
> > index 7a5c070..42b5e70 100755
> > --- a/drivers/media/dvb-core/dmxdev.c
> > +++ b/drivers/media/dvb-core/dmxdev.c
> > @@ -1085,9 +1085,10 @@ static long dvb_demux_ioctl(struct file *file, unsigned int cmd,
> >   static unsigned int dvb_demux_poll(struct file *file, poll_table *wait)
> >   {
> >   	struct dmxdev_filter *dmxdevfilter = file->private_data;
> > +	struct dmxdev *dmxdev = dmxdevfilter->dev;
> >   	unsigned int mask = 0;
> >
> > -	if (!dmxdevfilter)
> > +	if ((!dmxdevfilter) || (dmxdev->exit))
> >   		return POLLERR;
> >
> >   	poll_wait(file, &dmxdevfilter->buffer.queue, wait);
> > @@ -1181,6 +1182,9 @@ static unsigned int dvb_dvr_poll(struct file *file, poll_table *wait)
> >
> >   	dprintk("function : %s\n", __func__);
> >
> > +	if (dmxdev->exit)
> > +		return POLLERR;
> > +
> >   	poll_wait(file, &dmxdev->dvr_buffer.queue, wait);
> >
> >   	if ((file->f_flags & O_ACCMODE) == O_RDONLY) {
> > --
> > 1.7.9.5
> >
> 
