Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2200 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbaJ3H1v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 03:27:51 -0400
Message-ID: <5451E86A.2000004@xs4all.nl>
Date: Thu, 30 Oct 2014 08:27:38 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>
Subject: Sparse error in s5p_mfc_enc.c
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Can you make a patch to fix this sparse error?

/home/hans/work/build/media-git/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1178:25: error: incompatible types in conditional expression (different base types)

s5p_mfc_hw_call should probably be s5p_mfc_hw_call_void.

Regards,

	Hans
