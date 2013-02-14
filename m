Return-path: <linux-media-owner@vger.kernel.org>
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:15969
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756814Ab3BNJbC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Feb 2013 04:31:02 -0500
From: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: AW: omapdss/omap3isp/omapfb: Picture from omap3isp can't recover
 after a blank/unblank (or overlay disables after resuming)
Date: Thu, 14 Feb 2013 09:30:55 +0000
Message-ID: <6EE9CD707FBED24483D4CB0162E8546724593AEC@AMSPRD0711MB532.eurprd07.prod.outlook.com>
References: <6EE9CD707FBED24483D4CB0162E85467245822C8@AMSPRD0711MB532.eurprd07.prod.outlook.com>
 <51138BCA.4010701@ti.com>
In-Reply-To: <51138BCA.4010701@ti.com>
Content-Language: de-DE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

Tomi Valkeinen wrote on 2013-02-07:

> FIFO underflow means that the DSS hardware wasn't able to fetch enough 
> pixel data in time to output them to the panel. Sometimes this happens 
> because of plain misconfiguration, but usually it happens because of 
> the hardware just can't do things fast enough with the configuration 
> the user has set.
> 
> In this case I see that you are using VRFB rotation on fb0, and the 
> rotation is
> 270 degrees. Rotating the fb is heavy, especially 90 and 270 degrees. 
> It may be that when the DSS is resumed, there's a peak in the mem 
> usage as DSS suddenly needs to fetch lots of data.
> 
> Another issue that could be involved is power management. After the 
> DSS is suspended, parts of OMAP may be put to sleep. When the DSS is 
> resumed, these parts need to be woken up, and it may be that there's a 
> higher mem latency for a short period of time right after resume. 
> Which could again cause DSS not getting enough pixel data.
> 
> You say the issue doesn't happen if you disable fb0. What happens if 
> you disable fb0, blank the screen, then unblank the screen, and after 
> that enable fb0 again?

By "disable fb0" do you mean disconnect fb0 from ovl0 or disable ovl0?
I have done both:
http://pastebin.com/Bxm1Z2RY

This works as expected.

Further tests I have done:

Enable fb1/ovl1 and hit some keys on the keyboard to let fb0/ovl0 update in the
background causes a fifo underflow too:
http://pastebin.com/f3JnMLsV

This happens only, if I enable the vrfb (rotate=3). So the whole thing
seems to be a rotation issue. Do you have some hints to trace down
the problem?

> How about if you disable VRFB rotation, either totally, or set the 
> rotation to 0 or 180 degrees?

Disable rotation is not an option for me, as we have a "wrong" oriented
portrait display with 480x800 which we must use in landscape mode...

> And you can also tune the PM so that deeper sleep states are prevented.
> I don't remember right away how this is done, though.
> 
>  Tomi

Regards,
Florian

P.S.
@Laurent: Do you use your streamer on a headless device? What is your DSS-config?
Do you have a framebuffer-console on fb0?


