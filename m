Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57342 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaAMRcF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 12:32:05 -0500
Message-ID: <52D42312.5020506@iki.fi>
Date: Mon, 13 Jan 2014 19:32:02 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] em28xx: push mutex down to extensions on .fini callback
References: <1389593524-1676-1-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389593524-1676-1-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tested-by: Antti Palosaari <crope@iki.fi>

regards
Antti

On 13.01.2014 08:12, Mauro Carvalho Chehab wrote:
> Avoid circular mutex lock by pushing the dev->lock to the .fini
> callback on each extension.
>
> As em28xx-dvb, em28xx-alsa and em28xx-rc have their own data
> structures, and don't touch at the common structure during .fini,
> only em28xx-v4l needs to be locked.
>
> [   90.994317] ======================================================
> [   90.994356] [ INFO: possible circular locking dependency detected ]
> [   90.994395] 3.13.0-rc1+ #24 Not tainted
> [   90.994427] -------------------------------------------------------
> [   90.994458] khubd/54 is trying to acquire lock:
> [   90.994490]  (&card->controls_rwsem){++++.+}, at: [<ffffffffa0177b08>] snd_ctl_dev_free+0x28/0x60 [snd]
> [   90.994656]
> [   90.994656] but task is already holding lock:
> [   90.994688]  (&dev->lock){+.+.+.}, at: [<ffffffffa040db81>] em28xx_close_extension+0x31/0x90 [em28xx]
> [   90.994843]
> [   90.994843] which lock already depends on the new lock.
> [   90.994843]
> [   90.994874]
> [   90.994874] the existing dependency chain (in reverse order) is:
> [   90.994905]
> -> #1 (&dev->lock){+.+.+.}:
> [   90.995057]        [<ffffffff810b8fa3>] __lock_acquire+0xb43/0x1330
> [   90.995121]        [<ffffffff810b9f82>] lock_acquire+0xa2/0x120
> [   90.995182]        [<ffffffff816a5b6c>] mutex_lock_nested+0x5c/0x3c0
> [   90.995245]        [<ffffffffa0422cca>] em28xx_vol_put_mute+0x1ba/0x1d0 [em28xx_alsa]
> [   90.995309]        [<ffffffffa017813d>] snd_ctl_elem_write+0xfd/0x140 [snd]
> [   90.995376]        [<ffffffffa01791c2>] snd_ctl_ioctl+0xe2/0x810 [snd]
> [   90.995442]        [<ffffffff811db8b0>] do_vfs_ioctl+0x300/0x520
> [   90.995504]        [<ffffffff811dbb51>] SyS_ioctl+0x81/0xa0
> [   90.995568]        [<ffffffff816b1929>] system_call_fastpath+0x16/0x1b
> [   90.995630]
> -> #0 (&card->controls_rwsem){++++.+}:
> [   90.995780]        [<ffffffff810b7a47>] check_prevs_add+0x947/0x950
> [   90.995841]        [<ffffffff810b8fa3>] __lock_acquire+0xb43/0x1330
> [   90.995901]        [<ffffffff810b9f82>] lock_acquire+0xa2/0x120
> [   90.995962]        [<ffffffff816a762b>] down_write+0x3b/0xa0
> [   90.996022]        [<ffffffffa0177b08>] snd_ctl_dev_free+0x28/0x60 [snd]
> [   90.996088]        [<ffffffffa017a255>] snd_device_free+0x65/0x140 [snd]
> [   90.996154]        [<ffffffffa017a751>] snd_device_free_all+0x61/0xa0 [snd]
> [   90.996219]        [<ffffffffa0173af4>] snd_card_do_free+0x14/0x130 [snd]
> [   90.996283]        [<ffffffffa0173f14>] snd_card_free+0x84/0x90 [snd]
> [   90.996349]        [<ffffffffa0423397>] em28xx_audio_fini+0x97/0xb0 [em28xx_alsa]
> [   90.996411]        [<ffffffffa040dba6>] em28xx_close_extension+0x56/0x90 [em28xx]
> [   90.996475]        [<ffffffffa040f639>] em28xx_usb_disconnect+0x79/0x90 [em28xx]
> [   90.996539]        [<ffffffff814a06e7>] usb_unbind_interface+0x67/0x1d0
> [   90.996620]        [<ffffffff8142920f>] __device_release_driver+0x7f/0xf0
> [   90.996682]        [<ffffffff814292a5>] device_release_driver+0x25/0x40
> [   90.996742]        [<ffffffff81428b0c>] bus_remove_device+0x11c/0x1a0
> [   90.996801]        [<ffffffff81425536>] device_del+0x136/0x1d0
> [   90.996863]        [<ffffffff8149e0c0>] usb_disable_device+0xb0/0x290
> [   90.996923]        [<ffffffff814930c5>] usb_disconnect+0xb5/0x1d0
> [   90.996984]        [<ffffffff81495ab6>] hub_port_connect_change+0xd6/0xad0
> [   90.997044]        [<ffffffff814967c3>] hub_events+0x313/0x9b0
> [   90.997105]        [<ffffffff81496e95>] hub_thread+0x35/0x170
> [   90.997165]        [<ffffffff8108ea2f>] kthread+0xff/0x120
> [   90.997226]        [<ffffffff816b187c>] ret_from_fork+0x7c/0xb0
> [   90.997287]
> [   90.997287] other info that might help us debug this:
> [   90.997287]
> [   90.997318]  Possible unsafe locking scenario:
> [   90.997318]
> [   90.997348]        CPU0                    CPU1
> [   90.997378]        ----                    ----
> [   90.997408]   lock(&dev->lock);
> [   90.997497]                                lock(&card->controls_rwsem);
> [   90.997607]                                lock(&dev->lock);
> [   90.997697]   lock(&card->controls_rwsem);
> [   90.997786]
> [   90.997786]  *** DEADLOCK ***
> [   90.997786]
> [   90.997817] 5 locks held by khubd/54:
> [   90.997847]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff81496564>] hub_events+0xb4/0x9b0
> [   90.998025]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff81493076>] usb_disconnect+0x66/0x1d0
> [   90.998204]  #2:  (&__lockdep_no_validate__){......}, at: [<ffffffff8142929d>] device_release_driver+0x1d/0x40
> [   90.998383]  #3:  (em28xx_devlist_mutex){+.+.+.}, at: [<ffffffffa040db77>] em28xx_close_extension+0x27/0x90 [em28xx]
> [   90.998567]  #4:  (&dev->lock){+.+.+.}, at: [<ffffffffa040db81>] em28xx_close_extension+0x31/0x90 [em28xx]
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>   drivers/media/usb/em28xx/em28xx-core.c  | 2 --
>   drivers/media/usb/em28xx/em28xx-video.c | 4 ++++
>   2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> index b6dc3327c51c..898fb9bd88a2 100644
> --- a/drivers/media/usb/em28xx/em28xx-core.c
> +++ b/drivers/media/usb/em28xx/em28xx-core.c
> @@ -1099,12 +1099,10 @@ void em28xx_close_extension(struct em28xx *dev)
>   	const struct em28xx_ops *ops = NULL;
>
>   	mutex_lock(&em28xx_devlist_mutex);
> -	mutex_lock(&dev->lock);
>   	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
>   		if (ops->fini)
>   			ops->fini(dev);
>   	}
> -	mutex_unlock(&dev->lock);
>   	list_del(&dev->devlist);
>   	mutex_unlock(&em28xx_devlist_mutex);
>   }
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 004fe12ceec7..258628877951 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -1896,6 +1896,8 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
>
>   	em28xx_info("Disconnecting video extension");
>
> +	mutex_lock(&dev->lock);
> +
>   	v4l2_device_disconnect(&dev->v4l2_dev);
>
>   	em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
> @@ -1924,6 +1926,8 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
>   	v4l2_ctrl_handler_free(&dev->ctrl_handler);
>   	v4l2_device_unregister(&dev->v4l2_dev);
>
> +	mutex_unlock(&dev->lock);
> +
>   	kref_put(&dev->ref, em28xx_free_device);
>
>   	return 0;
>


-- 
http://palosaari.fi/
