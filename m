Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:10694 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaANT7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jan 2014 14:59:14 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZE00629Q6O7070@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Jan 2014 14:59:12 -0500 (EST)
Date: Tue, 14 Jan 2014 17:59:07 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 5/7] em28xx-audio: remove a deplock circular dependency
Message-id: <20140114175907.407c0d16@samsung.com>
In-reply-to: <52D58569.3000405@googlemail.com>
References: <1389567649-26838-1-git-send-email-m.chehab@samsung.com>
 <1389567649-26838-6-git-send-email-m.chehab@samsung.com>
 <52D45FC4.10106@googlemail.com> <20140114134541.1e1f2469@samsung.com>
 <52D58569.3000405@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 14 Jan 2014 19:43:53 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> On 14.01.2014 16:45, Mauro Carvalho Chehab wrote:
> > Em Mon, 13 Jan 2014 22:51:00 +0100
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >
> >> Am 13.01.2014 00:00, schrieb Mauro Carvalho Chehab:
> >>> We can't lock at pcm close, as it causes circular dependency
> >>> lock issues with .init and .fini callbacks. So, move the code
> >>> that puts the device on mute to the kthread.
> >>>
> >>>      [  322.026316] ======================================================
> >>>      [  322.026356] [ INFO: possible circular locking dependency detected ]
> >>>      [  322.026397] 3.13.0-rc1+ #24 Not tainted
> >>>      [  322.026437] -------------------------------------------------------
> >>>      [  322.026476] khubd/54 is trying to acquire lock:
> >>>      [  322.026516]  (&pcm->open_mutex){+.+.+.}, at: [<ffffffffa04819e6>] snd_pcm_dev_disconnect+0x46/0x1e0 [snd_pcm]
> >>>      [  322.026727]
> >>>      but task is already holding lock:
> >>>      [  322.026767]  (register_mutex#3){+.+.+.}, at: [<ffffffffa04819c4>] snd_pcm_dev_disconnect+0x24/0x1e0 [snd_pcm]
> >>>      [  322.027005]
> >>>      which lock already depends on the new lock.
> >>>
> >>>      [  322.027045]
> >>>      the existing dependency chain (in reverse order) is:
> >>>      [  322.027084]
> >>>      -> #2 (register_mutex#3){+.+.+.}:
> >>>      [  322.027318]        [<ffffffff810b8fa3>] __lock_acquire+0xb43/0x1330
> >>>      [  322.027401]        [<ffffffff810b9f82>] lock_acquire+0xa2/0x120
> >>>      [  322.027479]        [<ffffffff816a5b6c>] mutex_lock_nested+0x5c/0x3c0
> >>>      [  322.027559]        [<ffffffffa04819c4>] snd_pcm_dev_disconnect+0x24/0x1e0 [snd_pcm]
> >>>      [  322.027642]        [<ffffffffa02e855a>] snd_device_disconnect+0x6a/0xf0 [snd]
> >>>      [  322.027727]        [<ffffffffa02e86ac>] snd_device_disconnect_all+0x4c/0x90 [snd]
> >>>      [  322.027814]        [<ffffffffa02e1876>] snd_card_disconnect+0x126/0x1d0 [snd]
> >>>      [  322.027898]        [<ffffffffa02e1ea8>] snd_card_free+0x18/0x90 [snd]
> >>>      [  322.027982]        [<ffffffffa087235f>] em28xx_audio_fini+0x8f/0xa0 [em28xx_alsa]
> >>>      [  322.028063]        [<ffffffffa085cba6>] em28xx_close_extension+0x56/0x90 [em28xx]
> >>>      [  322.028143]        [<ffffffffa085e639>] em28xx_usb_disconnect+0x79/0x90 [em28xx]
> >>>      [  322.028222]        [<ffffffff814a06e7>] usb_unbind_interface+0x67/0x1d0
> >>>      [  322.028302]        [<ffffffff8142920f>] __device_release_driver+0x7f/0xf0
> >>>      [  322.028381]        [<ffffffff814292a5>] device_release_driver+0x25/0x40
> >>>      [  322.028462]        [<ffffffff81428b0c>] bus_remove_device+0x11c/0x1a0
> >>>      [  322.028540]        [<ffffffff81425536>] device_del+0x136/0x1d0
> >>>      [  322.028619]        [<ffffffff8149e0c0>] usb_disable_device+0xb0/0x290
> >>>      [  322.028698]        [<ffffffff814930c5>] usb_disconnect+0xb5/0x1d0
> >>>      [  322.028779]        [<ffffffff81495ab6>] hub_port_connect_change+0xd6/0xad0
> >>>      [  322.028859]        [<ffffffff814967c3>] hub_events+0x313/0x9b0
> >>>      [  322.028940]        [<ffffffff81496e95>] hub_thread+0x35/0x170
> >>>      [  322.029019]        [<ffffffff8108ea2f>] kthread+0xff/0x120
> >>>      [  322.029099]        [<ffffffff816b187c>] ret_from_fork+0x7c/0xb0
> >>>      [  322.029179]
> >>>      -> #1 (&dev->lock#2){+.+.+.}:
> >>>      [  322.029414]        [<ffffffff810b8fa3>] __lock_acquire+0xb43/0x1330
> >>>      [  322.029494]        [<ffffffff810b9f82>] lock_acquire+0xa2/0x120
> >>>      [  322.029572]        [<ffffffff816a5b6c>] mutex_lock_nested+0x5c/0x3c0
> >>>      [  322.029651]        [<ffffffffa087122e>] snd_em28xx_pcm_close+0x3e/0x100 [em28xx_alsa]
> >>>      [  322.029732]        [<ffffffffa048620f>] snd_pcm_release_substream.part.29+0x3f/0x90 [snd_pcm]
> >>>      [  322.029816]        [<ffffffffa0486340>] snd_pcm_release+0xb0/0xd0 [snd_pcm]
> >>>      [  322.029900]        [<ffffffff811c9752>] __fput+0xe2/0x230
> >>>      [  322.029979]        [<ffffffff811c98ee>] ____fput+0xe/0x10
> >>>      [  322.030057]        [<ffffffff8108b64f>] task_work_run+0x9f/0xe0
> >>>      [  322.030135]        [<ffffffff81013a81>] do_notify_resume+0x61/0xa0
> >>>      [  322.030223]        [<ffffffff816b1c62>] int_signal+0x12/0x17
> >>>      [  322.030294]
> >>>      -> #0 (&pcm->open_mutex){+.+.+.}:
> >>>      [  322.030473]        [<ffffffff810b7a47>] check_prevs_add+0x947/0x950
> >>>      [  322.030546]        [<ffffffff810b8fa3>] __lock_acquire+0xb43/0x1330
> >>>      [  322.030618]        [<ffffffff810b9f82>] lock_acquire+0xa2/0x120
> >>>      [  322.030689]        [<ffffffff816a5b6c>] mutex_lock_nested+0x5c/0x3c0
> >>>      [  322.030760]        [<ffffffffa04819e6>] snd_pcm_dev_disconnect+0x46/0x1e0 [snd_pcm]
> >>>      [  322.030835]        [<ffffffffa02e855a>] snd_device_disconnect+0x6a/0xf0 [snd]
> >>>      [  322.030913]        [<ffffffffa02e86ac>] snd_device_disconnect_all+0x4c/0x90 [snd]
> >>>      [  322.030988]        [<ffffffffa02e1876>] snd_card_disconnect+0x126/0x1d0 [snd]
> >>>      [  322.031067]        [<ffffffffa02e1ea8>] snd_card_free+0x18/0x90 [snd]
> >>>      [  322.031146]        [<ffffffffa087235f>] em28xx_audio_fini+0x8f/0xa0 [em28xx_alsa]
> >>>      [  322.031220]        [<ffffffffa085cba6>] em28xx_close_extension+0x56/0x90 [em28xx]
> >>>      [  322.031292]        [<ffffffffa085e639>] em28xx_usb_disconnect+0x79/0x90 [em28xx]
> >>>      [  322.031363]        [<ffffffff814a06e7>] usb_unbind_interface+0x67/0x1d0
> >>>      [  322.031433]        [<ffffffff8142920f>] __device_release_driver+0x7f/0xf0
> >>>      [  322.031503]        [<ffffffff814292a5>] device_release_driver+0x25/0x40
> >>>      [  322.031573]        [<ffffffff81428b0c>] bus_remove_device+0x11c/0x1a0
> >>>      [  322.031643]        [<ffffffff81425536>] device_del+0x136/0x1d0
> >>>      [  322.031714]        [<ffffffff8149e0c0>] usb_disable_device+0xb0/0x290
> >>>      [  322.031784]        [<ffffffff814930c5>] usb_disconnect+0xb5/0x1d0
> >>>      [  322.031853]        [<ffffffff81495ab6>] hub_port_connect_change+0xd6/0xad0
> >>>      [  322.031922]        [<ffffffff814967c3>] hub_events+0x313/0x9b0
> >>>      [  322.031992]        [<ffffffff81496e95>] hub_thread+0x35/0x170
> >>>      [  322.032062]        [<ffffffff8108ea2f>] kthread+0xff/0x120
> >>>      [  322.032135]        [<ffffffff816b187c>] ret_from_fork+0x7c/0xb0
> >>>      [  322.032205]
> >>>      other info that might help us debug this:
> >>>
> >>>      [  322.032240] Chain exists of:
> >>>        &pcm->open_mutex --> &dev->lock#2 --> register_mutex#3
> >>>
> >>>      [  322.032547]  Possible unsafe locking scenario:
> >>>
> >>>      [  322.032582]        CPU0                    CPU1
> >>>      [  322.032616]        ----                    ----
> >>>      [  322.032654]   lock(register_mutex#3);
> >>>      [  322.032793]                                lock(&dev->lock#2);
> >>>      [  322.032929]                                lock(register_mutex#3);
> >>>      [  322.033064]   lock(&pcm->open_mutex);
> >>>      [  322.033168]
> >>>       *** DEADLOCK ***
> I don't get it. Where is the deadlock here ???
> Mauro, be honest: did you understand what's going on here ?
> 
> >>>
> >>>      [  322.033204] 6 locks held by khubd/54:
> >>>      [  322.033239]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff81496564>] hub_events+0xb4/0x9b0
> >>>      [  322.033446]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff81493076>] usb_disconnect+0x66/0x1d0
> >>>      [  322.033655]  #2:  (&__lockdep_no_validate__){......}, at: [<ffffffff8142929d>] device_release_driver+0x1d/0x40
> >>>      [  322.033859]  #3:  (em28xx_devlist_mutex){+.+.+.}, at: [<ffffffffa085cb77>] em28xx_close_extension+0x27/0x90 [em28xx]
> >>>      [  322.034067]  #4:  (&dev->lock#2){+.+.+.}, at: [<ffffffffa085cb81>] em28xx_close_extension+0x31/0x90 [em28xx]
> >>>      [  322.034307]  #5:  (register_mutex#3){+.+.+.}, at: [<ffffffffa04819c4>] snd_pcm_dev_disconnect+0x24/0x1e0 [snd_pcm]
> >>>      [  322.034552]
> >>>      stack backtrace:
> >>>      [  322.034588] CPU: 3 PID: 54 Comm: khubd Not tainted 3.13.0-rc1+ #24
> >>>      [  322.034624] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P04ABI.013.130220.dg 02/20/2013
> >>>      [  322.034659]  ffffffff82513770 ffff880221bcd7c8 ffffffff816a03c6 ffffffff8250a810
> >>>      [  322.034832]  ffff880221bcd808 ffffffff8169a203 ffff880221bcd830 0000000000000005
> >>>      [  322.035004]  ffff8802222b2880 ffff8802222b3020 ffff8802222b3020 0000000000000006
> >>>      [  322.035187] Call Trace:
> >>>      [  322.035230]  [<ffffffff816a03c6>] dump_stack+0x45/0x56
> >>>      [  322.035276]  [<ffffffff8169a203>] print_circular_bug+0x200/0x20e
> >>>      [  322.035320]  [<ffffffff810b7a47>] check_prevs_add+0x947/0x950
> >>>      [  322.035365]  [<ffffffff8101b303>] ? native_sched_clock+0x13/0x80
> >>>      [  322.035409]  [<ffffffff810b8fa3>] __lock_acquire+0xb43/0x1330
> >>>      [  322.035454]  [<ffffffff810b9f82>] lock_acquire+0xa2/0x120
> >>>      [  322.035500]  [<ffffffffa04819e6>] ? snd_pcm_dev_disconnect+0x46/0x1e0 [snd_pcm]
> >>>      [  322.035550]  [<ffffffff816a5b6c>] mutex_lock_nested+0x5c/0x3c0
> >>>      [  322.035596]  [<ffffffffa04819e6>] ? snd_pcm_dev_disconnect+0x46/0x1e0 [snd_pcm]
> >>>      [  322.035648]  [<ffffffffa04819e6>] ? snd_pcm_dev_disconnect+0x46/0x1e0 [snd_pcm]
> >>>      [  322.035697]  [<ffffffff810b8045>] ? trace_hardirqs_on_caller+0x105/0x1d0
> >>>      [  322.035744]  [<ffffffffa04819e6>] snd_pcm_dev_disconnect+0x46/0x1e0 [snd_pcm]
> >>>      [  322.035797]  [<ffffffffa02e855a>] snd_device_disconnect+0x6a/0xf0 [snd]
> >>>      [  322.035852]  [<ffffffffa02e86ac>] snd_device_disconnect_all+0x4c/0x90 [snd]
> >>>      [  322.035904]  [<ffffffffa02e1876>] snd_card_disconnect+0x126/0x1d0 [snd]
> >>>      [  322.035957]  [<ffffffffa02e1ea8>] snd_card_free+0x18/0x90 [snd]
> >>>      [  322.036008]  [<ffffffffa087235f>] em28xx_audio_fini+0x8f/0xa0 [em28xx_alsa]
> >>>      [  322.036054]  [<ffffffffa085cba6>] em28xx_close_extension+0x56/0x90 [em28xx]
> >>>      [  322.036100]  [<ffffffffa085e639>] em28xx_usb_disconnect+0x79/0x90 [em28xx]
> >>>      [  322.036144]  [<ffffffff814a06e7>] usb_unbind_interface+0x67/0x1d0
> >>>      [  322.036188]  [<ffffffff8142920f>] __device_release_driver+0x7f/0xf0
> >>>      [  322.036231]  [<ffffffff814292a5>] device_release_driver+0x25/0x40
> >>>      [  322.036274]  [<ffffffff81428b0c>] bus_remove_device+0x11c/0x1a0
> >>>      [  322.036318]  [<ffffffff81425536>] device_del+0x136/0x1d0
> >>>      [  322.036361]  [<ffffffff8149e0c0>] usb_disable_device+0xb0/0x290
> >>>      [  322.036404]  [<ffffffff814930c5>] usb_disconnect+0xb5/0x1d0
> >>>      [  322.036447]  [<ffffffff81495ab6>] hub_port_connect_change+0xd6/0xad0
> >>>      [  322.036492]  [<ffffffff8149cb04>] ? usb_control_msg+0xd4/0x110
> >>>      [  322.036535]  [<ffffffff814967c3>] hub_events+0x313/0x9b0
> >>>      [  322.036579]  [<ffffffff810b8045>] ? trace_hardirqs_on_caller+0x105/0x1d0
> >>>      [  322.036623]  [<ffffffff81496e95>] hub_thread+0x35/0x170
> >>>      [  322.036667]  [<ffffffff810af310>] ? abort_exclusive_wait+0xb0/0xb0
> >>>      [  322.036711]  [<ffffffff81496e60>] ? hub_events+0x9b0/0x9b0
> >>>      [  322.036756]  [<ffffffff8108ea2f>] kthread+0xff/0x120
> >>>      [  322.036802]  [<ffffffff8108e930>] ? kthread_create_on_node+0x250/0x250
> >>>      [  322.036846]  [<ffffffff816b187c>] ret_from_fork+0x7c/0xb0
> >>>      [  322.036890]  [<ffffffff8108e930>] ? kthread_create_on_node+0x250/0x250
> >>>
> >>> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> >>> ---
> >>>   drivers/media/usb/em28xx/em28xx-audio.c | 10 +++++++---
> >>>   1 file changed, 7 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> >>> index cdc2fcf3e05e..5e16fcf18cac 100644
> >>> --- a/drivers/media/usb/em28xx/em28xx-audio.c
> >>> +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> >>> @@ -311,20 +311,17 @@ static int snd_em28xx_pcm_close(struct snd_pcm_substream *substream)
> >>>   	dprintk("closing device\n");
> >>>   
> >>>   	dev->mute = 1;
> >>> -	mutex_lock(&dev->lock);
> >>>   	dev->adev.users--;
> >>>   	if (atomic_read(&dev->stream_started) > 0) {
> >>>   		atomic_set(&dev->stream_started, 0);
> >>>   		schedule_work(&dev->wq_trigger);
> >>>   	}
> >>>   
> >>> -	em28xx_audio_analog_set(dev);
> >>>   	if (substream->runtime->dma_area) {
> >>>   		dprintk("freeing\n");
> >>>   		vfree(substream->runtime->dma_area);
> >>>   		substream->runtime->dma_area = NULL;
> >>>   	}
> >>> -	mutex_unlock(&dev->lock);
> >>>   
> >>>   	return 0;
> >>>   }
> >>> @@ -395,6 +392,13 @@ static void audio_trigger(struct work_struct *work)
> >>>   	} else {
> >>>   		dprintk("stopping capture");
> >>>   		em28xx_deinit_isoc_audio(dev);
> >>> +
> >>> +		/* Mute device if needed */
> >>> +		if (dev->mute) {
> >>> +			mutex_lock(&dev->lock);
> >>> +			em28xx_audio_analog_set(dev);
> >>> +			mutex_unlock(&dev->lock);
> >>> +		}
> >>>   	}
> >>>   }
> After thinking about this for a while:
> Does your patch
> 
> [PATCH] em28xx: push mutex down to extensions on .fini callback
> 
> which you've sent afterwards fix this warning, too ?

Yes, the above patch fixed the circular lock issues.

I dropped this patch.

The only patch pending to be applied on this series is patch 4.

-- 

Cheers,
Mauro
