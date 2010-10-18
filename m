Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54894 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab0JRNZj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 09:25:39 -0400
Received: by yxm8 with SMTP id 8so343470yxm.19
        for <linux-media@vger.kernel.org>; Mon, 18 Oct 2010 06:25:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49e7400bcbcc4412b77216bb061db1b57cb3b882.1287318143.git.hverkuil@xs4all.nl>
References: <49e7400bcbcc4412b77216bb061db1b57cb3b882.1287318143.git.hverkuil@xs4all.nl>
Date: Mon, 18 Oct 2010 09:25:38 -0400
Message-ID: <AANLkTikmKf5uZ=QFYMQ8x_tQ4Mws3pJ61oXsr6Rt=ifx@mail.gmail.com>
Subject: Re: [RFC PATCH] radio-mr800: locking fixes
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Oct 17, 2010 at 8:26 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> - serialize the suspend and resume functions using the global lock.
> - do not call usb_autopm_put_interface after a disconnect.
> - fix a race when disconnecting the device.
>
> Reported-by: David Ellingsworth <david@identd.dyndns.org>
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/radio/radio-mr800.c |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
> index 2f56b26..b540e80 100644
> --- a/drivers/media/radio/radio-mr800.c
> +++ b/drivers/media/radio/radio-mr800.c
> @@ -284,9 +284,13 @@ static void usb_amradio_disconnect(struct usb_interface *intf)
>        struct amradio_device *radio = to_amradio_dev(usb_get_intfdata(intf));
>
>        mutex_lock(&radio->lock);
> +       /* increase the device node's refcount */
> +       get_device(&radio->videodev.dev);
>        v4l2_device_disconnect(&radio->v4l2_dev);
> -       mutex_unlock(&radio->lock);
>        video_unregister_device(&radio->videodev);
> +       mutex_unlock(&radio->lock);
> +       /* decrease the device node's refcount, allowing it to be released */
> +       put_device(&radio->videodev.dev);
>  }

Hans, I understand the use of get/put_device here.. but can you
explain to me what issue you are trying to solve?
video_unregister_device does not have to be synchronized with anything
else. Thus, it is perfectly safe to call video_unregister_device while
not holding the device lock. Your prior implementation here was
correct.

Regards,

David Ellingsworth
