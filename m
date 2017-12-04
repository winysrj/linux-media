Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:34872 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753065AbdLDNrI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Dec 2017 08:47:08 -0500
Received: by mail-it0-f67.google.com with SMTP id f143so6699965itb.0
        for <linux-media@vger.kernel.org>; Mon, 04 Dec 2017 05:47:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171201123130.23128-4-jaedon.shin@gmail.com>
References: <20171201123130.23128-1-jaedon.shin@gmail.com> <20171201123130.23128-4-jaedon.shin@gmail.com>
From: Menion <menion@gmail.com>
Date: Mon, 4 Dec 2017 14:46:46 +0100
Message-ID: <CAJVZm6cifFiURFJGWZ3R3x1Ngiqq1EU--GcXDhL1A=htEXH=dg@mail.gmail.com>
Subject: Re: [PATCH 3/3] media: dvb_frontend: Add commands implementation for
 compat ioct
To: Jaedon Shin <jaedon.shin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
Sorry if I say something completely wrong here, I was thinking to
implement the same on my own
As far as I understand from the patch, you have added two "compact"
specific ioctl commands
As far as I know, the compact_ioctl is called automatically when the
userland is 32 bit and kernel is 64 bit and it must be transparent
With compact specific ioctl command, the application should know if it
is running on top of 64 bit kernel and use them in case
I am not sure if this is the correct approach (also the userland
application should be all upgraded to make use of these new commands)
As far as I have understood, the compatc_ioctl body should adapt the
structures in and out, using the compact_ types
Bye

2017-12-01 13:31 GMT+01:00 Jaedon Shin <jaedon.shin@gmail.com>:
> The dtv_properties structure and the dtv_property structure are
> different sizes in 32-bit and 64-bit system. This patch provides
> FE_SET_PROPERTY and FE_GET_PROPERTY ioctl commands implementation for
> 32-bit user space applications.
>
> Signed-off-by: Jaedon Shin <jaedon.shin@gmail.com>
> ---
>  drivers/media/dvb-core/dvb_frontend.c | 131 ++++++++++++++++++++++++++++++++++
>  1 file changed, 131 insertions(+)
>
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index 1ae23403a0ab..f3751a573dfe 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -1976,9 +1976,140 @@ static long dvb_frontend_ioctl(struct file *file, unsigned int cmd,
>  }
>
>  #ifdef CONFIG_COMPAT
> +struct compat_dtv_property {
> +       __u32 cmd;
> +       __u32 reserved[3];
> +       union {
> +               __u32 data;
> +               struct dtv_fe_stats st;
> +               struct {
> +                       __u8 data[32];
> +                       __u32 len;
> +                       __u32 reserved1[3];
> +                       compat_uptr_t reserved2;
> +               } buffer;
> +       } u;
> +       int result;
> +} __attribute__ ((packed));
> +
> +struct compat_dtv_properties {
> +       __u32 num;
> +       compat_uptr_t props;
> +};
> +
> +#define COMPAT_FE_SET_PROPERTY    _IOW('o', 82, struct compat_dtv_properties)
> +#define COMPAT_FE_GET_PROPERTY    _IOR('o', 83, struct compat_dtv_properties)
> +
> +static int dvb_frontend_handle_compat_ioctl(struct file *file, unsigned int cmd,
> +                                           unsigned long arg)
> +{
> +       struct dvb_device *dvbdev = file->private_data;
> +       struct dvb_frontend *fe = dvbdev->priv;
> +       struct dvb_frontend_private *fepriv = fe->frontend_priv;
> +       int i, err = 0;
> +
> +       if (cmd == COMPAT_FE_SET_PROPERTY) {
> +               struct compat_dtv_properties prop, *tvps = NULL;
> +               struct compat_dtv_property *tvp = NULL;
> +
> +               if (copy_from_user(&prop, compat_ptr(arg), sizeof(prop)))
> +                       return -EFAULT;
> +
> +               tvps = &prop;
> +
> +               /*
> +                * Put an arbitrary limit on the number of messages that can
> +                * be sent at once
> +                */
> +               if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
> +                       return -EINVAL;
> +
> +               tvp = memdup_user(compat_ptr(tvps->props), tvps->num * sizeof(*tvp));
> +               if (IS_ERR(tvp))
> +                       return PTR_ERR(tvp);
> +
> +               for (i = 0; i < tvps->num; i++) {
> +                       err = dtv_property_process_set(fe, file,
> +                                                       (tvp + i)->cmd,
> +                                                       (tvp + i)->u.data);
> +                       if (err < 0) {
> +                               kfree(tvp);
> +                               return err;
> +                       }
> +               }
> +               kfree(tvp);
> +       } else if (cmd == COMPAT_FE_GET_PROPERTY) {
> +               struct compat_dtv_properties prop, *tvps = NULL;
> +               struct compat_dtv_property *tvp = NULL;
> +               struct dtv_frontend_properties getp = fe->dtv_property_cache;
> +
> +               if (copy_from_user(&prop, compat_ptr(arg), sizeof(prop)))
> +                       return -EFAULT;
> +
> +               tvps = &prop;
> +
> +               /*
> +                * Put an arbitrary limit on the number of messages that can
> +                * be sent at once
> +                */
> +               if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
> +                       return -EINVAL;
> +
> +               tvp = memdup_user(compat_ptr(tvps->props), tvps->num * sizeof(*tvp));
> +               if (IS_ERR(tvp))
> +                       return PTR_ERR(tvp);
> +
> +               /*
> +                * Let's use our own copy of property cache, in order to
> +                * avoid mangling with DTV zigzag logic, as drivers might
> +                * return crap, if they don't check if the data is available
> +                * before updating the properties cache.
> +                */
> +               if (fepriv->state != FESTATE_IDLE) {
> +                       err = dtv_get_frontend(fe, &getp, NULL);
> +                       if (err < 0) {
> +                               kfree(tvp);
> +                               return err;
> +                       }
> +               }
> +               for (i = 0; i < tvps->num; i++) {
> +                       err = dtv_property_process_get(
> +                           fe, &getp, (struct dtv_property *)tvp + i, file);
> +                       if (err < 0) {
> +                               kfree(tvp);
> +                               return err;
> +                       }
> +               }
> +
> +               if (copy_to_user((void __user *)compat_ptr(tvps->props), tvp,
> +                                tvps->num * sizeof(struct compat_dtv_property))) {
> +                       kfree(tvp);
> +                       return -EFAULT;
> +               }
> +               kfree(tvp);
> +       }
> +
> +       return err;
> +}
> +
>  static long dvb_frontend_compat_ioctl(struct file *file, unsigned int cmd,
>                                       unsigned long arg)
>  {
> +       struct dvb_device *dvbdev = file->private_data;
> +       struct dvb_frontend *fe = dvbdev->priv;
> +       struct dvb_frontend_private *fepriv = fe->frontend_priv;
> +       int err;
> +
> +       if (cmd == COMPAT_FE_SET_PROPERTY || cmd == COMPAT_FE_GET_PROPERTY) {
> +               if (down_interruptible(&fepriv->sem))
> +                       return -ERESTARTSYS;
> +
> +               err = dvb_frontend_handle_compat_ioctl(file, cmd, arg);
> +
> +               up(&fepriv->sem);
> +               return err;
> +       }
> +
>         return dvb_frontend_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
>  }
>  #endif
> --
> 2.15.0
>
