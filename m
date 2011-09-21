Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53552 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab1IUKZM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 06:25:12 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LRV0095DBLYMZ20@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Sep 2011 11:25:10 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRV004EBBLXZF@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Sep 2011 11:25:10 +0100 (BST)
Date: Wed, 21 Sep 2011 12:25:09 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v1 3/3] v4l: Add v4l2 subdev driver for S5K6AAFX sensor
In-reply-to: <20110920221033.GO1845@valkosipuli.localdomain>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <4E79BB85.50306@samsung.com>
References: <1316519939-22540-1-git-send-email-s.nawrocki@samsung.com>
 <1316519939-22540-4-git-send-email-s.nawrocki@samsung.com>
 <20110920221033.GO1845@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 09/21/2011 12:10 AM, Sakari Ailus wrote:
> On Tue, Sep 20, 2011 at 01:58:59PM +0200, Sylwester Nawrocki wrote:
>> This driver exposes preview mode operation of the S5K6AAFX sensor with
>> embedded SoC ISP. It uses one of the five user predefined configuration
>> register sets. There is yet no support for capture (snapshot) operation.
>> Following controls are supported:
>> manual/auto exposure and gain, power line frequency (anti-flicker),
>> saturation, sharpness, brightness, contrast, white balance temperature,
>> color effects. horizontal/vertical image flip, frame interval.
> 
> Thanks for the patch, Sylwester!
> 
> [clip]
>> +	v4l2_ctrl_new_std_menu(hdl, ops, V4L2_CID_POWER_LINE_FREQUENCY,
>> +			       V4L2_CID_POWER_LINE_FREQUENCY_AUTO, 0,
>> +			       V4L2_CID_POWER_LINE_FREQUENCY_50HZ);
>> +
>> +	v4l2_ctrl_new_std_menu(hdl, ops, V4L2_CID_COLORFX,
>> +			       V4L2_COLORFX_SKETCH, 0x3D0, V4L2_COLORFX_NONE);
> 
> New items may be added to standard menus so you should mask out also
> undefined bits. Say, ~0x42f (hope I got that right).

Sure, that's an important detail. ~0x42 look like the right value. Thanks for
pointing this out.

> 
> Youd also don't need to check for invalid menu ids; the control framework
> does this for you.

Right, good catch. I'll modify accordingly.

> 
>> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_WHITE_BALANCE_TEMPERATURE,
>> +			  0, 256, 1, 0);
>> +
>> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SATURATION, -127, 127, 1, 0);
>> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SHARPNESS, -127, 127, 1, 0);
>> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_BRIGHTNESS, -127, 127, 1, 0);
>> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_CONTRAST, -127, 127, 1, 0);
>> +
>> +	s5k6aa->sd.ctrl_handler = hdl;
> 
> Shoudln't this assignment be done after checking for the error?

Indeed, seems much more appropriate.

> 
>> +	if (hdl->error) {
>> +		ret = hdl->error;
>> +		v4l2_ctrl_handler_free(hdl);
>> +	}
>> +	return ret;

--
Thanks!
Sylwester
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
