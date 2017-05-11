Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:38283 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935351AbdEKOjs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 May 2017 10:39:48 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OPS003DMM2AUX80@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 May 2017 23:39:46 +0900 (KST)
Subject: Re: [PATCH v4] dw9714: Initial driver for dw9714 VCM
To: Rajmohan Mani <rajmohan.mani@intel.com>
Cc: Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org,
        mchehab@kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <9fc11dec-8c64-a681-21f9-2602fb1132c1@samsung.com>
Date: Thu, 11 May 2017 16:39:41 +0200
MIME-version: 1.0
In-reply-to: <CAAFQd5Ck3CKp-JR8d3d1X9-2cRS0oZG9GPwcpunBq50EY7qCtg@mail.gmail.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <1494478820-22199-1-git-send-email-rajmohan.mani@intel.com>
 <CAAFQd5Ck3CKp-JR8d3d1X9-2cRS0oZG9GPwcpunBq50EY7qCtg@mail.gmail.com>
 <CGME20170511143945epcas1p26203dff026b3dc9c2f65c5ca0be7967b@epcas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/11/2017 08:30 AM, Tomasz Figa wrote:
>> +static int dw9714_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>> +{
>> +       struct dw9714_device *dw9714_dev = container_of(sd,
>> +                                                       struct dw9714_device,
>> +                                                       sd);
>> +       struct device *dev = &dw9714_dev->client->dev;
>> +       int rval;
>> +
>> +       rval = pm_runtime_get_sync(dev);
>> +       if (rval >= 0)
>> +               return 0;
>> +
>> +       pm_runtime_put(dev);
>> +       return rval;
>>
> nit: The typical coding style is to return early in case of a special
> case and keep the common path linear, i.e.
> 
>     rval = pm_runtime_get_sync(dev);
>     if (rval < 0) {
>         pm_runtime_put(dev);
>         return rval;
>     }

Aren't we supposed to call pm_runtime_put() only when corresponding 
pm_runtime_get() succeeds? I think the pm_runtime_put() call above
is not needed. 

--
Regards,
Sylwester
