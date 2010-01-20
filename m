Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:49147 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab0ATNxt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 08:53:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [ANNOUNCE] git tree repositories
Date: Wed, 20 Jan 2010 14:54:00 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
References: <4B55445A.10300@infradead.org> <829197381001190204l3df81904gf8586f36187f212d@mail.gmail.com>
In-Reply-To: <829197381001190204l3df81904gf8586f36187f212d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001201454.00601.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

I think Mauro made it quite clear that this was just an announcement for work 
in progress that has been started on git support and that we still need to 
discuss how we will handle backports/compatibility with older kernels, so I'll 
go straight to the point I want to make.

On Tuesday 19 January 2010 11:04:13 Devin Heitmueller wrote:

[snip]

> I want to focus my development on v4l-dvb.  That said, I want a stable
> codebase on which I can write v4l-dvb drivers, without having to worry
> about whether or not my wireless driver is screwed up this week, or
> whether the ALSA guys broke my audio support for the fifth time in two
> years.  I don't want to wonder whether the crash I just experienced is
> because they've replaced the scheduler yet again and they're still
> shaking the bugs out.  I don't want to be at the mercy of whatever ABI
> changes they're doing this week which break my Nvidia card (and while
> I recognize as open source developers we care very little about
> "closed source drivers", we shouldn't really find it surprising that
> many developers who are rendering HD video might be using Nvidia
> cards).

I totally agree with you here. We obviously don't support developers who still 
want to use a 2.4.x kernel on their computer, so a line as to be drawn at some 
point.

This being said, I think we should not base the v4l-dvb git tree on the very 
latest Linus' tree. Linus himself stated during the LPC 2009 that subsystems 
should not pull from his tree at random point, but should rather use main 
kernel versions, or at least -rc versions. I think that basing the v4l-dvb 
tree on top of the last tag from mainline would be a better practice than 
pulling from it everyday.

This will obviously not solve the issue you mention, which is why we still 
need to agree on a nice way to handle backports, but that will make life 
easier for developers who want to try the v4l-dvb subsystem on top of the most 
recent kernel.

-- 
Regards,

Laurent Pinchart
