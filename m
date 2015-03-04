Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:30654 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbbCDLJF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 06:09:05 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKO00MCTPTP7W60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 04 Mar 2015 11:13:01 +0000 (GMT)
Message-id: <54F6E7C1.7060008@samsung.com>
Date: Wed, 04 Mar 2015 12:08:49 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCHv2 5/8] v4l2-subdev: add support for the new enum_frame_size
 'which' field.
References: <1425462481-8200-1-git-send-email-hverkuil@xs4all.nl>
 <1425462481-8200-6-git-send-email-hverkuil@xs4all.nl>
In-reply-to: <1425462481-8200-6-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 04/03/15 10:47, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Support the new 'which' field in the enum_frame_size ops. Most drivers do not
> need to be changed since they always returns the same enumeration regardless
> of the 'which' field.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

For s5c73m3:

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Andrzej Hajda <a.hajda@samsung.com>

--
Thanks,
Sylwester
