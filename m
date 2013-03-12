Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcdn-iport-2.cisco.com ([173.37.86.73]:7276 "EHLO
	rcdn-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab3CLPge (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 11:36:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Volokh Konstantin <volokh84@gmail.com>
Subject: Re: [PATCH 2/2] hverkuil/go7007: staging: media: go7007: rmmod firmware protection stuff
Date: Tue, 12 Mar 2013 16:26:33 +0100
Cc: linux-media@vger.kernel.org
References: <1363100970-11080-1-git-send-email-volokh84@gmail.com> <1363100970-11080-2-git-send-email-volokh84@gmail.com>
In-Reply-To: <1363100970-11080-2-git-send-email-volokh84@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303121626.33410.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 12 March 2013 16:09:30 Volokh Konstantin wrote:
> If firmware wasn`t load, rmmod fail with oops:
> 
> usbcore: deregistering interface driver go7007
> BUG: unable to handle kernel NULL pointer dereference at           (null)
> IP: [<ffffffff81797d02>] __mutex_lock_slowpath+0xa2/0x140
> PGD 13143b067 PUD 132a52067 PMD 0
> Oops: 0002 [#1] SMP
> Modules linked in: go7007_usb(C-) go7007(C) videobuf2_core bttv videobuf_dma_sg videobuf_core btcx_risc rc_core v4l2_common videodev videobuf2_vmalloc videobuf2_memops tveeprom
> CPU 0
> Pid: 3305, comm: rmmod Tainted: G         C   3.9.0-rc1+ #4 To Be Filled By O.E.M. To Be Filled By O.E.M./H55MX-S Series
> RIP: 0010:[<ffffffff81797d02>]  [<ffffffff81797d02>] __mutex_lock_slowpath+0xa2/0x140
> RSP: 0018:ffff88013220bd18  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff880132264c80 RCX: 00000000ffffffff
> RDX: ffff88013220bd20 RSI: ffff880130d3ecc0 RDI: ffff880132264c84
> RBP: ffff88013220bd68 R08: 0000000000000000 R09: ffffea0004c5c940
> R10: ffffffff811a08d3 R11: 0000000000027854 R12: ffff880132264c84
> R13: ffff8801325ec410 R14: 00000000ffffffff R15: ffff880132264c88
> Mar 12 01:25:57 Video kernel: [  128.939419] FS:  00007fb32649d700(0000) GS:ffff880137c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000130f1d000 CR4: 00000000000007f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process rmmod (pid: 3305, threadinfo ffff88013220a000, task ffff8801325ec410)
> Stack:
> ffff88013220bd48 ffff880132264c88 0000000000000000 ffff880131abf800
> ffff880130d3ecc0 ffff880132264c80 ffff880132264c80 ffff880132264478
> ffff880132264000 0000000000000000 ffff88013220bd88 ffffffff81797c05
> Call Trace:
>  [<ffffffff81797c05>] mutex_lock+0x25/0x40
>  [<ffffffffa0090051>] go7007_usb_disconnect+0x41/0xb0 [go7007_usb]
>  [<ffffffff814b105b>] usb_unbind_interface+0x5b/0x130
>  [<ffffffff813f0a71>] __device_release_driver+0x61/0xd0
>  [<ffffffff813f1340>] driver_detach+0xb0/0xc0
>  [<ffffffff813f0859>] bus_remove_driver+0x79/0xd0
>  [<ffffffff813f19da>] driver_unregister+0x5a/0x90
>  [<ffffffff814b0d64>] usb_deregister+0x64/0xd0
>  [<ffffffffa00914dc>] go7007_usb_driver_exit+0x10/0x12 [go7007_usb]
>  [<ffffffff8109370c>] sys_delete_module+0x15c/0x240
>  [<ffffffff817a1d12>] system_call_fastpath+0x16/0x1b
> Code: 00 4c 8d 63 04 4c 8d 7b 08 41 be ff ff ff ff 4c 89 e7 e8 92 26 00 00 48 8b 43 10 48 8d 55 b8 4c 89 7d b8 48 89 53 10 48 89 45 c0 <48> 89 10 44 89 f0 4c 89 6d c8 87 03 83 f8 01 75 1f eb 27 0f 1f
> RIP  [<ffffffff81797d02>] __mutex_lock_slowpath+0xa2/0x140
> RSP <ffff88013220bd18>
> CR2: 0000000000000000
> 

It's clearly a bug, but I'm not sure this is the right approach. If the firmware
can't be loaded, then the probe() should just exit with an error.

I also need to check the use of the 'status' field, I never trust that sort of
thing.

Regards,

	Hans

> Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
> ---
>  drivers/staging/media/go7007/go7007-usb.c |   25 +++++++++++++------------
>  1 files changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
> index bd23d7d..48ad01f 100644
> --- a/drivers/staging/media/go7007/go7007-usb.c
> +++ b/drivers/staging/media/go7007/go7007-usb.c
> @@ -1316,18 +1316,19 @@ static void go7007_usb_disconnect(struct usb_interface *intf)
>  {
>  	struct go7007 *go = to_go7007(usb_get_intfdata(intf));
>  
> -	mutex_lock(&go->queue_lock);
> -	mutex_lock(&go->serialize_lock);
> -
> -	if (go->audio_enabled)
> -		go7007_snd_remove(go);
> -
> -	go->status = STATUS_SHUTDOWN;
> -	v4l2_device_disconnect(&go->v4l2_dev);
> -	video_unregister_device(&go->vdev);
> -	mutex_unlock(&go->serialize_lock);
> -	mutex_unlock(&go->queue_lock);
> -
> +	if (go->status == STATUS_ONLINE) {
> +		mutex_lock(&go->queue_lock);
> +		mutex_lock(&go->serialize_lock);
> +
> +		if (go->audio_enabled)
> +			go7007_snd_remove(go);
> +
> +		go->status = STATUS_SHUTDOWN;
> +		v4l2_device_disconnect(&go->v4l2_dev);
> +		video_unregister_device(&go->vdev);
> +		mutex_unlock(&go->serialize_lock);
> +		mutex_unlock(&go->queue_lock);
> +	}
>  	v4l2_device_put(&go->v4l2_dev);
>  }
>  
> 
