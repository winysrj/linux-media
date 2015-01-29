Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:38036 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151AbbA2S2V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 13:28:21 -0500
Received: by mail-lb0-f170.google.com with SMTP id w7so31227129lbi.1
        for <linux-media@vger.kernel.org>; Thu, 29 Jan 2015 10:28:19 -0800 (PST)
Message-ID: <54CA7BBF.6070607@cogentembedded.com>
Date: Thu, 29 Jan 2015 21:28:15 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 5/8] media: rcar_vin: Add RGB888_1X24 input format support
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk> <1422548388-28861-6-git-send-email-william.towle@codethink.co.uk> <54CA6869.9060100@cogentembedded.com> <Pine.LNX.4.64.1501291915100.30602@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1501291915100.30602@axis700.grange>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 01/29/2015 09:18 PM, Guennadi Liakhovetski wrote:

>>> This adds V4L2_MBUS_FMT_RGB888_1X24 input format support
>>> which is used by the ADV7612 chip.

>>> Signed-off-by: Valentine Barshak <valentine.barshak@cogentembedded.com>

>>     I wonder why it hasn't been merged still? It's pending since 2013, and I'm
>> seeing no objections to it...

> Indeed, strange. I'm saving it for me to look at it for the next merge...
> and I'll double-check that series. Maybe the series had some objections,

    Indeed, I'm now seeing the patch #1 was objected to. Patch #2 has been 
merged somewhat later.

> Thanks
> Guennadi

WBR, Sergei

