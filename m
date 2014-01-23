Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61991 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbaAWOXN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 09:23:13 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZU000CUYMN2G20@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Jan 2014 14:23:11 +0000 (GMT)
Message-id: <52E125CD.2010401@samsung.com>
Date: Thu, 23 Jan 2014 15:23:09 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 08/21] v4l2-ctrls: create type_ops.
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
 <1390221974-28194-9-git-send-email-hverkuil@xs4all.nl>
In-reply-to: <1390221974-28194-9-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20/01/14 13:46, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Since complex controls can have non-standard types we need to be able to do
> type-specific checks etc. In order to make that easy type operations are added.
> There are four operations:
> 
> - equal: check if two values are equal
> - init: initialize a value
> - log: log the value
> - validate: validate a new value
> 
> This patch uses the v4l2_ctrl_ptr union for the first time.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Looks good.

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
