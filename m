Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:52286 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750815AbdJFII6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Oct 2017 04:08:58 -0400
Subject: Re: [PATCHv2 2/2] drm: adv7511/33: add HDMI CEC support
To: Archit Taneja <architt@codeaurora.org>
References: <20170919073331.29007-1-hverkuil@xs4all.nl>
 <20170919073331.29007-3-hverkuil@xs4all.nl>
 <ee566874-ab76-0719-c924-dda32b296d57@codeaurora.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-msm@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1866171f-6413-33db-de63-252c92c4885c@xs4all.nl>
Date: Fri, 6 Oct 2017 10:08:55 +0200
MIME-Version: 1.0
In-Reply-To: <ee566874-ab76-0719-c924-dda32b296d57@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/10/17 06:26, Archit Taneja wrote:
> Hi Hans,
> 
> On 09/19/2017 01:03 PM, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add support for HDMI CEC to the drm adv7511/adv7533 drivers.
>>
>> The CEC registers that we need to use are identical for both drivers,
>> but they appear at different offsets in the register map.
> 
> The patch looks good to me. I can go ahead an queue it to drm-misc-next.
> 
> There were some minor comments on the DT bindings patch. Are you planning
> to send a new patch for that?

Yes. Now that this patch has been reviewed I'll post a v3 for the first
fixing those comments. Expect to see it Monday at the latest.

Regards,

	Hans
