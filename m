Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:53957 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726014AbeJHUKV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Oct 2018 16:10:21 -0400
Subject: Re: [PATCH 4/5] omapdrm/dss/hdmi4_cec.c: clear TX FIFO before
 transmit_done
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20181004090900.32915-1-hverkuil@xs4all.nl>
 <20181004090900.32915-5-hverkuil@xs4all.nl>
 <33ddd03f-91aa-6c19-380e-a81abf390180@xs4all.nl>
 <d6b30689-2529-f3ed-9886-de0ef634388c@ti.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <309c475e-b695-2fb4-8883-3a27af8c811e@xs4all.nl>
Date: Mon, 8 Oct 2018 14:58:39 +0200
MIME-Version: 1.0
In-Reply-To: <d6b30689-2529-f3ed-9886-de0ef634388c@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/08/2018 02:52 PM, Tomi Valkeinen wrote:
> 
> On 05/10/18 17:13, Hans Verkuil wrote:
>> Tomi,
>>
>> Can you review this patch and the next? They should go to 4.20.
>> This patch in particular is a nasty one, hard to reproduce.
>>
>> This patch should also be Cc-ed to stable for 4.15 and up.
> 
> Done. There's no dependency from the omapdrm patches to the first patch,
> is there? I.e. I can apply these via omapdrm?

Correct.

Regards,

	Hans
