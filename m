Return-path: <linux-media-owner@vger.kernel.org>
Received: from rs130.luxsci.com ([72.32.115.17]:48833 "EHLO rs130.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab2KMSN7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 13:13:59 -0500
Message-ID: <50A28DCB.7050707@firmworks.com>
Date: Tue, 13 Nov 2012 08:13:31 -1000
From: Mitch Bradley <wmb@firmworks.com>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
	linux-fbdev@vger.kernel.org, kernel@pengutronix.de,
	devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v8 2/6] video: add of helper for videomode
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de> <1352734626-27412-3-git-send-email-s.trumtrar@pengutronix.de> <20121113110837.GA30049@avionic-0098.mockup.avionic-design.de> <50A2878D.8020707@wwwdotorg.org> <20121113175147.GA2597@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121113175147.GA2597@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/13/2012 7:51 AM, Thierry Reding wrote:
> On Tue, Nov 13, 2012 at 10:46:53AM -0700, Stephen Warren wrote:
>> On 11/13/2012 04:08 AM, Thierry Reding wrote:
>>> On Mon, Nov 12, 2012 at 04:37:02PM +0100, Steffen Trumtrar wrote:
>>>> This adds support for reading display timings from DT or/and
>>>> convert one of those timings to a videomode. The
>>>> of_display_timing implementation supports multiple children where
>>>> each property can have up to 3 values. All children are read into
>>>> an array, that can be queried. of_get_videomode converts exactly
>>>> one of that timings to a struct videomode.
>>
>>>> diff --git
>>>> a/Documentation/devicetree/bindings/video/display-timings.txt
>>>> b/Documentation/devicetree/bindings/video/display-timings.txt
>>
>>>> + - clock-frequency: displayclock in Hz
>>>
>>> "display clock"?
>>
>> I /think/ I had suggested naming this clock-frequency before so that
>> the property name would be more standardized; other bindings use that
>> same name. But I'm not too attached to the name I guess.
> 
> That's not what I meant. I think "displayclock" should be two words in
> the description of the property. The property name is fine.

Given that modern display engines often have numerous clocks, perhaps it
would be better to use a more specific name, like for example "pixel-clock".

> 
> Thierry
> 
> 
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 
