Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28293 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab0ERJCG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 05:02:06 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L2L00JGZYFEOS@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 18 May 2010 10:02:02 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L2L003EBYFDGL@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 18 May 2010 10:02:02 +0100 (BST)
Received: from bssrvexch01.BS.local (bssrvexch01.bs.local [106.116.38.52])
	by linux.samsung.com (Postfix) with ESMTP id CD1ED27004B	for
 <linux-media@vger.kernel.org>; Tue, 18 May 2010 11:01:17 +0200 (CEST)
Date: Tue, 18 May 2010 11:01:25 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: v4l2: V4L2_BUF_FLAG_ERROR flag in output streams
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <E4D3F24EA6C9E54F817833EAE0D912AC10E3F2CCD6@bssrvexch01.BS.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-US
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

V4L2_BUF_FLAG_ERROR flag has been recently introduced. Its meaning is obvious for capture streams - if there is a recoverable stream error the flag is set. This may include corruption in coded stream which results in partially decoded frame, missing stream data, etc. This basically means that the generated data in the buffer may be erroneous.

It is somehow different for output streams. There is no (meaningful) data after the buffer is dequeued. Would it be a good idea to use this flag to mark a source buffer that failed to process, because the data it contained was corrupt? By this I mean that a mem2mem device produced no output as it is not possible to set this flag in the capture buffer. And the meaning of this flag would be different.

In addition the relationship between source and destination buffers is not always 1:1 for media codecs. This means that lack of destination buffer does not always correspond to an error.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


