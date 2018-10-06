Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33056 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbeJFOEs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 6 Oct 2018 10:04:48 -0400
Received: by mail-pf1-f194.google.com with SMTP id d4-v6so6087281pfn.0
        for <linux-media@vger.kernel.org>; Sat, 06 Oct 2018 00:02:37 -0700 (PDT)
Date: Sat, 6 Oct 2018 00:05:21 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        linux-input@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 05/17] compat_ioctl: move more drivers to
 generic_compat_ioctl_ptrarg
Message-ID: <20181006070521.GM12063@builder>
References: <20180912150142.157913-1-arnd@arndb.de>
 <20180912151134.436719-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180912151134.436719-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 12 Sep 08:08 PDT 2018, Arnd Bergmann wrote:

[..]
> diff --git a/drivers/rpmsg/rpmsg_char.c b/drivers/rpmsg/rpmsg_char.c
> index a76b963a7e50..02aefb2b2d47 100644
> --- a/drivers/rpmsg/rpmsg_char.c
> +++ b/drivers/rpmsg/rpmsg_char.c
> @@ -285,7 +285,7 @@ static const struct file_operations rpmsg_eptdev_fops = {
>  	.write = rpmsg_eptdev_write,
>  	.poll = rpmsg_eptdev_poll,
>  	.unlocked_ioctl = rpmsg_eptdev_ioctl,
> -	.compat_ioctl = rpmsg_eptdev_ioctl,
> +	.compat_ioctl = generic_compat_ioctl_ptrarg,
>  };
>  
>  static ssize_t name_show(struct device *dev, struct device_attribute *attr,
> @@ -446,7 +446,7 @@ static const struct file_operations rpmsg_ctrldev_fops = {
>  	.open = rpmsg_ctrldev_open,
>  	.release = rpmsg_ctrldev_release,
>  	.unlocked_ioctl = rpmsg_ctrldev_ioctl,
> -	.compat_ioctl = rpmsg_ctrldev_ioctl,
> +	.compat_ioctl = generic_compat_ioctl_ptrarg,
>  };
>  

For rpmsg part

Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn
