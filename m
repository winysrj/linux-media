Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19000 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2GXOhs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jul 2012 10:37:48 -0400
Received: from eusync3.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M7O007VW601CR10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 24 Jul 2012 15:38:25 +0100 (BST)
Received: from AMDN157 ([106.116.147.102])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M7O004L35YXBO70@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 24 Jul 2012 15:37:46 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sylwester Nawrocki' <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org
Cc: posciak@google.com, Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	hans.verkuil@cisco.com, hdegoede@redhat.com,
	javier.martin@vista-silicon.com, jtp.park@samsung.com,
	kyungmin.park@samsung.com, mchehab@infradead.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <1341084223-4616-1-git-send-email-sylvester.nawrocki@gmail.com>
 <1341084223-4616-2-git-send-email-sylvester.nawrocki@gmail.com>
In-reply-to: <1341084223-4616-2-git-send-email-sylvester.nawrocki@gmail.com>
Subject: RE: [PATCH/RFC 1/2] V4L: Add capability flags for memory-to-memory
 devices
Date: Tue, 24 Jul 2012 16:37:45 +0200
Message-id: <001b01cd69a9$e40fe990$ac2fbcb0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> From: Sylwester Nawrocki [mailto:sylvester.nawrocki@gmail.com]
> Sent: 30 June 2012 21:24
> 
> This patch adds new V4L2_CAP_VIDEO_M2M and V4L2_CAP_VIDEO_M2M_MPLANE
> capability
> flags that are intended to be used for memory-to-memory (M2M) devices,
> instead
> of ORed V4L2_CAP_VIDEO_CAPTURE and V4L2_CAP_VIDEO_OUTPUT.
> 
> V4L2_CAP_VIDEO_M2M flag is added at the drivers, CAPTURE and OUTPUT
> capability
> flags are left untouched and will be removed in future, after a
> transition
> period required for existing applications to be adapted to check only for
> V4L2_CAP_VIDEO_M2M.
> 
> Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>

For s5p-mfc and g2d:
Acked-by: Kamil Debski <k.debski@samsung.com>

