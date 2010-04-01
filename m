Return-path: <linux-media-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:44949 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab0DAMPB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 08:15:01 -0400
Message-ID: <4BB48A19.7080904@s5r6.in-berlin.de>
Date: Thu, 01 Apr 2010 13:57:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: V4L-DVB drivers and BKL
References: <201004011001.10500.hverkuil@xs4all.nl>
In-Reply-To: <201004011001.10500.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> I just read on LWN that the core kernel guys are putting more effort into
> removing the BKL. We are still using it in our own drivers, mostly V4L.
> 
> I added a BKL column to my driver list:
> 
> http://www.linuxtv.org/wiki/index.php/V4L_framework_progress#Bridge_Drivers
> 
> If you 'own' one of these drivers that still use BKL, then it would be nice
> if you can try and remove the use of the BKL from those drivers.
> 
> The other part that needs to be done is to move from using the .ioctl file op
> to using .unlocked_ioctl. Very few drivers do that, but I suspect almost no
> driver actually needs to use .ioctl.

Also note that struct file_operations.llseek() grabs the BKL if .llseek
= default_llseek, or if .llseek == NULL && (struct file.f_mode &
FMODE_LSEEK) != 0.

I guess V4L/DVB character device file ABIs do not involve lseek() and
friends, do they?  If so, are the files flagged as non-seekable?

> On the DVB side there seem to be only two sources that use the BKL:
> 
> linux/drivers/media/dvb/bt8xx/dst_ca.c: lock_kernel();
> linux/drivers/media/dvb/bt8xx/dst_ca.c: unlock_kernel();
> linux/drivers/media/dvb/dvb-core/dvbdev.c:      lock_kernel();
> linux/drivers/media/dvb/dvb-core/dvbdev.c:              unlock_kernel();
> linux/drivers/media/dvb/dvb-core/dvbdev.c:      unlock_kernel();
> 
> At first glance it doesn't seem too difficult to remove them, but I leave
> that to the DVB experts.

As a dvb/firewire/firedtv user, I started to mess around with dvbdev and
firedtv:  https://patchwork.kernel.org/patch/88778/
-- 
Stefan Richter
-=====-==-=- -=-- ----=
http://arcgraph.de/sr/
