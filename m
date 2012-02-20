Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56987 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab2BTRgu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 12:36:50 -0500
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZP00GBLCXDZ2@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Feb 2012 17:36:49 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZP005U4CXCN0@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Feb 2012 17:36:49 +0000 (GMT)
Date: Mon, 20 Feb 2012 18:36:48 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v3 01/33] v4l: Introduce integer menu controls
In-reply-to: <1329703032-31314-1-git-send-email-sakari.ailus@iki.fi>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com, k.debski@gmail.com,
	riverful@gmail.com
Message-id: <4F4284B0.3010703@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <20120220015605.GI7784@valkosipuli.localdomain>
 <1329703032-31314-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 02/20/2012 02:56 AM, Sakari Ailus wrote:
> Create a new control type called V4L2_CTRL_TYPE_INTEGER_MENU. Integer menu
> controls are just like menu controls but the menu items are 64-bit integers
> rather than strings.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've tested this patch when working on the camera exposure bias control,
feel free to add my
	
 Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

if you wish.

--

Thanks!
Sylwester
