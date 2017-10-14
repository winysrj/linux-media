Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:44053 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752705AbdJNLZ5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Oct 2017 07:25:57 -0400
Subject: Re: [PATCHv2 0/9] omapdrm: hdmi4: add CEC support
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170802085408.16204-1-hverkuil@xs4all.nl>
 <bbc92584-71e8-b41e-dd35-5dd0d686cf53@ti.com>
 <d5034d03-1ef4-0253-0efc-ae7fd5cb09e9@ti.com>
 <9f921701-910c-d749-378c-038e8405f656@xs4all.nl>
 <f5d93c33-7825-1034-a605-ee38c796ca20@ti.com>
 <185e0c6e-8776-67e3-363f-fe9ebef3ba29@xs4all.nl>
 <2799bcc5-df51-e977-b3c0-22922f59fc39@ti.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2f4e152a-725a-593d-500d-1e6836a38104@xs4all.nl>
Date: Sat, 14 Oct 2017 13:25:52 +0200
MIME-Version: 1.0
In-Reply-To: <2799bcc5-df51-e977-b3c0-22922f59fc39@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/12/2017 10:03 AM, Tomi Valkeinen wrote:
> 
> Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
> 
> On 12/10/17 09:50, Hans Verkuil wrote:
> 
>>> I can't test with a TV, so no CEC for me... But otherwise I think the
>>> series works ok now, and looks ok. So I'll apply, but it's a bit late
>>> for the next merge window, so I'll aim for 4.15 with this.
>>
>> What is the status? Do you need anything from me? I'd like to get this in for 4.15.
> 
> Thanks for reminding. I think I would've forgotten...
> 
> I sent the pull request, so all should be fine.
> 
> If possible, please test the pull request, preferably with drm-next
> merged (git://people.freedesktop.org/~airlied/linux drm-next), as I
> don't have a CEC capable display.

Tested with drm-next. Works fine!

Great to finally see this merged!

Regards,

	Hans
