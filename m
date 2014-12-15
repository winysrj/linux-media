Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12082 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaLOK5Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 05:57:24 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NGM00HRHEMEF650@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Dec 2014 11:01:26 +0000 (GMT)
Message-id: <548EBE7B.7000109@samsung.com>
Date: Mon, 15 Dec 2014 11:56:59 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 08/10] s5k4ecgx: fix sparse warnings
References: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
 <1418471580-26510-9-git-send-email-hverkuil@xs4all.nl>
In-reply-to: <1418471580-26510-9-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13/12/14 12:52, Hans Verkuil wrote:
> The get_unaligned_le*() functions return the value using cpu endianness,
> so calling le*_to_cpu is wrong.
> 
> It hasn't been not noticed because this code has only been run on little
> endian systems, so le*_to_cpu doesn't do anything.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

