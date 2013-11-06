Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:13788 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab3KFP6r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Nov 2013 10:58:47 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVU008GAN1CGQ00@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Nov 2013 15:58:45 +0000 (GMT)
Message-id: <527A672F.4060505@samsung.com>
Date: Wed, 06 Nov 2013 16:58:39 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"open list:SAMSUNG S5P/EXYNO..." <linux-media@vger.kernel.org>
Subject: Re: [PATCH v7] videobuf2: Add missing lock held on vb2_fop_relase
References: <1383752507-25902-1-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1383752507-25902-1-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/11/13 16:41, Ricardo Ribalda Delgado wrote:
> From: Ricardo Ribalda <ricardo.ribalda@gmail.com>
> 
> vb2_fop_release does not held the lock although it is modifying the
> queue->owner field.
> 
> This could lead to race conditions on the vb2_perform_io function
> when multiple applications are accessing the video device via
> read/write API:
[...]
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Thanks for sticking with it and reworking it many times.

Regards,
Sylwester
