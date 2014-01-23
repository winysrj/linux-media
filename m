Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:53494 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaAWLoJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 06:44:09 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZU00L2LR9JXGA0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Jan 2014 11:44:07 +0000 (GMT)
Message-id: <52E10085.7060906@samsung.com>
Date: Thu, 23 Jan 2014 12:44:05 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 06/21] v4l2-ctrls: add support for complex types.
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
 <1390221974-28194-7-git-send-email-hverkuil@xs4all.nl>
In-reply-to: <1390221974-28194-7-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20/01/14 13:45, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch implements initial support for complex types.
> 
> For the most part the changes are fairly obvious (basic support for is_ptr
> types, the type_is_int function is replaced by a is_int bitfield, and
> v4l2_query_ext_ctrl is added), but one change needs more explanation:
> 
> The v4l2_ctrl struct adds a 'new' field and a 'stores' array at the end
> of the struct. This is in preparation for future patches where each control
> can have multiple configuration stores. The idea is that stores[0] is the current
> control value, stores[1] etc. are the control values for each configuration store
> and the 'new' value can be accessed through 'stores[-1]', i.e. the 'new' field.
> However, for now only stores[-1] and stores[0] is used.

I guess it implies an assumption that (maximum) number of configuration stores
is known before creating the control ?

Regarding the negative array indexes, I guess I would just stick with using 
the 'new' field :-)

> These new fields use the v4l2_ctrl_ptr union, which is a pointer to a control
> value.
> 
> Note that these two new fields are not yet actually used.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--
Regards,
Sylwester


