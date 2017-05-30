Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:53230 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750896AbdE3Ip0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 04:45:26 -0400
Date: Tue, 30 May 2017 10:45:25 +0200
From: Simon Horman <horms@verge.net.au>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: linux-renesas-soc@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        geert@linux-m68k.org, magnus.damm@gmail.com,
        hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se,
        sergei.shtylyov@cogentembedded.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 0/4] r8a7793 Gose video input support
Message-ID: <20170530084525.GE32139@verge.net.au>
References: <1495199224-16337-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <20170526064907.GD2628@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170526064907.GD2628@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 26, 2017 at 08:49:07AM +0200, Simon Horman wrote:
> On Fri, May 19, 2017 at 03:07:00PM +0200, Ulrich Hecht wrote:
> > Hi!
> > 
> > This is a by-the-datasheet implementation of analog and digital video input
> > on the Gose board.
> > 
> > This revision adds new bindings that distinguish between ADV7180 variants
> > with three and six input ports. There are numerous variants of this chip,
> > but since all that have "CP" in their names have three inputs, and all that
> > have "ST" have six, I have limited myself to two new compatible strings,
> > "adv7180cp" and "adv7180st".
> > 
> > The digital input patch has received minor tweaks of the port names for
> > consistency, and the Gose analog input patch has been modified to use the
> > new bindings, and a composite video connector has been added.
> > 
> > CU
> > Uli
> > 
> > 
> > Changes since v2:
> > - hdmi: port hdmi_con renamed to hdmi_con_out
> > - adv7180: added new compatibility strings and bindings
> > - composite: added connector, use new bindings
> > 
> > Changes since v1:
> > - r8a7793.dtsi: added VIN2
> > - modeled HDMI decoder input/output and connector
> > - added "renesas,rcar-gen2-vin" compat strings
> > - removed unnecessary "remote" node and aliases
> > - set ADV7612 interrupt to GP4_2
> > 
> > 
> > Ulrich Hecht (4):
> >   ARM: dts: gose: add HDMI input
> 
> I have queued-up the above patch for v4.13.
> 
> >   media: adv7180: add adv7180cp, adv7180st compatible strings
> >   media: adv7180: Add adv7180cp, adv7180st bindings
> >   ARM: dts: gose: add composite video input
> 
> I have marked the above dts patch as "deferred" pending acceptance
> of the binding. Please repost or otherwise ping me once that has happened.

It looks like Hans will pick up the driver patches.
Accordingly I have queued-up the last dts patch above.
