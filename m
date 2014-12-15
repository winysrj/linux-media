Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12030 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaLOK4m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 05:56:42 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NGM00HRWEL7ZF50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Dec 2014 11:00:43 +0000 (GMT)
Message-id: <548EBE50.8030904@samsung.com>
Date: Mon, 15 Dec 2014 11:56:16 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 07/10] m5mols: fix sparse warnings
References: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
 <1418471580-26510-8-git-send-email-hverkuil@xs4all.nl>
In-reply-to: <1418471580-26510-8-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13/12/14 12:52, Hans Verkuil wrote:
> The be16_to_cpu conversions in m5mols_get_version() are not needed since the
> data is already using cpu endianness. This was never noticed since these
> version fields are never used.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
