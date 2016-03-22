Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55863 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009AbcCVRhY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2016 13:37:24 -0400
Date: Tue, 22 Mar 2016 14:37:16 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: <tiwai@suse.com>, <perex@perex.cz>, <linux-media@vger.kernel.org>,
	<alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sound/usb: fix to release stream resources from
 media_snd_device_delete()
Message-ID: <20160322143716.4164f763@recife.lan>
In-Reply-To: <56F180FE.6020104@osg.samsung.com>
References: <1458355831-9467-1-git-send-email-shuahkh@osg.samsung.com>
	<20160319091026.3f2cbaf2@recife.lan>
	<56ED54C0.7030802@osg.samsung.com>
	<56F0C39B.6090802@osg.samsung.com>
	<56F142AE.8060704@osg.samsung.com>
	<56F180FE.6020104@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 22 Mar 2016 11:29:34 -0600
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> On 03/22/2016 07:03 AM, Shuah Khan wrote:
> > On 03/21/2016 10:01 PM, Shuah Khan wrote:  
> >> On 03/19/2016 07:31 AM, Shuah Khan wrote:  
> >>> On 03/19/2016 06:10 AM, Mauro Carvalho Chehab wrote:  
> >>>> Em Fri, 18 Mar 2016 20:50:31 -0600
> >>>> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> >>>>  
> >>>>> Fix to release stream resources from media_snd_device_delete() before
> >>>>> media device is unregistered. Without this change, stream resource free
> >>>>> is attempted after the media device is unregistered which would result
> >>>>> in use-after-free errors.
> >>>>>
> >>>>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> >>>>> ---
> >>>>>
> >>>>> - Ran bind/unbind loop (1000 iteration) test on snd-usb-audio
> >>>>>   while running mc_nextgen_test loop (1000 iterations) in parallel.
> >>>>> - Ran bind/unbind and rmmod/modprobe tests on both drivers. Also
> >>>>>   generated graphs when after bind/unbind, rmmod/modprobe. Graphs
> >>>>>   look good.
> >>>>> - Note: Please apply the following patch to fix memory leak:
> >>>>>   sound/usb: Fix memory leak in media_snd_stream_delete() during unbind
> >>>>>   https://lkml.org/lkml/2016/3/16/1050  
> >>>>
> >>>> Yeah, a way better!
> >>>>
> >>>> For normal bind/unbind, it seems to be working fine. Also
> >>>> for driver's rmmod, so:
> >>>>
> >>>> Tested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>  
> 
> Takashi,
> 
> Could please ack this patch - please see below that the problem
> Mauro and I both saw ended up to a latent bug in au0828 that is
> in Linux 4.5 as well. It is now fixed.

FYI, the patches we're intending to send to fix the issues with
au0828 and snd-usb-audio are at my experimental tree:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=au0828-unbind-fixes

The patches are:

f9dca0c46f12 [media] au0828: Fix dev_state handling
d9898e2e7bb3 [media] au0828: fix au0828_v4l2_close() dev_state race condition
52a6e1f97587 [media] media-devnode: add missing mutex lock in error handler
db268d4f59c5 [media] media-device: Simplify compat32 logic
105817f85b02 sound/usb: fix to release stream resources from media_snd_device_delete()
70fafd948468 sound/usb: Fix memory leak in media_snd_stream_delete() during unbind
a78a4b10ecd3 sound/usb/media: use core routine to initialize media_device
9d8830150475 [media] media-device: use kref for media_device instance
544439bf084a [media] media-device: make topology_version u64
4e18ca9ce0c2 [media] media-device: Fix a comment
c38077d39c7e [media] media-device: get rid of the spinlock
a50d06389fdf sound/usb: fix NULL dereference in usb_audio_probe()
b39950960d2b [media] media: au0828 fix to clear enable/disable/change source handlers
d9f03ad36a9d [media] v4l2-mc: cleanup a warning
6a4f10cff976 [media] au0828: disable tuner links and cache tuner/decoder

We're running some stress tests today, so we may need to send a few
other patches later on, but I guess they'll be either at au0828 or
at the media core.

Regards,
Mauro
