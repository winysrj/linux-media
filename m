Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3066 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbaCKQpf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 12:45:35 -0400
Message-ID: <531F3D67.2000606@xs4all.nl>
Date: Tue, 11 Mar 2014 17:44:23 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v3 27/48] v4l: Validate fields in the core code for subdev
 EDID ioctls
References: <1394493359-14115-28-git-send-email-laurent.pinchart@ideasonboard.com> <3176580.C10mxSGlFc@avalon> <531F359B.9010103@xs4all.nl> <2281895.rql8Q6dghx@avalon>
In-Reply-To: <2281895.rql8Q6dghx@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/2014 05:24 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Tuesday 11 March 2014 17:11:07 Hans Verkuil wrote:
>> On 03/11/2014 05:08 PM, Laurent Pinchart wrote:
>>> Hi Hans,
>>>
>>> On Tuesday 11 March 2014 16:44:27 Hans Verkuil wrote:
>>>> On 03/11/2014 04:09 PM, Laurent Pinchart wrote:
>>>>> The subdev EDID ioctls receive a pad field that must reference an
>>>>> existing pad and an EDID field that must point to a buffer. Validate
>>>>> both fields in the core code instead of duplicating validation in all
>>>>> drivers.
>>>>>
>>>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>>>
>>>> Here is my:
>>>>
>>>> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> But take note: the adv7604 driver does not handle a get_edid with
>>>> edid->blocks == 0 correctly: it should fill in the blocks field with the
>>>> real number of blocks and return 0 instead of returning EINVAL.
>>>
>>> Should it also set edid->start_block to 0 ?
>>
>> I don't think so. It makes sense to just set blocks to the total number of
>> available blocks - edid->start_block.
> 
> OK.
> 
>> Note that if edid->start_block >= total number of EDID blocks, then -ENODATA
>> should be returned.
> 
> What if S_EDID hasn't been called yet ? Should the driver set edid->blocks to 
> 0 and return success ? Or should it return -ENODATA ?

If start_block == 0 and blocks == 0, then return 0. If start_block > 0, then you
attempt to read a block that doesn't exist, so -ENODATA should be returned.
 
> There's quite a few possible combinations, we should probably start by 
> clarifying the spec.
> 

It's easier to code:

	if (tot_blocks == 0) {
		/* Referring to blocks we don't have? Return -ENODATA! */
		if (edid->start_block || edid->blocks)
			return -ENODATA;
		/* We have 0 blocks starting at block 0, so that's perfectly
		   fine! */
		return 0;
	}
	if (edid->start_block >= tot_blocks)
		return -ENODATA;
	if (edid->blocks == 0) {
		edid->blocks = tot_blocks - edid->start_block;
		return 0;
	}
	if (tot_blocks - edid->start_block < edid->blocks)
		edid->blocks = tot_blocks - edid->start_block;
	/* copy edid->blocks from start_block to edid->edid */
	return 0;

Regards,

	Hans
