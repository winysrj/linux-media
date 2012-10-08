Return-path: <linux-media-owner@vger.kernel.org>
Received: from rs130.luxsci.com ([72.32.115.17]:48197 "EHLO rs130.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab2JHQeo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Oct 2012 12:34:44 -0400
Message-ID: <50730084.3060805@firmworks.com>
Date: Mon, 08 Oct 2012 06:34:12 -1000
From: Mitch Bradley <wmb@firmworks.com>
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2 v6] of: add helper to parse display timings
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de> <1349373560-11128-2-git-send-email-s.trumtrar@pengutronix.de> <Pine.LNX.4.64.1210042307300.3744@axis700.grange> <506F0833.1090704@wwwdotorg.org> <Pine.LNX.4.64.1210081000530.11034@axis700.grange> <1349686878.3227.40.camel@deskari>
In-Reply-To: <1349686878.3227.40.camel@deskari>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/7/2012 11:01 PM, Tomi Valkeinen wrote:
> On Mon, 2012-10-08 at 10:25 +0200, Guennadi Liakhovetski wrote:
> 
>> In general, I might be misunderstanding something, but don't we have to 
>> distinguish between 2 types of information about display timings: (1) is 
>> defined by the display controller requirements, is known to the display 
>> driver and doesn't need to be present in timings DT. We did have some of 
>> these parameters in board data previously, because we didn't have proper 
>> display controller drivers... (2) is board specific configuration, and is 
>> such it has to be present in DT.
>>
>> In that way, doesn't "interlaced" belong to type (1) and thus doesn't need 
>> to be present in DT?
> 
> As I see it, this DT data is about the display (most commonly LCD
> panel), i.e. what video mode(s) the panel supports. If things were done
> my way, the panel's supported timings would be defined in the driver for
> the panel, and DT would be left to describe board specific data, but
> this approach has its benefits.
> 
> Thus, if you connect an interlaced panel to your board,


Do interlaced panels exist?  I have never seen one.


 you need to tell
> the display controller that this panel requires interlace signal. Also,
> pixel clock source doesn't make sense in this context, as this doesn't
> describe the actual used configuration, but only what the panel
> supports.
> 
> Of course, if this is about describing the hardware, the default-mode
> property doesn't really fit in...
> 
>  Tomi
> 
> 
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 
