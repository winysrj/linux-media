Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:60814 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751873AbdIVOvH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 10:51:07 -0400
Subject: Re: [PATCH 2/4] [media] usbvision-core: Use common error handling
 code in usbvision_set_compress_params()
To: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org
Cc: Davidlohr Bueso <dave@stgolabs.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <c0e6e8e7-e47d-dc88-3317-2e46eaa51dc6@users.sourceforge.net>
 <52c09836-83d7-c509-6e85-c7af16160302@users.sourceforge.net>
 <20170922114432.x4e2ao22spbyek7n@mwanda>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <d4ab8049-0be4-6183-3cbd-5bc03968c2a4@users.sourceforge.net>
Date: Fri, 22 Sep 2017 16:50:07 +0200
MIME-Version: 1.0
In-Reply-To: <20170922114432.x4e2ao22spbyek7n@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> @@ -1913,11 +1908,12 @@ static int usbvision_set_compress_params(struct usb_usbvision *usbvision)
>>  			     USB_DIR_OUT | USB_TYPE_VENDOR |
>>  			     USB_RECIP_ENDPOINT, 0,
>>  			     (__u16) USBVISION_PCM_THR1, value, 6, HZ);
>> +	if (rc < 0)
>> +report_failure:
>> +		dev_err(&usbvision->dev->dev,
>> +			"%s: ERROR=%d. USBVISION stopped - reconnect or reload driver.\n",
>> +			__func__, rc);
> 
> You've been asked several times not to write code like this.

This suggestion occurred a few times.

Do you prefer to move this place to the end together with a duplicated statement “return rc;”?


> You do it later in the patch series as well.

To which update step do you refer here?

Regards,
Markus
