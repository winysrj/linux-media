Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38600 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752009AbdGUHjM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 03:39:12 -0400
Received: by mail-wm0-f47.google.com with SMTP id w191so6595504wmw.1
        for <linux-media@vger.kernel.org>; Fri, 21 Jul 2017 00:39:11 -0700 (PDT)
Subject: Re: [PATCH v3 00/23] Qualcomm 8x16 Camera Subsystem driver
To: Hans Verkuil <hverkuil@xs4all.nl>, mchehab@kernel.org,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
References: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
 <e149940a-2ba3-6a4c-e8e9-2ab2933cca30@xs4all.nl>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <30ff0a7d-e27d-03a2-4927-ce537a766531@linaro.org>
Date: Fri, 21 Jul 2017 10:39:07 +0300
MIME-Version: 1.0
In-Reply-To: <e149940a-2ba3-6a4c-e8e9-2ab2933cca30@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On 19.07.2017 13:54, Hans Verkuil wrote:
> On 17/07/17 12:33, Todor Tomov wrote:
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
> OK, so this looks pretty good. I have one comment for patch 12/23, and the
> dt-bindings need to be acked.
> 
> I suggest you make a v3.1 for patch 12/23 and then I'll wait for the binding
> ack. Once that's in (and there are no other comments) I will merge this.

Thank you for the review!
I'll update patch 12/23 and will send in the next version along with the rest
of the fixes from the review.

> 
> Regards,
> 
> 	Hans
> 

-- 
Best regards,
Todor Tomov
