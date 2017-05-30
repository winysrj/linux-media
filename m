Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:53185 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750902AbdE3Ioe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 04:44:34 -0400
Date: Tue, 30 May 2017 10:44:33 +0200
From: Simon Horman <horms@verge.net.au>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        linux-renesas-soc@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        geert@linux-m68k.org, magnus.damm@gmail.com,
        hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se,
        sergei.shtylyov@cogentembedded.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 0/4] r8a7793 Gose video input support
Message-ID: <20170530084433.GD32139@verge.net.au>
References: <1495199224-16337-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <ed9be832-21f5-ac8c-56cf-02afd14f5a34@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed9be832-21f5-ac8c-56cf-02afd14f5a34@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 29, 2017 at 11:08:12AM +0200, Hans Verkuil wrote:
> On 05/19/2017 03:07 PM, Ulrich Hecht wrote:
> >Hi!
> >
> >This is a by-the-datasheet implementation of analog and digital video input
> >on the Gose board.
> >
> >This revision adds new bindings that distinguish between ADV7180 variants
> >with three and six input ports. There are numerous variants of this chip,
> >but since all that have "CP" in their names have three inputs, and all that
> >have "ST" have six, I have limited myself to two new compatible strings,
> >"adv7180cp" and "adv7180st".
> >
> >The digital input patch has received minor tweaks of the port names for
> >consistency, and the Gose analog input patch has been modified to use the
> >new bindings, and a composite video connector has been added.
> 
> Looks good. I assume the dts changes go through linux-renesas-soc@vger.kernel.org?

Yes, I will pick up the dts changes.

> I'll pick up the adv7180 changes.

Thanks!
