Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:48890 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754097AbdDGK0l (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 06:26:41 -0400
Subject: Re: [Patch v4 12/12] Documention: v4l: Documentation for HEVC CIDs
To: Smitha T Murthy <smitha.t@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <b26d966f-5acd-5d1e-0cb6-0232f84c2b31@samsung.com>
Date: Fri, 07 Apr 2017 12:26:31 +0200
MIME-version: 1.0
In-reply-to: <1491559409.15698.1237.camel@smitha-fedora>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
References: <1491459105-16641-1-git-send-email-smitha.t@samsung.com>
 <CGME20170406061027epcas5p2628e0a8e0fd76e2e267fad3ea1209f65@epcas5p2.samsung.com>
 <1491459105-16641-13-git-send-email-smitha.t@samsung.com>
 <f68d8bd2-a2b4-7253-0a48-6c3f509e66cd@samsung.com>
 <1491559409.15698.1237.camel@smitha-fedora>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/07/2017 12:03 PM, Smitha T Murthy wrote:
>>> +``V4L2_CID_MPEG_VIDEO_HEVC_LF``
>>> +    Indicates loop filtering. Control ID 0 indicates loop filtering
>>> +    is enabled and when set to 1 indicates no filter.
 >>
>> "Setting this control to 0 enables loop filtering, setting this control
>> to 1 disables loop filtering." ?
>>
>> Couldn't the meaning be inverted, so setting the control to 0 disables
>> the loop filtering?
>>
>>From register point of view, this control value needs be 0 to enable
> loop filtering.

OK, this is true for our specific hardware/firmware implementation.

In general, for this user space interface I would rather define that
boolean control so value 1 enables LF and value 0 disables LF.
The driver could simply negate the value when writing registers.

BTW we might need to specify type of the control here as Hans suggested
commenting on other control.

--
Regards,
Sylwester
