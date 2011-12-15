Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36908 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1LOJt1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 04:49:27 -0500
Received: by wgbdr13 with SMTP id dr13so3748918wgb.1
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 01:49:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE9A8B6.4040102@matrix-vision.de>
References: <CAOy7-nNJXMbFkJWRubri2O_kc-V1Z+ZjTioqQu=8STtkuLag9w@mail.gmail.com>
	<4EE9A8B6.4040102@matrix-vision.de>
Date: Thu, 15 Dec 2011 17:49:26 +0800
Message-ID: <CAOy7-nPY_Nffgj_Ax=ziT9WYH-egvL8QnZfb50Xurn+AF4yWCQ@mail.gmail.com>
Subject: Re: Why is the Y12 support 12-bit grey formats at the CCDC input
 (Y12) is truncated to Y10 at the CCDC output?
From: James <angweiyang@gmail.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Thu, Dec 15, 2011 at 3:58 PM, Michael Jones
<michael.jones@matrix-vision.de> wrote:
> Hi James,
>
>
> On 12/15/2011 08:14 AM, James wrote:
>>
>> Hi all,
>>
>> I'm using an OMAP3530 board and a monochrome 12-bit grey sensor.
>>
>> Can anyone enlighten me why is the 12-bit grey formats at the CCDC
>> input (Y12) is truncated to Y10 at the CCDC output?
>
>
> There are 2 CCDC outputs: CCDC_PAD_SOURCE_OF and CCDC_PAD_SOURCE_VP. Only
> the VP (video port) truncates data to 10 bits, and it does that because the
> subdevs it feeds can only handle 10 bits max.

Thank you for the clarification.

>> I need to read the entire RAW 12-bit grey value from the CCDC to
>> memory and the data does not pass through other OMAP3ISP sub-devices.
>>
>> I intend to use Laurent's yavta to capture the data to file to verify
>> its operation for the moment.
>>
>> Can this 12-bit (Y12) raw capture be done?
>
>
> Yes. If you are writing the 12-bit gray value directly into memory, you will
> use SOURCE_OF and can write the full 12-bits into memory.  You need to set
> up your media pipeline to do sensor->CCDC->OMAP3 ISP CCDC output.

Is there further modification needed to apply to the OMAP3ISP to achieve this?

Do you have an application to test the pipeline for this setting to
simple display?

Many thanks in adv.

-- 
Regards,
James
