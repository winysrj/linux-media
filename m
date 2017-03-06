Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:35057 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754112AbdCFQck (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 11:32:40 -0500
Received: by mail-lf0-f54.google.com with SMTP id j90so38206703lfk.2
        for <linux-media@vger.kernel.org>; Mon, 06 Mar 2017 08:32:39 -0800 (PST)
Subject: Re: [PATCH 11/29] drivers, media: convert cx88_core.refcount from
 atomic_t to refcount_t
To: Elena Reshetova <elena.reshetova@intel.com>,
        gregkh@linuxfoundation.org
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
 <1488810076-3754-12-git-send-email-elena.reshetova@intel.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-media@vger.kernel.org, devel@linuxdriverproject.org,
        linux-pci@vger.kernel.org, linux-s390@vger.kernel.org,
        fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, devel@driverdev.osuosl.org,
        target-devel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, peterz@infradead.org,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <c6987419-f708-9923-0f9f-87b715600045@cogentembedded.com>
Date: Mon, 6 Mar 2017 19:26:23 +0300
MIME-Version: 1.0
In-Reply-To: <1488810076-3754-12-git-send-email-elena.reshetova@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 03/06/2017 05:20 PM, Elena Reshetova wrote:

> refcount_t type and corresponding API should be
> used instead of atomic_t when the variable is used as
> a reference counter. This allows to avoid accidental
> refcounter overflows that might lead to use-after-free
> situations.
>
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: David Windsor <dwindsor@gmail.com>
[...]
> diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
> index 115414c..16c1313 100644
> --- a/drivers/media/pci/cx88/cx88.h
> +++ b/drivers/media/pci/cx88/cx88.h
> @@ -24,6 +24,7 @@
>  #include <linux/i2c-algo-bit.h>
>  #include <linux/videodev2.h>
>  #include <linux/kdev_t.h>
> +#include <linux/refcount.h>
>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-fh.h>
> @@ -339,7 +340,7 @@ struct cx8802_dev;
>
>  struct cx88_core {
>  	struct list_head           devlist;
> -	atomic_t                   refcount;
> +	refcount_t                   refcount;

    Could you please keep the name aligned with above and below?

>
>  	/* board name */
>  	int                        nr;
>

MBR, Sergei
