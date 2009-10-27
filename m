Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54377 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932088AbZJ0IEX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 04:04:23 -0400
Date: Tue, 27 Oct 2009 09:04:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Cohen David Abraham <david.cohen@nokia.com>,
	"Koskipaa Antti (Nokia-D/Helsinki)" <antti.koskipaa@nokia.com>,
	Zutshi Vimarsh <vimarsh.zutshi@nokia.com>
Subject: Re: RFCv2: Media controller proposal
In-Reply-To: <4AB7B66E.6080308@maxwell.research.nokia.com>
Message-ID: <Pine.LNX.4.64.0910270854300.4828@axis700.grange>
References: <200909100913.09065.hverkuil@xs4all.nl> <200909112123.44778.hverkuil@xs4all.nl>
 <20090911165937.776a638d@caramujo.chehab.org> <200909112215.15155.hverkuil@xs4all.nl>
 <20090911183758.31184072@caramujo.chehab.org> <4AB7B66E.6080308@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

(repeating my preamble from a previous post)

This is a general comment to the whole "media controller" work: having 
given a talk at the ELC-E in Grenoble on soc-camera, I mentioned briefly a 
few related RFCs, including this one. I've got a couple of comments back, 
including the following ones (which is to say, opinions are not mine and 
may or may not be relevant, I'm just fulfilling my promise to pass them 
on;)):

1) what about DVB? Wouldn't they also benefit from such an API? I wasn't 
able to reply to the question, whether the DVB folks know about this and 
have a chance to take part in the discussion and eventually use this API?

2) what I am even less sure about is, whether ALSA / ASoC have been 
mentioned as possible users of MC, or, at least, possible sources for 
ideas. ASoC has definitely been mentioned as an audio analog of 
soc-camera, so, I'll be looking at that - at least at their documentation 
- to see if I can borrow some of their ideas:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
