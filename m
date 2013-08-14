Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36346 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab3HNPfl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Aug 2013 11:35:41 -0400
Message-id: <520BA3C9.8050606@samsung.com>
Date: Wed, 14 Aug 2013 17:35:37 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: lee.jones@linaro.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH RFC v2 1/2] max77693: added device tree support
References: <1361288177-14452-1-git-send-email-a.hajda@samsung.com>
 <1361288177-14452-2-git-send-email-a.hajda@samsung.com>
 <20130408152122.GU24058@zurbaran> <51E64BA8.30205@samsung.com>
In-reply-to: <51E64BA8.30205@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lee,

I have no response from Samuel regarding this patch.
Could you take care of it, I can rebase it again if necessary.

Regards
Andrzej

On 07/17/2013 09:45 AM, Andrzej Hajda wrote:
> Hi Samuel,
>
> A while ago I have send rebased patch adding device-tree support for
> max77693 as you asked:
> https://patchwork.kernel.org/patch/2414341/
>
> The patch is still not applied. Is there a reason for that or just an
> omission?
>
> Regards
> Andrzej
>
> On 04/08/2013 05:21 PM, Samuel Ortiz wrote:
>> Hi Andrzej,
>>
>> On Tue, Feb 19, 2013 at 04:36:16PM +0100, Andrzej Hajda wrote:
>>> max77693 mfd main device uses only wakeup field
>>> from max77693_platform_data. This field is mapped
>>> to wakeup-source property in device tree.
>>> Device tree bindings doc will be added in max77693-led patch.
>>>
>>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>>  drivers/mfd/max77693.c |   40 +++++++++++++++++++++++++++++++++-------
>>>  1 file changed, 33 insertions(+), 7 deletions(-)
>> This patch looks good to me, but doesn't apply to mfd-next. Would you mind
>> rebasing it ?
>>
>> Cheers,
>> Samuel.
>>
>>

