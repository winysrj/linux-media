Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:33692 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932477AbbEVN4B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 09:56:01 -0400
Message-ID: <555F356A.9030000@xs4all.nl>
Date: Fri, 22 May 2015 15:55:54 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kamil Debski <kamil@wypas.org>
Subject: s5p-mfc: sparse warnings
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek, Kamil,

Can someone look at these sparse warnings?

s5p-mfc/s5p_mfc_opr_v5.c:266:23: warning: incorrect type in argument 2 (different address spaces)
s5p-mfc/s5p_mfc_opr_v5.c:274:23: warning: incorrect type in argument 1 (different address spaces)
s5p-mfc/s5p_mfc_opr_v6.c:1855:23: warning: incorrect type in argument 2 (different address spaces)
s5p-mfc/s5p_mfc_opr_v6.c:1865:22: warning: incorrect type in argument 1 (different address spaces)

It all depends on whether this is supposed to be __iomem memory or not.

If it is supposed to be __iomem, then sparse will fail elsewhere (I saw at
least one memset).

Regards,

	Hans
