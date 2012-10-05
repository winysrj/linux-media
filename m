Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:40510 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650Ab2JEQVk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 12:21:40 -0400
Message-ID: <506F0911.1050808@wwwdotorg.org>
Date: Fri, 05 Oct 2012 10:21:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2 v6] of: add helper to parse display timings
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de> <1349373560-11128-2-git-send-email-s.trumtrar@pengutronix.de> <506DD9B4.40409@wwwdotorg.org> <20121005161620.GB2053@pengutronix.de>
In-Reply-To: <20121005161620.GB2053@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/05/2012 10:16 AM, Steffen Trumtrar wrote:
> On Thu, Oct 04, 2012 at 12:47:16PM -0600, Stephen Warren wrote:
>> On 10/04/2012 11:59 AM, Steffen Trumtrar wrote:
...
>>> +	for_each_child_of_node(timings_np, entry) {
>>> +		struct signal_timing *st;
>>> +
>>> +		st = of_get_display_timing(entry);
>>> +
>>> +		if (!st)
>>> +			continue;
>>
>> I wonder if that shouldn't be an error?
> 
> In the sense of a pr_err not a -EINVAL I presume?! It is a little bit quiet in
> case of a faulty spec, that is right.

I did mean return an error; if we try to parse something and can't,
shouldn't we return an error?

I suppose it may be possible to limp on and use whatever subset of modes
could be parsed and drop the others, which is what this code does, but
the code after the loop would definitely return an error if zero timings
were parseable.
