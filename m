Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60071 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaAWNqt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 08:46:49 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZU00ML9WY0YV10@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Jan 2014 13:46:48 +0000 (GMT)
Message-id: <52E11D45.4050900@samsung.com>
Date: Thu, 23 Jan 2014 14:46:45 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 17/21] v4l2-ctrls.c: return elem_size instead of
 strlen
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
 <1390221974-28194-18-git-send-email-hverkuil@xs4all.nl>
In-reply-to: <1390221974-28194-18-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20/01/14 13:46, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> When getting a string and the size given by the application is too
> short return the max length the string can have (elem_size) instead
> of the string length + 1. That makes more sense.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
