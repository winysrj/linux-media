Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab0CIPpf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Mar 2010 10:45:35 -0500
Message-ID: <4B966D15.50300@redhat.com>
Date: Tue, 09 Mar 2010 12:45:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: Re: [PATCH v8 0/6] V4L2 file handles and event interface
References: <4B85AC1E.8060302@maxwell.research.nokia.com>
In-Reply-To: <4B85AC1E.8060302@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari,

As usual, I'm marking those patches as RFC. Please add them on some tree
and ask me to pull from it, when you think that event interface is ready 
for upstream merge.

Cheers,
Mauro.

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
> 
> Some more comments from Hans and Randy. There are only improvements in
> documentation this time.
> 
> Comments are welcome as always.
> 
> Cheers,
> 


-- 

Cheers,
Mauro
