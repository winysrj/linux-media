Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:34669 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751235AbdBHXDq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 18:03:46 -0500
Date: Wed, 8 Feb 2017 17:03:43 -0600
From: Rob Herring <robh@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: devicetree@vger.kernel.org, ivo.g.dimitrov.75@gmail.com,
        sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCHv2] dt: bindings: Add support for CSI1 bus
Message-ID: <20170208230343.iobyx6axfd3nn3gh@rob-hp-laptop>
References: <20161228183036.GA13139@amd>
 <20170111225335.GA21553@amd>
 <20170206094956.GA17974@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170206094956.GA17974@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 06, 2017 at 10:49:57AM +0100, Pavel Machek wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> In the vast majority of cases the bus type is known to the driver(s)
> since a receiver or transmitter can only support a single one. There
> are cases however where different options are possible.
> 
> The existing V4L2 OF support tries to figure out the bus type and
> parse the bus parameters based on that. This does not scale too well
> as there are multiple serial busses that share common properties.
> 
> Some hardware also supports multiple types of busses on the same
> interfaces.
> 
> Document the CSI1/CCP2 property strobe. It signifies the clock or
> strobe mode.
>  
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Reviewed-By: Sebastian Reichel <sre@kernel.org>

Acked-by: Rob Herring <robh@kernel.org>
