Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:59334 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab2JHQKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 12:10:35 -0400
Message-ID: <5072FAF7.2090900@wwwdotorg.org>
Date: Mon, 08 Oct 2012 10:10:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2 v6] of: add helper to parse display timings
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de> <1349373560-11128-2-git-send-email-s.trumtrar@pengutronix.de> <Pine.LNX.4.64.1210042307300.3744@axis700.grange> <506F0833.1090704@wwwdotorg.org> <Pine.LNX.4.64.1210081000530.11034@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1210081000530.11034@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/08/2012 02:25 AM, Guennadi Liakhovetski wrote:
> On Fri, 5 Oct 2012, Stephen Warren wrote:
> 
>> On 10/04/2012 03:35 PM, Guennadi Liakhovetski wrote:
>>> Hi Steffen
>>>
>>> Sorry for chiming in so late in the game, but I've long been wanting to 
>>> have a look at this and compare with what we do for V4L2, so, this seems a 
>>> great opportunity to me:-)
>>>
>>> On Thu, 4 Oct 2012, Steffen Trumtrar wrote:
>>
>>>> diff --git a/Documentation/devicetree/bindings/video/display-timings.txt b/Documentation/devicetree/bindings/video/display-timings.txt
>>
>>>> +timings-subnode
>>>> +---------------
>>>> +
>>>> +required properties:
>>>> + - hactive, vactive: Display resolution
>>>> + - hfront-porch, hback-porch, hsync-len: Horizontal Display timing parameters
>>>> +   in pixels
>>>> +   vfront-porch, vback-porch, vsync-len: Vertical display timing parameters in
>>>> +   lines
>>>> + - clock: displayclock in Hz
>>>
>>> You're going to hate me for this, but eventually we want to actually 
>>> reference clock objects in our DT bindings. For now, even if you don't 
>>> want to actually add clock phandles and stuff here, I think, using the 
>>> standard "clock-frequency" property would be much better!
>>
>> In a definition of a display timing, we will never need to use the clock
>> binding; the clock binding would be used by the HW module that is
>> generating a timing, not by the timing definition itself.
> 
> You mean clock consumer bindings will be in the display device DT node? 
> And the display-timings node will be its child?

Yes

...
>>>> + - interlaced (bool)
>>>
>>> Is "interlaced" a property of the hardware, i.e. of the board? Can the 
>>> same display controller on one board require interlaced data and on 
>>> another board - progressive?
>>
>> Interlace is a property of a display mode. It's quite possible for a
>> particular display controller to switch between interlace and
>> progressive output at run-time. For example, reconfiguring the output
>> between 480i, 720p, 1080i, 1080p modes. Admittedly, if you're talking to
>> a built-in LCD display, you're probably always going to be driving the
>> single mode required by the panel, and that mode will likely always be
>> progressive. However, since this binding attempts to describe any
>> display timing, I think we still need this property per mode.
> 
> But why do you need this in the DT then at all?

Because the driver for the display controller has no idea what display
or panel will be connected to it.

> If it's fixed, as required 
> per display controller, then its driver will know it. If it's runtime 
> configurable, then it's a purely software parameter and doesn't depend on 
> the board?

interlace-vs-progressive isn't "fixed, as required per display
controller", but is a property of the mode being sent by the display
controller, and the requirements for that mode are driven by the
panel/display connected to the display controller, not the display
controller, in general.

...
>>> BTW, I'm not very familiar with display 
>>> interfaces, but for interlaced you probably sometimes use a field signal, 
>>> whose polarity you also want to specify here? We use a "field-even-active" 
>>> integer property for it.
>>
>> I think that's a property of the display controller itself, rather than
>> an individual mode, although I'm not 100% certain. My assertion is that
>> the physical interface that the display controller is driving will
>> determine whether embedded or separate sync is used, and in the separate
>> sync case, how the field signal is defined, and that all interlace modes
>> driven over that interface will use the same field signal definition.
> 
> In general, I might be misunderstanding something, but don't we have to 
> distinguish between 2 types of information about display timings: (1) is 
> defined by the display controller requirements, is known to the display 
> driver and doesn't need to be present in timings DT. We did have some of 
> these parameters in board data previously, because we didn't have proper 
> display controller drivers...

Yes, there probably is data of that kind, but the display mode timings
binding is only address standardized display timings information, not
controller-specific information, and hence doesn't cover this case.

> (2) is board specific configuration, and is
> such it has to be present in DT.

Certainly, yes.

> In that way, doesn't "interlaced" belong to type (1) and thus doesn't need 
> to be present in DT?

I don't believe so.
