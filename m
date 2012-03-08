Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52283 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859Ab2CHQK7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2012 11:10:59 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0K007LHQAAG800@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Mar 2012 16:10:58 +0000 (GMT)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0M0K00HQAQA9TF@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Mar 2012 16:10:57 +0000 (GMT)
Date: Thu, 08 Mar 2012 17:10:56 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH v4 04/34] v4l: VIDIOC_SUBDEV_S_SELECTION and
 VIDIOC_SUBDEV_G_SELECTION IOCTLs
In-reply-to: <4F566C61.9070907@iki.fi>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Message-id: <4F58DA10.7020501@samsung.com>
References: <20120302173219.GA15695@valkosipuli.localdomain>
 <4F563E02.7010406@samsung.com> <4F566BC8.9090400@iki.fi>
 <1414506.aeJ7eL5TfP@avalon> <4F566C61.9070907@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,
Does you patchset include renaming selection macros for both subdev and video node API?
I could prepare fixes to videodev2.h and Documentation if it is needed.

Regards,
Tomasz Stanislawski


