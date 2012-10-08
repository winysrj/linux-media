Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:49560 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab2JHQMw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 12:12:52 -0400
Message-ID: <5072FB6B.8070205@wwwdotorg.org>
Date: Mon, 08 Oct 2012 10:12:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2 v6] of: add helper to parse display timings
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>  <Pine.LNX.4.64.1210081000530.11034@axis700.grange>  <1349686878.3227.40.camel@deskari> <1479122.2xVsV4MZ4o@avalon> <1349698816.9437.5.camel@deskari>
In-Reply-To: <1349698816.9437.5.camel@deskari>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/08/2012 06:20 AM, Tomi Valkeinen wrote:
> On Mon, 2012-10-08 at 14:04 +0200, Laurent Pinchart wrote:
>> On Monday 08 October 2012 12:01:18 Tomi Valkeinen wrote:
>>> On Mon, 2012-10-08 at 10:25 +0200, Guennadi Liakhovetski
>>> wrote:
...
>>> Of course, if this is about describing the hardware, the
>>> default-mode property doesn't really fit in...
>> 
>> Maybe we should rename it to native-mode then ?
> 
> Hmm, right, if it means native mode, then it is describing the
> hardware. But would it make sense to require that the native mode
> is the first mode in the list, then? This would make the separate 
> default-mode/native-mode property not needed.

I'm not sure if device-tree guarantees that the nodes enumerate in a
specific order. If it does, then that may be a reasonable solution.

