Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42769 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab2ENQCs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 12:02:48 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=windows-1252
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4000BT4SJEUX80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 May 2012 17:02:02 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M40003PJSKMTZ@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 May 2012 17:02:46 +0100 (BST)
Date: Mon, 14 May 2012 18:02:45 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v5 18/35] v4l: Allow changing control handler lock
In-reply-to: <4FB1289F.5010606@iki.fi>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Message-id: <4FB12CA5.7080101@samsung.com>
References: <20120306163239.GN1075@valkosipuli.localdomain>
 <1331051596-8261-18-git-send-email-sakari.ailus@iki.fi>
 <4FB12458.80809@samsung.com> <4FB1289F.5010606@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/14/2012 05:45 PM, Sakari Ailus wrote:
> Ooops. The patch included the changes for adp1653 and vivi which I found to be
> the only drivers using the lock directly. I somehow missed s5p-fimc --- sorry
> about that.

It's all right, no big deal. I'll make a patch to correct this.

-- 
Regards
Sylwester
