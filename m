Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:48286 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbbA2Ugq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 15:36:46 -0500
Received: by mail-lb0-f181.google.com with SMTP id u10so32409933lbd.12
        for <linux-media@vger.kernel.org>; Thu, 29 Jan 2015 12:36:44 -0800 (PST)
Message-ID: <54CA99D9.4020901@cogentembedded.com>
Date: Thu, 29 Jan 2015 23:36:41 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 5/8] media: rcar_vin: Add RGB888_1X24 input format support
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk> <1422548388-28861-6-git-send-email-william.towle@codethink.co.uk> <54CA6869.9060100@cogentembedded.com> <Pine.LNX.4.64.1501291915100.30602@axis700.grange> <54CA7BBF.6070607@cogentembedded.com> <Pine.LNX.4.64.1501292118020.7281@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1501292118020.7281@axis700.grange>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/29/2015 11:19 PM, Guennadi Liakhovetski wrote:

>>>>> This adds V4L2_MBUS_FMT_RGB888_1X24 input format support
>>>>> which is used by the ADV7612 chip.

>>>>> Signed-off-by: Valentine Barshak <valentine.barshak@cogentembedded.com>

>>>>      I wonder why it hasn't been merged still? It's pending since 2013, and
>>>> I'm
>>>> seeing no objections to it...

>>> Indeed, strange. I'm saving it for me to look at it for the next merge...
>>> and I'll double-check that series. Maybe the series had some objections,

>>     Indeed, I'm now seeing the patch #1 was objected to. Patch #2 has been
>> merged somewhat later.

> Right, and since this RGB888 format support was needed for the ADV761X
> driver from patch #1, this patch wasn't merged either. Do you need it now
> for something different?

    No, the same ADV7612 chip, just the different driver this time, it seems.

> Thanks
> Guennadi

WBR, Sergei

