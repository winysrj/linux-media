Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:39743 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab2AGLJm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 06:09:42 -0500
Message-ID: <4F0827E9.1070303@maxwell.research.nokia.com>
Date: Sat, 07 Jan 2012 13:09:29 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
Subject: Re: [RFC 04/17] v4l: VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION
 IOCTLs
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <201201051712.00970.laurent.pinchart@ideasonboard.com> <4F06DA87.1050209@maxwell.research.nokia.com> <201201061300.40486.laurent.pinchart@ideasonboard.com> <4F080BAF.1010800@maxwell.research.nokia.com>
In-Reply-To: <4F080BAF.1010800@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari Ailus wrote:
...
> On second thought, I think I'll combine them into a new anonymous struct
> the field name of which I call "pad", unless that requires too intrusive
> changes in other drivers. How about that?

And the answer to that is "no". The smia++ driver does store the format,
crop and compose values in arrays indexed by pad numbers which I think
is a natural thing for the driver to do. In many functiona the driver
uses internally it's trivial to choose the array either from driver's
internal data structure (V4L2_SUBDEV_FORMAT_ACTIVE) or the file handle
(V4L2_SUBDEV_FORMAT_TRY).

Alternatively a named struct could be created for the same, but the
drivers might not need all the fields at all, or choose to store them in
a different form.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
