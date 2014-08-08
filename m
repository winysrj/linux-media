Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:43029 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbaHHNmD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Aug 2014 09:42:03 -0400
Received: by mail-yk0-f169.google.com with SMTP id 131so3886414ykp.28
        for <linux-media@vger.kernel.org>; Fri, 08 Aug 2014 06:42:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1407494627-1555-3-git-send-email-m.chehab@samsung.com>
References: <1407494627-1555-1-git-send-email-m.chehab@samsung.com>
	<1407494627-1555-3-git-send-email-m.chehab@samsung.com>
Date: Fri, 8 Aug 2014 07:42:03 -0600
Message-ID: <CAKocOOPA3bkJ_p5V6jr_SNLF+yxmLJYLc=5xOVYuAOzO9u4bOw@mail.gmail.com>
Subject: Re: [PATCH 3/3] au0828: don't let the IR polling thread to run at suspend
From: Shuah Khan <shuahkhan@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 8, 2014 at 4:43 AM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> Trying to make au0828 to suspend can do very bad things, as
> the polling Kthread is not handled. We should disable it
> during suspend, only re-enabling it at resume.
>
> Still, analog and digital TV won't work, as we don't reinit
> the settings at resume, but at least it won't hang.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/usb/au0828/au0828-core.c | 32 ++++++++++++++++++++++++++++++--
>  1 file changed, 30 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
> index 56025e689442..eb5f2b1b182b 100644
> --- a/drivers/media/usb/au0828/au0828-core.c
> +++ b/drivers/media/usb/au0828/au0828-core.c
> @@ -285,13 +285,41 @@ static int au0828_usb_probe(struct usb_interface *interface,
>         return retval;
>  }
>
> +static int au0828_suspend(struct usb_interface *interface,
> +                               pm_message_t message)
> +{
> +       struct au0828_dev *dev = usb_get_intfdata(interface);
> +
> +       if (!dev)
> +               return 0;
> +
> +       au0828_rc_suspend(dev);
> +
> +       /* FIXME: should suspend also ATV/DTV */
> +
> +       return 0;
> +}
> +
> +static int au0828_resume(struct usb_interface *interface)
> +{
> +       struct au0828_dev *dev = usb_get_intfdata(interface);
> +       if (!dev)
> +               return 0;
> +
> +       au0828_rc_resume(dev);
> +
> +       /* FIXME: should resume also ATV/DTV */
> +
> +       return 0;
> +}
> +
>  static struct usb_driver au0828_usb_driver = {
>         .name           = DRIVER_NAME,
>         .probe          = au0828_usb_probe,
>         .disconnect     = au0828_usb_disconnect,
>         .id_table       = au0828_usb_id_table,
> -
> -       /* FIXME: Add suspend and resume functions */
> +       .suspend        = au0828_suspend,
> +       .resume         = au0828_resume,
>  };

all the extensions will need suspend/resume hooks similar to em28xx
would like me to take a look at that??

-- Shuah
