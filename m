Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46992 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab2KUPDm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 10:03:42 -0500
Message-ID: <50ACED4A.5040806@gmail.com>
Date: Wed, 21 Nov 2012 09:03:38 -0600
From: Rob Herring <robherring2@gmail.com>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	"Manjunathappa, Prakash" <prakash.pm@ti.com>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v12 2/6] video: add of helper for videomode
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de> <1353426896-6045-3-git-send-email-s.trumtrar@pengutronix.de> <A73F36158E33644199EB82C5EC81C7BC3E9FA7A0@DBDE01.ent.ti.com> <20121121114843.GC14013@pengutronix.de> <20121121115236.GA8886@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121121115236.GA8886@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/21/2012 05:52 AM, Thierry Reding wrote:
> On Wed, Nov 21, 2012 at 12:48:43PM +0100, Steffen Trumtrar wrote:
>> Hi!
>>
>> On Wed, Nov 21, 2012 at 10:12:43AM +0000, Manjunathappa, Prakash wrote:
>>> Hi Steffen,
>>>
>>> On Tue, Nov 20, 2012 at 21:24:52, Steffen Trumtrar wrote:
>>>> +/**
>>>> + * of_get_display_timings - parse all display_timing entries from a device_node
>>>> + * @np: device_node with the subnodes
>>>> + **/
>>>> +struct display_timings *of_get_display_timings(const struct device_node *np)
>>>> +{
>>>> +	struct device_node *timings_np;
>>>> +	struct device_node *entry;
>>>> +	struct device_node *native_mode;
>>>> +	struct display_timings *disp;
>>>> +
>>>> +	if (!np) {
>>>> +		pr_err("%s: no devicenode given\n", __func__);
>>>> +		return NULL;
>>>> +	}
>>>> +
>>>> +	timings_np = of_find_node_by_name(np, "display-timings");
>>>
>>> I get below build warnings on this line
>>> drivers/video/of_display_timing.c: In function 'of_get_display_timings':
>>> drivers/video/of_display_timing.c:109:2: warning: passing argument 1 of 'of_find_node_by_name' discards qualifiers from pointer target type
>>> include/linux/of.h:167:28: note: expected 'struct device_node *' but argument is of type 'const struct device_node *'
>>>
>>>> + * of_display_timings_exists - check if a display-timings node is provided
>>>> + * @np: device_node with the timing
>>>> + **/
>>>> +int of_display_timings_exists(const struct device_node *np)
>>>> +{
>>>> +	struct device_node *timings_np;
>>>> +
>>>> +	if (!np)
>>>> +		return -EINVAL;
>>>> +
>>>> +	timings_np = of_parse_phandle(np, "display-timings", 0);
>>>
>>> Also here:
>>> drivers/video/of_display_timing.c: In function 'of_display_timings_exists':
>>> drivers/video/of_display_timing.c:209:2: warning: passing argument 1 of 'of_parse_phandle' discards qualifiers from pointer target type
>>> include/linux/of.h:258:28: note: expected 'struct device_node *' but argument is of type 'const struct device_node *'
>>>
>>
>> The warnings are because the of-functions do not use const pointers where they
>> should. I had two options: don't use const pointers even if they should be and
>> have no warnings or use const pointers and have a correct API. (Third option:
>> send patches for of-functions). I chose the second option.
> 
> Maybe a better approach would be a combination of 1 and 3: don't use
> const pointers for struct device_node for now and bring the issue up
> with the OF maintainers, possibly with patches attached that fix the
> problematic functions.

Why does this need to be const? Since some DT functions increment
refcount the node, I'm not sure that making struct device_node const in
general is right thing to do. I do think it should be okay for
of_parse_phandle.

Rob
