Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:60077 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965060Ab0BZQCU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 11:02:20 -0500
Message-ID: <4B87F06C.5090507@nokia.com>
Date: Fri, 26 Feb 2010 18:01:48 +0200
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: V4L2 file handle and event patches
References: <4B85AC1E.8060302@maxwell.research.nokia.com>
In-Reply-To: <4B85AC1E.8060302@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari Ailus wrote:
> Hi,
> 
> Here's the tenth version of the V4L2 file handle and event interface
> patchset.
> 
> The patchset has been tested with the OMAP 3 ISP driver. Patches for
> OMAP 3 ISP are not part of this patchset but are available in Gitorious
> (branch is called event):
> 
> 	git://gitorious.org/omap3camera/mainline.git event
> 
> The patchset I'm posting now is against the v4l-dvb tree instead of
> linux-omap. The omap3camera tree thus has a slightly different
> version of these patches (just Makefiles) due to different baselines.

Hi Mauro,

What is your opinion on the file handle and event patchset? Could we get
them integrated for 2.6.34? Hans Verkuil as well as many others have no
more comments on them.

The patchset in question is v8.

Sincerely,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
