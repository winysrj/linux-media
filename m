Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab1KGOUL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Nov 2011 09:20:11 -0500
Message-ID: <4EB7E901.4000700@redhat.com>
Date: Mon, 07 Nov 2011 12:19:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Defert <laurent.defert@smartjog.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] compat_ioctl: add compat handler for FE_SET_PROPERTY
References: <4EA816E2.8080607@smartjog.com>
In-Reply-To: <4EA816E2.8080607@smartjog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-10-2011 12:19, Laurent Defert  :
> Hello,
> 
> You'll find below a patch that implements the FE_SET_PROPERTY ioctl compat code. This code is reached  when a 32 bit application does the ioctl on a 64 bit kernel.
> There are other dvb ioctl that are missing from the compat layer (FE_GET_PROPERTY and  FE_SET_FRONTEND_TUNE_MODE), if this patch is ok, i'm going to write them as well.

If are there many things, then maybe the better would be to do what we've done with V4L: put the compat stuff
into a separate file (see drivers/media/video/v4l2-compat-ioctl32.c). The glue is done by adding,
at drivers/media/video/v4l2-dev.c:

   .compat_ioctl = v4l2_compat_ioctl32

at struct file_operations.

> 
> Laurent
> 
> commit 6647fda45d70d1947f2dff06c485aa64d78357d7
> Author: Laurent Defert <laurent.defert@smartjog.com>
> Date:   Wed Oct 26 14:32:29 2011 +0200
> 
> [media] compat_ioctl: add compat handler for FE_SET_PROPERTY
> 
> fixes following error seen on x86_64 kernel:
> ioctl32(dvblast:6973): Unknown cmd fd(3) cmd(40086f52){t:'o';sz:8} arg(0805a318) on /dev/dvb/adapter0/frontend0
> 
> The argument (struct dtv_properties) contains a pointer to an array of struct dtv_property.
> Both struct are converted to have proper pointer size.
> 
> Signed-off-by: Laurent Defert <laurent.defert@smartjog.com>
> 
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index 51352de..6b89ff0 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -222,6 +222,84 @@ static int do_video_set_spu_palette(unsigned int fd, unsigned int cmd,
>      return err;
>  }
> 
> +struct compat_dtv_property {
> +    __u32 cmd;
> +    __u32 reserved[3];
> +    union {
> +        __u32 data;
> +        struct {
> +            __u8 data[32];
> +            __u32 len;
> +            __u32 reserved1[3];
> +            compat_uptr_t reserved2;
> +        } buffer;
> +    } u;
> +    int result;

Hmm... maybe it would be better to change from "int" to "s32".

> +};
> +
> +struct compat_dtv_properties {
> +    __u32 num;
> +    compat_uptr_t props;
> +};
> +
> +#define FE_SET_PROPERTY32    _IOW('o', 82, struct compat_dtv_properties)
> +
> +static int do_fe_set_property(unsigned int fd, unsigned int cmd,
> +        struct compat_dtv_properties __user *dtv32)
> +{
> +    struct dtv_properties __user *dtv;
> +    struct dtv_property __user *properties;
> +    struct compat_dtv_property __user *properties32;
> +    compat_uptr_t data;
> +
> +    int err;
> +    int i;
> +    __u32 num;
> +
> +    err = get_user(num, &dtv32->num);
> +    err |= get_user(data, &dtv32->props);
> +
> +    if(err)
> +        return -EFAULT;
> +
> +    dtv = compat_alloc_user_space(sizeof(struct dtv_properties) +
> +                    sizeof(struct dtv_property) * num);
> +    properties = (struct dtv_property*)((char*)dtv +
> +                    sizeof(struct dtv_properties));
> +
> +    err = put_user(properties, &dtv->props);
> +    err |= put_user(num, &dtv->num);
> +
> +    properties32 = compat_ptr(data);
> +
> +    if(err)
> +        return -EFAULT;

Please check it with checkpatch.pl. Coding style is wrong here and on a few other places.

> +
> +    for(i = 0; i < num; i++) {
> +        compat_uptr_t reserved2;
> +
> +        err |= copy_in_user(&properties[i], &properties32[i],
> +                (8 * sizeof(__u32)) + (32 * sizeof(__u8)));
> +        err |= get_user(reserved2, &properties32[i].u.buffer.reserved2);
> +        err |= put_user(compat_ptr(reserved2),
> + &properties[i].u.buffer.reserved2);
> +    }
> +
> +    if(err)
> +        return -EFAULT;
> +
> +    err = sys_ioctl(fd, FE_SET_PROPERTY, (unsigned long) dtv);
> +
> +    for(i = 0; i < num; i++) {
> +        if(copy_in_user(&properties[i].result, &properties32[i].result,
> +                                sizeof(int)))
> +            return -EFAULT;
> +    }
> +
> +    return err;
> +}
> +
> +
>  #ifdef CONFIG_BLOCK
>  typedef struct sg_io_hdr32 {
>      compat_int_t interface_id;    /* [i] 'S' for SCSI generic (required) */
> @@ -1470,6 +1548,8 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
>          return do_video_stillpicture(fd, cmd, argp);
>      case VIDEO_SET_SPU_PALETTE:
>          return do_video_set_spu_palette(fd, cmd, argp);
> +    case FE_SET_PROPERTY32:
> +        return do_fe_set_property(fd, cmd, argp);
>      }
> 
>      /*
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

