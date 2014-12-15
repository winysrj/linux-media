Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12710 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaLOK60 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 05:58:26 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NGM00GVEEO9V850@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Dec 2014 11:02:33 +0000 (GMT)
Message-id: <548EBEB9.8070301@samsung.com>
Date: Mon, 15 Dec 2014 11:58:01 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 09/10] s5k6aa: fix sparse warnings
References: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
 <1418471580-26510-10-git-send-email-hverkuil@xs4all.nl>
In-reply-to: <1418471580-26510-10-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13/12/14 12:52, Hans Verkuil wrote:
> drivers/media/i2c/s5k6aa.c:351:16: warning: cast to restricted __be16
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
