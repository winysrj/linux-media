Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21562 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751966AbdIVLpY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 07:45:24 -0400
Date: Fri, 22 Sep 2017 14:44:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/4] [media] usbvision-core: Use common error handling
 code in usbvision_set_compress_params()
Message-ID: <20170922114432.x4e2ao22spbyek7n@mwanda>
References: <c0e6e8e7-e47d-dc88-3317-2e46eaa51dc6@users.sourceforge.net>
 <52c09836-83d7-c509-6e85-c7af16160302@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52c09836-83d7-c509-6e85-c7af16160302@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 21, 2017 at 05:07:06PM +0200, SF Markus Elfring wrote:
> @@ -1913,11 +1908,12 @@ static int usbvision_set_compress_params(struct usb_usbvision *usbvision)
>  			     USB_DIR_OUT | USB_TYPE_VENDOR |
>  			     USB_RECIP_ENDPOINT, 0,
>  			     (__u16) USBVISION_PCM_THR1, value, 6, HZ);
> +	if (rc < 0)
> +report_failure:
> +		dev_err(&usbvision->dev->dev,
> +			"%s: ERROR=%d. USBVISION stopped - reconnect or reload driver.\n",
> +			__func__, rc);

You've been asked several times not to write code like this.  You do
it later in the patch series as well.

regards,
dan carpenter
