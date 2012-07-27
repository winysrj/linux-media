Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.matrix-vision.com ([85.214.244.251]:47843 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2G0L3D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jul 2012 07:29:03 -0400
Message-ID: <50127C2F.3080509@matrix-vision.de>
Date: Fri, 27 Jul 2012 13:31:59 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC] omap3-isp G_FMT & ENUM_FMT
References: <1343303996-16025-1-git-send-email-michael.jones@matrix-vision.de> <7135672.xS20ZCiE6C@avalon> <50125A66.80104@matrix-vision.de> <1772349.addfYp7k4f@avalon>
In-Reply-To: <1772349.addfYp7k4f@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 07/27/2012 11:35 AM, Laurent Pinchart wrote:
> On Friday 27 July 2012 11:07:50 Michael Jones wrote:
>> Hi Laurent,
>>
>> On 07/27/2012 01:32 AM, Laurent Pinchart wrote:
>>> Hi Michael,
[snip]
>> OK, so this sounds like the same behavior I'd like to add before
>> CREATE_BUFS and PREPARE_BUFS support is in.  My other question was if
>> this is the case, can we use my approach until your planned changes are in?
>
> We can't, as it would break the use case of preallocating buffers without
> providing any alternative solution. That's why I haven't fixed the
> G_FMT/S_FMT/ENUM_FMT issue yet.
>

OK, now I understand.  Thanks for clarifying.

-Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
