Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36946 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886AbbCDLOH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 06:14:07 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKO007M1Q260J60@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 04 Mar 2015 11:18:06 +0000 (GMT)
Message-id: <54F6E8F0.7020104@samsung.com>
Date: Wed, 04 Mar 2015 12:13:52 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 2/8] v4l2-subdev.h: add 'which' field for the enum structs
References: <1425462481-8200-1-git-send-email-hverkuil@xs4all.nl>
 <1425462481-8200-3-git-send-email-hverkuil@xs4all.nl>
In-reply-to: <1425462481-8200-3-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/03/15 10:47, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> While all other pad ops allow you to select whether to use the 'try' or
> the 'active' formats, the enum ops didn't have that option and always used
> 'try'.
> 
> However, this will fail if a simple (e.g. PCI) bridge driver wants to use
> the enum pad op of a subdev that's also used in a complex platform driver
> like the omap3. Such a bridge driver generally wants to enum formats based
> on the active format.
> 
> So add a new 'which' field to these structs. Note that V4L2_SUBDEV_FORMAT_TRY
> is 0, so the default remains TRY (applications need to set reserved to 0).
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

