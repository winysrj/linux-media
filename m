Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:59510 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab2BDXoo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2012 18:44:44 -0500
Date: Sun, 5 Feb 2012 00:44:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <snjw23@gmail.com>
cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [Q] Interleaved formats on the media bus
In-Reply-To: <4F2D79A9.8030504@gmail.com>
Message-ID: <Pine.LNX.4.64.1202050041001.3770@axis700.grange>
References: <4F27CF29.5090905@samsung.com> <20120201100007.GA841@valkosipuli.localdomain>
 <4F2924F8.3040408@samsung.com> <4F2D14ED.8080105@iki.fi> <4F2D4E2D.1030107@gmail.com>
 <4F2D5231.4000703@iki.fi> <4F2D79A9.8030504@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 4 Feb 2012, Sylwester Nawrocki wrote:

> Hi Sakari,

[snip]

> Yes, this is what I started with. What do you think about creating media 
> bus codes directly corresponding the the user defined MIPI-CSI data types ?

We've discussed this before with Laurent, IIRC, and the decision was, that 
since a "typical" CSI-2 configuration includes a CSI-2 phy, interfacing to 
a "standard" bridge, that can also receive parallel data directly, and the 
phy normally has a 1-to-1 mapping from CSI-2 formats to mediabus codes, 
so, we can just as well directly use respective mediabus codes to 
configure CSI-2 phys.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
