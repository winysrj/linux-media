Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:36791 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753545AbdGUHu0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 03:50:26 -0400
Received: by mail-wr0-f171.google.com with SMTP id y43so79044774wrd.3
        for <linux-media@vger.kernel.org>; Fri, 21 Jul 2017 00:50:25 -0700 (PDT)
Subject: Re: [PATCH v3 00/23] Qualcomm 8x16 Camera Subsystem driver
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
 <20170720152535.crxlxhirtlv23rjr@valkosipuli.retiisi.org.uk>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <694ea988-1f36-e0bb-7e03-0dee36fb79a4@linaro.org>
Date: Fri, 21 Jul 2017 10:50:23 +0300
MIME-Version: 1.0
In-Reply-To: <20170720152535.crxlxhirtlv23rjr@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari,

Thank you for the review!

On 20.07.2017 18:25, Sakari Ailus wrote:
> Hi Todor,
> 
> On Mon, Jul 17, 2017 at 01:33:26PM +0300, Todor Tomov wrote:
>> This patchset adds basic support for the Qualcomm Camera Subsystem found
>> on Qualcomm MSM8916 and APQ8016 processors.
>>
>> The driver implements V4L2, Media controller and V4L2 subdev interfaces.
>> Camera sensor using V4L2 subdev interface in the kernel is supported.
>>
>> The driver is implemented using as a reference the Qualcomm Camera
>> Subsystem driver for Android as found in Code Aurora [1].
>>
>> The driver is tested on Dragonboard 410C (APQ8016) with one and two
>> OV5645 camera sensors. media-ctl [2] and yavta [3] applications were
>> used for testing. Also Gstreamer 1.10.4 with v4l2src plugin is supported.
>>
>> More information is present in the document added by the third patch.
> 
> After addressing the comments (please pay attention especially those
> affecting the user space API behaviour) you can add:
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Let me know if you have any further questions on the individual comments.
> 

I'll prepare updates based on your comments. I'll reply to individual
comments only if there is something to discuss, the others I'll fix
directly.

Also, we had a discussion with Rob Herring about the device tree
binding and he requested some more opinions. If you have something
to say about this, please do. You can see the context here:

https://lkml.org/lkml/2017/6/19/280
https://lkml.org/lkml/2017/6/29/311


-- 
Best regards,
Todor Tomov
