Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15160 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759797Ab0COIJm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 04:09:42 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KZB00F7GDC3EY@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Mar 2010 08:09:39 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KZB002S8DC30K@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Mar 2010 08:09:39 +0000 (GMT)
Date: Mon, 15 Mar 2010 09:07:56 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: Magic in videobuf
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Message-id: <E4D3F24EA6C9E54F817833EAE0D912AC09C7FCA3BF@bssrvexch01.BS.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-US
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

is anyone aware of any other uses for MAGIC_CHECK()s in videobuf code
besides driver debugging? I intend to remove them, as we weren't able
to find any particular use for them when we were discussing this at
the memory handling meeting in Norway...


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center

