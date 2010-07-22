Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:63285 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab0GVQaF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jul 2010 12:30:05 -0400
Message-ID: <4C4871F5.2020600@maxwell.research.nokia.com>
Date: Thu, 22 Jul 2010 19:29:41 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v2 06/10] media: Entities, pads and links enumeration
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279722935-28493-7-git-send-email-laurent.pinchart@ideasonboard.com> <4C485F49.2000703@maxwell.research.nokia.com> <201007221720.04555.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201007221720.04555.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
>> That change causes a lot of clashes in naming since the equivalent
>> kernel structure is there as well. Those could have _k postfix, for
>> example, to differentiate them from user space names. I don't really
>> have a good suggestion how they should be called.
> 
> Maybe media_k_* ? I'm not very happy with that name either though.

Sounds better to me.

>>> +- struct media_user_pad
>>> +
>>> +__u32		entity		ID of the entity this pad belongs to.
>>> +__8		index		0-based pad index.
>>
>> It's possible that 8 bits is enough (I think Hans commented this
>> already). The compiler will use 4 bytes in any case and I think it's a
>> good practice not to create holes in the structures, especially not to
>> the interface ones.
> 
> The direction could become a 8-bit integer, and a 16-bit attributes/properties 
> bitfield would be added to fill the hole (it would be used to store pad 
> properties such as a busy flag). I'd rather make that field 32-bits wide 
> instead of 16 though.

I guess you could put more reserved fields to these small holes.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
