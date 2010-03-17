Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18063 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab0CQORM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 10:17:12 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0KZF003GSJOF2R80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Mar 2010 14:17:03 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KZF002XQJOFIB@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Mar 2010 14:17:03 +0000 (GMT)
Date: Wed, 17 Mar 2010 15:15:15 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH v2] v4l: videobuf: code cleanup.
In-reply-to: <A24693684029E5489D1D202277BE894454137086@dlee02.ent.ti.com>
To: "'Aguirre, Sergio'" <saaguirre@ti.com>, linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com
Message-id: <001001cac5dc$4407f690$cc17e3b0$%osciak@samsung.com>
Content-language: pl
References: <1268831061-307-1-git-send-email-p.osciak@samsung.com>
 <1268831061-307-2-git-send-email-p.osciak@samsung.com>
 <A24693684029E5489D1D202277BE894454137086@dlee02.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Aguirre, Sergio wrote:
>> Make videobuf pass checkpatch; minor code cleanups.
>
>I thought this kind patches were frowned upon..
>
>http://www.mjmwired.net/kernel/Documentation/development-process/4.Coding#41
>
>But maybe it's acceptable in this case... I'm not an expert on community policies :)

Hm, right...
I'm not an expert either, but it does seem reasonable. It was just a part of the
roadmap we agreed on in Norway, so I simply went ahead with it. Merging with other
patches would pollute them so I just posted it separately. I will leave the
decision up to Mauro then. I have some more "normal" patches lined up,
so please let me know. I'm guessing we are cancelling the clean-up then though.


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


