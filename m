Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4522 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaBCIz4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Feb 2014 03:55:56 -0500
Message-ID: <52EF5994.4090101@xs4all.nl>
Date: Mon, 03 Feb 2014 09:55:48 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, detlev.casanova@gmail.com
Subject: Re: [RFC PATCH 0/2] Allow inheritance of private controls
References: <1391166726-27026-1-git-send-email-hverkuil@xs4all.nl> <14055698.TyElnNSLTS@avalon>
In-Reply-To: <14055698.TyElnNSLTS@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 02/02/2014 10:45 AM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patches.
> 
> On Friday 31 January 2014 12:12:04 Hans Verkuil wrote:
>> Devices with a simple video pipeline may want to inherit private controls
>> of sub-devices and expose them to the video node instead of v4l-subdev
>> nodes (which may be inhibit anyway by the driver).
>>
>> Add support for this.
>>
>> A typical real-life example of this is a PCI capture card with just a single
>> video receiver sub-device. Creating v4l-subdev nodes for this is overkill
>> since it is clear which control belongs to which subdev.
> 
> The is_private flag has been introduced to allow subdevs to disable control 
> inheritance. We're now adding a way for bridges to override that, which makes 
> me wonder whether private controls are really the best way to express this.
> 
> Shouldn't we think about what we're trying to achieve with controls and places 
> where they're exposed and then possibly rework the code accordingly ?

I think is_private should be renamed to is_protected (as used in C++) and
inheriting protected controls is similar to marking a class as 'friend' in C++.

That's the mechanism I have in mind.

So is_private -> is_protected and the proposed inherit_private_ctrls field
becomes inherit_protected_ctrls.

There are only a handful of drivers that set is_private today, so it is easy
enough to rename.

What do you think?

Regards,

	Hans
