Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54455 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483Ab2AFK2A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 05:28:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC 03/17] vivi: Add an integer menu test control
Date: Fri, 6 Jan 2012 11:28:19 +0100
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <4F06CAC5.8010902@maxwell.research.nokia.com> <4F06CB48.8050509@maxwell.research.nokia.com>
In-Reply-To: <4F06CB48.8050509@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201061128.19999.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Friday 06 January 2012 11:22:00 Sakari Ailus wrote:
> Sakari Ailus wrote:
> ...
> 
> > I put it there to limit the maximum to 8 instead of 9, but 9 would be
> > equally good. I'll change it.
> 
> Or not. 8 is still the index of the last value. min is one  to start the
> menu from the second item. Would you like that to be changed to zero?

If it was done on purpose I'm fine with it. I was just pointing it out in case 
it was done by mistake.

-- 
Regards,

Laurent Pinchart
