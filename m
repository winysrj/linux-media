Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31278 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbaIAJnN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Sep 2014 05:43:13 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NB70072XV4RQ830@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 01 Sep 2014 10:46:03 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Nicolas Dufresne' <nicolas.dufresne@collabora.com>,
	linux-media@vger.kernel.org
References: <5400844A.5030603@collabora.com>
In-reply-to: <5400844A.5030603@collabora.com>
Subject: RE: s5p-mfc should allow multiple call to REQBUFS before we start
 streaming
Date: Mon, 01 Sep 2014 11:43:09 +0200
Message-id: <06ac01cfc5c9$248443e0$6d8ccba0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,


> From: Nicolas Dufresne [mailto:nicolas.dufresne@collabora.com]
> Sent: Friday, August 29, 2014 3:47 PM
> 
> Hi Kamil,
> 
> after a discussion on IRC, we concluded that s5p-mfc have this bug that
> disallow multiple reqbufs calls before streaming. This has the impact
> that it forces to call REQBUFS(0) before setting the new number of
> buffers during re-negotiation, and is against the spec too.

I was out of office last week. Could you shed more light on this subject?
Do you have the irc log?

> As an example, in reqbufs_output() REQBUFS is only allowed in
> QUEUE_FREE state, and setting buffers exits this state. We think that
> the call to
> <http://lxr.free-
> electrons.com/ident?i=reqbufs_output>s5p_mfc_open_mfc_inst()
> should be post-poned until STREAMON is called.
> <http://lxr.free-electrons.com/ident?i=reqbufs_output>

How is this connected to the renegotiation scenario?
Are you sure you wanted to mention s5p_mfc_open_mfc_inst?
 
> cheers,
> Nicolas
> <http://lxr.free-electrons.com/ident?i=reqbufs_output>

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

