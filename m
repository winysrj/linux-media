Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62455 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaAWOal (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 09:30:41 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZU00LNQYZ3YK20@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Jan 2014 14:30:39 +0000 (GMT)
Message-id: <52E1278D.8010600@samsung.com>
Date: Thu, 23 Jan 2014 15:30:37 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 10/21] v4l2-ctrls: compare values only once.
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
 <1390221974-28194-11-git-send-email-hverkuil@xs4all.nl>
In-reply-to: <1390221974-28194-11-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20/01/14 13:46, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> When setting a control the control's new value is compared to the current
> value twice: once by new_to_cur(), once by cluster_changed(). Not a big
> deal when dealing with simple values, but it can be a problem when dealing
> with compound types or matrices. So fix this: cluster_changed() sets the
> has_changed flag, which is used by new_to_cur() instead of having to do
> another compare.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
