Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19705 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab3AGKql (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 05:46:41 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MG9000SQ4KF9D30@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 07 Jan 2013 10:46:39 +0000 (GMT)
Received: from [106.116.147.88] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MG900B074LR1B20@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 07 Jan 2013 10:46:39 +0000 (GMT)
Message-id: <50EAA78E.4090904@samsung.com>
Date: Mon, 07 Jan 2013 11:46:38 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: RFC: add parameters to V4L controls
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have included this proposition already in the post "[PATCH RFC 0/2] 
V4L: Add auto focus area control and selection" but it left unanswered.
I repost it again in a separate e-mail, I hope this way it will be 
easier to attract attention.

Problem description

Currently V4L2 controls can have only single value (of type int, int64, 
string). Some hardware controls require more than single int parameter, 
for example to set auto-focus (AF) rectangle four coordinates should be 
passed, to set auto-focus spot two coordinates should be passed.

Current solution

In case of AF rectangle we can reuse selection API as in "[PATCH RFC 
0/2] V4L: Add auto focus area control and selection" post.
Pros:
- reuse existing API,
Cons:
- two IOCTL's to perform one action,
- non-atomic operation,
- fits well only for rectangles and spots (but with unused fields width, 
height), in case of other parameters we should find a different way.

Proposed solution

The solution takes an advantage of the fact VIDIOC_(G/S/TRY)_EXT_CTRLS
ioctls can be called with multiple controls per call.

I will present it using AF area control example.

There could be added four pseudo-controls, lets call them for short:
LEFT, TOP, WIDTH, HEIGHT.
Those controls could be passed together with V4L2_AUTO_FOCUS_AREA_RECTANGLE
control in one ioctl as a kind of parameters.

For example setting auto-focus spot would require calling VIDIOC_S_EXT_CTRLS
with the following controls:
- V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_RECTANGLE
- LEFT = ...
- RIGHT = ...

Setting AF rectangle:
- V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_RECTANGLE
- LEFT = ...
- TOP = ...
- WIDTH = ...
- HEIGHT = ...

Setting  AF object detection (no parameters required):
- V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION

I have presented all three cases to show the advantages of this solution:
- atomicity - control and its parameters are passed in one call,
- flexibility - we are not limited by a fixed number of parameters,
- no-redundancy - we can pass only required parameters
	(no need to pass null width and height in case of spot selection),
- extensibility - it is possible to extend parameters in the future,
for example add parameters to V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION,
without breaking API,
- backward compatibility,
- re-usability - this schema could be used in other controls,
	pseudo-controls could be re-used in other controls as well.
- API backward compatibility.


Regards
Andrzej Hajda
