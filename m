Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta12.westchester.pa.mail.comcast.net ([76.96.59.227]:59912
	"EHLO qmta12.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754284Ab0AQUDc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 15:03:32 -0500
Subject: Re: bug in pwc_set_shutter_speed v2.6.30.5 and fix
From: Jef Treece <treecej@comcast.net>
Reply-To: treece@gsp.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Martin Fuzzey <mfuzzey@gmail.com>, treece@gsp.org,
	linux-media@vger.kernel.org
In-Reply-To: <200908251207.06069.laurent.pinchart@ideasonboard.com>
References: <1251061440.7262.8.camel@stoppy.bicycle.org>
	 <200908251207.06069.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Jan 2010 12:03:29 -0800
Message-ID: <1263758609.22914.0.camel@stoppy.bicycle.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm pretty sure this is still broken as of 2.6.32.2
Jef Treece

On Tue, 2009-08-25 at 12:07 +0200, Laurent Pinchart wrote:
> On Sunday 23 August 2009 23:04:00 Jef Treece wrote:
> > I found in recent kernel versions, I think somewhere between 2.6.29.3
> > and 2.6.30.3, pwc_set_shutter_speed regressed.
> >
> > I was able to fix it with this one-line change
> > (drivers/media/video/pwc/pwc-ctrl.c line 755 in 2.6.30.5 source):
> >
> > 	ret = send_control_msg(pdev,
> > 		SET_LUM_CTL, SHUTTER_MODE_FORMATTER, &buf, sizeof(buf));
> >
> > change to
> >
> > 	ret = send_control_msg(pdev,
> > 		SET_LUM_CTL, SHUTTER_MODE_FORMATTER, &buf, 1);
> >
> > I hope you find this information useful.
> 
> This indeed looks like a regression to me.
> 
> Martin, as you've introduced the problem, could you look into it and send a 
> patch ? There might be other occurrences of wrong integer -> sizeof 
> conversions, so please review them carefully.
> 


