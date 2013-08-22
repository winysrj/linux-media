Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56129 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab3HVLUq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 07:20:46 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MRX00F0SJHV81C0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Aug 2013 12:20:44 +0100 (BST)
Message-id: <5215F40B.5060001@samsung.com>
Date: Thu, 22 Aug 2013 13:20:43 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: laurent.pinchart@ideasonboard.com,
	Andrzej Hajda <a.hajda@samsung.com>,
	linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH RFC v4] media: added managed v4l2/i2c subdevice
 initialization
References: <4084534.7DE24ipEqE@avalon>
 <1371651054-28684-1-git-send-email-a.hajda@samsung.com>
 <201308221310.39358.hverkuil@xs4all.nl>
In-reply-to: <201308221310.39358.hverkuil@xs4all.nl>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/22/2013 01:10 PM, Hans Verkuil wrote:
> This patch has been sitting around for quite some time now. Is there any reason
> not to apply it?

We wanted to merge those patches together with some users of them.
We have already prepared relevant patches but those depend on other
ones (conversion to v4l2-async/DT, some pending review) and I didn't
find enough time to post everything. I won't find time to take care
of this for 3.12, sorry. I guess it could be postponed to 3.13.

--
Regards,
Sylwester
 







