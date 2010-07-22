Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:19999 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371Ab0GVRbB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jul 2010 13:31:01 -0400
Message-ID: <4C48802D.6090406@maxwell.research.nokia.com>
Date: Thu, 22 Jul 2010 20:30:21 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC/PATCH v2 06/10] media: Entities, pads and links enumeration
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279722935-28493-7-git-send-email-laurent.pinchart@ideasonboard.com> <4C48633F.9020001@maxwell.research.nokia.com> <201007221733.37439.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201007221733.37439.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Sakari,

Hello Laurent,

...
>>> +
>>> +struct media_user_pad {
>>> +	__u32 entity;		/* entity ID */
>>> +	__u8 index;		/* pad index */
>>> +	__u32 direction;	/* pad direction */
>>> +};
>>
>> Another small comment, I think you mentioned it yourself some time back
>>
>> :-): how about some reserved fields to these structures?
> 
> Very good point. Reserved fields are needed in media_user_entity and 
> media_user_links at least. For media_user_pad and media_user_link, we could do 
> without reserved fields if we add fields to media_user_links to store the size 
> of those structures.

The structure size is part of the ioctl number defined by the _IOC macro
so I'd go with reserved fields even for these structures. Otherwise
special handling would be required for these ioctls in a few places.

>>> +struct media_user_entity {
>>> +	__u32 id;
>>> +	char name[32];
>>> +	__u32 type;
>>> +	__u32 subtype;
>>> +	__u8 pads;
>>> +	__u32 links;
>>> +
>>> +	union {
>>> +		/* Node specifications */
>>> +		struct {
>>> +			__u32 major;
>>> +			__u32 minor;
>>> +		} v4l;
>>> +		struct {
>>> +			__u32 major;
>>> +			__u32 minor;
>>> +		} fb;
>>> +		int alsa;
>>> +		int dvb;
>>> +
>>> +		/* Sub-device specifications */
>>> +		/* Nothing needed yet */

This union could have a defined size as well, e.g. u8 blob[64] or something.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
