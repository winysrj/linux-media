Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:37750 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730836AbeG0NmF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 09:42:05 -0400
Received: by mail-wm0-f65.google.com with SMTP id n11-v6so5253973wmc.2
        for <linux-media@vger.kernel.org>; Fri, 27 Jul 2018 05:20:24 -0700 (PDT)
References: <20180703140803.19580-1-rui.silva@linaro.org> <20180703140803.19580-3-rui.silva@linaro.org> <20180725141140.4n6ooxtqlnoeyqgs@valkosipuli.retiisi.org.uk>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Rui Miguel Silva <rui.silva@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>,
        Ryan Harkin <ryan.harkin@linaro.org>
Subject: Re: [PATCH v7 2/2] media: ov2680: Add Omnivision OV2680 sensor driver
In-reply-to: <20180725141140.4n6ooxtqlnoeyqgs@valkosipuli.retiisi.org.uk>
Date: Fri, 27 Jul 2018 13:20:21 +0100
Message-ID: <m3r2jouayi.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,
On Wed 25 Jul 2018 at 15:11, Sakari Ailus wrote:
> On Tue, Jul 03, 2018 at 03:08:03PM +0100, Rui Miguel Silva 
> wrote:
>> This patch adds V4L2 sub-device driver for OV2680 image sensor.
>> The OV2680 is a 1/5" CMOS color sensor from Omnivision.
>> Supports output format: 10-bit Raw RGB.
>> The OV2680 has a single lane MIPI interface.
>> 
>> The driver exposes following V4L2 controls:
>> - auto/manual exposure,
>> - exposure,
>> - auto/manual gain,
>> - gain,
>> - horizontal/vertical flip,
>> - test pattern menu.
>> Supported resolution are only: QUXGA, 720P, UXGA.
>> 
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>
> Hi Rui,
>
> Could you provide a MAINTAINERS entry patch for the driver as 
> well as the
> DT bindings? I'll squash that to the first one.

Sure, will send it and you can squash it after.

---
Cheers,
	Rui
