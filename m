Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30785 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab0DHLzG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 07:55:06 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L0K00AZW3RRE410@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Apr 2010 12:55:03 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L0K004PK3RQSW@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Apr 2010 12:55:03 +0100 (BST)
Date: Thu, 08 Apr 2010 13:52:59 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: new V4L control framework
In-reply-to: <201004041741.51869.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com
Message-id: <000301cad712$08f2bf30$1ad83d90$%osciak@samsung.com>
Content-language: pl
References: <201004041741.51869.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

>Hans Verkuil wrote:

>BTW, I've also completely overhauled the vivi driver. I've used it to test
>the control handling, but I took the opportunity to do a big clean up of that
>driver. The combination of vivi + qv4l2 made testing of the more unusual
>integer64 and string control types much easier.

This is a bit off-topic, but I feel that any clean-up of vivi would more than
welcome. I use it for testing many different things as well. It would be great
if you could release those cleanup patches separately (without control-related
code)... Please let me know if you'd be planning to do something like that
in the (near) future. Thanks!


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center



