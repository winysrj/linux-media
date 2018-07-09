Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:53424 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932436AbeGINmN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jul 2018 09:42:13 -0400
Subject: Re: [PATCHv5 05/12] media: rename MEDIA_ENT_F_DTV_DECODER to
 MEDIA_ENT_F_DV_DECODER
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hansverk@cisco.com>
References: <20180629114331.7617-1-hverkuil@xs4all.nl>
 <20180629114331.7617-6-hverkuil@xs4all.nl>
 <CAAEAJfAmHZD2sjw9NF2Fyv6j+Z-usKJL4YNG5pgfZuyBSqLZkQ@mail.gmail.com>
 <2187896.B0EHAgUiIi@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0304525b-17cb-e92a-4c38-2c356dacffa2@xs4all.nl>
Date: Mon, 9 Jul 2018 15:42:09 +0200
MIME-Version: 1.0
In-Reply-To: <2187896.B0EHAgUiIi@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/18 15:00, Laurent Pinchart wrote:
> Hello,
> 
> On Friday, 29 June 2018 20:40:49 EEST Ezequiel Garcia wrote:
>> On 29 June 2018 at 08:43, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> From: Hans Verkuil <hansverk@cisco.com>
>>>
>>> The use of 'DTV' is very confusing since it normally refers to Digital
>>> TV e.g. DVB etc.
>>>
>>> Instead use 'DV' (Digital Video), which nicely corresponds to the
>>> DV Timings API used to configure such receivers and transmitters.
>>>
>>> We keep an alias to avoid breaking userspace applications.
>>>
>>> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
>>> ---
>>>
>>>  Documentation/media/uapi/mediactl/media-types.rst | 2 +-
>>>  drivers/media/i2c/adv7604.c                       | 1 +
>>>  drivers/media/i2c/adv7842.c                       | 1 +
>>
>> It would be nice to mention in the commit log
>> that this patch also sets the function for these drivers.
> 
> That's also my only concern with this patch (alternatively that change could 
> be split to a separate patch).
> 

I'll clarify the commit log. I can't split up this patch since the old define
is only available under #ifndef __KERNEL__, to prevent drivers from accidentally
using it in the kernel in the future.

Regards,

	Hans
