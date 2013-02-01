Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44148 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562Ab3BAWOf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 17:14:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: AW: omapdss/omap3isp/omapfb: Picture from omap3isp can't recover after a blank/unblank (or overlay disables after resuming)
Date: Fri, 01 Feb 2013 23:14:42 +0100
Message-ID: <1458197.Ntc9McJ8cJ@avalon>
In-Reply-To: <6EE9CD707FBED24483D4CB0162E85467245880A0@AMSPRD0711MB532.eurprd07.prod.outlook.com>
References: <6EE9CD707FBED24483D4CB0162E85467245822C8@AMSPRD0711MB532.eurprd07.prod.outlook.com> <2253226.r6AZgSrtcE@avalon> <6EE9CD707FBED24483D4CB0162E85467245880A0@AMSPRD0711MB532.eurprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On Thursday 31 January 2013 13:06:53 Florian Neuhaus wrote:
> Hi Laurent,
> 
> Thank you for your help, see my notes below:
> 
> Laurent Pinchart wrote on 2013-01-30:
> >> Will result in the following and the following (screen flickers and goes
> >> black again):
> >> [ 5293.617095] omapdss DISPC error: FIFO UNDERFLOW on gfx, disabling the
> >> overlay
> >> [ 5293.678283] omapdss DISPC error: FIFO UNDERFLOW on vid2, disabling the
> >> overlay
> >> 
> >> Output of mediactl -p while streaming:
> >> http://pastebin.com/d9zDfKXu
> >> 
> >> OMAPDSS-config:
> >> http://pastebin.com/JjF0CcCS
> >> 
> >> Now my questions:
> >> Is this behaviour expected?
> > 
> > I don't think so. I'm not an expert on the OMAP DSS, but I wouldn't
> > consider the above messages as normal.
> 
> Just as a note: This does not happen, if I disable the fb0 upon start of the
> streamer.
> My DSS config before the streamer start:
> 
> fb0 --- gfx --- lcd --- LCD
> fb1 --- vid1 -/
>         vid2 /
> 
> Description: I am using fb0 for the framebuffer-console. The fb1 is
> connected with the overlay vid1 and used as the colorkey in your streamer
> application. vid2 is directly used from within the streamer app for the
> ISP-output (at least I think so ;)). Everything is connected to the
> lcd-manager and outputted to a physical attached LCD.
> 
> My DSS config when streamer is running:
> 
> fb0     gfx --- lcd --- LCD
> fb1 --- vid1 -/
>         vid2 /
> 
> With this workaround the streamer will continue streaming after a
> blank/unblank.
>
> > As buffers will stop flowing until the screen is unblanked, the live
> > application will exit after a short select() timeout. This is an
> > application issue.
> 
> If the AF/AEWB unit is enabled, the timeout doesn't happen as the
> H3A-unit delivers still OMAP3_ISP_EVENT_EXCEPTION events.

Ah right. My live application should still be fixed not to timeout when AEWB 
is disabled, but that's out of scope here.

> > It doesn't explain the omapdss error, Tomi might be able to provide more
> > information about that (but he is currently away until beginning of
> > February if I'm not mistaken).
> 
> That would be very nice!

As this seems to be mostly a DSS issue I'll let Tomi handle it :-)

-- 
Regards,

Laurent Pinchart

