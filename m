Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214EFC10F00
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED8B52075B
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfBVLRZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:17:25 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:50147 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfBVLRZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 06:17:25 -0500
X-Originating-IP: 31.157.247.153
Received: from uno.localdomain (unknown [31.157.247.153])
        (Authenticated sender: jacopo@jmondi.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id C327520016;
        Fri, 22 Feb 2019 11:17:20 +0000 (UTC)
Date:   Fri, 22 Feb 2019 12:17:47 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v2 16/30] v4l: subdev: Add [GS]_ROUTING subdev ioctls and
 operations
Message-ID: <20190222111747.tlj2xdjhnjwrlqxx@uno.localdomain>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-17-niklas.soderlund+renesas@ragnatech.se>
 <20190221143940.k56z2vwovu3y5okh@uno.localdomain>
 <20190221223131.rago5jmpxhygtuep@kekkonen.localdomain>
 <20190222084019.62atdkk6qipnugvf@uno.localdomain>
 <20190222110429.ybmqdwba5rszntb7@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5ugcf5gnqzm5c2h3"
Content-Disposition: inline
In-Reply-To: <20190222110429.ybmqdwba5rszntb7@paasikivi.fi.intel.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--5ugcf5gnqzm5c2h3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,
    thanks for your suggestions.

On Fri, Feb 22, 2019 at 01:04:29PM +0200, Sakari Ailus wrote:
> Hi Jacopo,

[snip]

> > On the previous example, I thought about GMSL-like devices, that can
> > output the video streams received from different remotes in a
> > separate virtual channel, at the same time.
> >
> > A possible routing table in that case would be like:
> >
> > Pads 0, 1, 2, 3 = SINKS
> > Pad 4 = SOURCE with 4 streams (1 for each VC)
> >
> > 0/0 -> 4/0
> > 0/0 -> 4/1
> > 0/0 -> 4/2
> > 0/0 -> 4/3
> > 1/0 -> 4/0
> > 1/0 -> 4/1
> > 1/0 -> 4/2
> > 1/0 -> 4/3
> > 2/0 -> 4/0
> > 2/0 -> 4/1
> > 2/0 -> 4/2
> > 2/0 -> 4/3
> > 3/0 -> 4/0
> > 3/0 -> 4/1
> > 3/0 -> 4/2
> > 3/0 -> 4/3
>
> If more than one pad can handle multiplexed streams, then you may end up in
> a situation like that. Indeed.
>

Please note that in this case there is only one pad that can handle
multiplexed stream. The size of the routing table is the
multiplication of the total number of pads by the product of all
streams per pad. In this case (4 * (1 * 1 * 1 * 4))

> >
> > With only one route per virtual channel active at a time.

[snip]

> >
> > Thanks, I had a look at the MEDIA_ ioctls yesterday, G_TOPOLOGY in
> > particular, which uses several pointers to arrays.
> >
> > Unfortunately, I didn't come up with anything better than using a
> > translation structure, from the IOCTL layer to the subdevice
> > operations layer:
> > https://paste.debian.net/hidden/b192969d/
> > (sharing a link for early comments, I can send v3 and you can comment
> > there directly if you prefer to :)
>
> Hmm. That is a downside indeed. It's still a lesser problem than the compat
> code in general --- which has been a source for bugs as well as nasty
> security problems over time.
>

Good!

> I think we need a naming scheme for such structs. How about just
> calling that struct e.g. v4l2_subdev_krouting instead? It's simple, easy to
> understand and it includes a suggestion which one is the kernel-only
> variant.
>

I kind of like that! thanks!

> You can btw. zero the struct memory by assigning { 0 } to it in
> declaration. memset() in general is much more trouble. In this case you
> could even do the assignments in delaration as well.
>

Thanks, noted. I have been lazy and copied memset from other places in
the ioctl handling code. I should check on your suggestions because I
remember one of the many 0-initialization statement was a GCC specific one,
don't remember which...

Initializing in-place would solve both issues :)

> There is a check that requires that one pad is a source and another is a
> sink; I think we could remove that check as well.

Correct, I'll handle that!

Thanks again
   j

>
> --
> Regards,
>
> Sakari Ailus
> sakari.ailus@linux.intel.com

--5ugcf5gnqzm5c2h3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlxv2lsACgkQcjQGjxah
VjyFfA/+NuZNtc5FBX4OQ8sR2SVQChW+SQALArIDDTAIfENZwoSX935loUecQo8I
lA+mw3LP3EeTGPtLJXbTARVU6mJF3P57oXmwsEsmU82uSMTLnIEfD614wb1cNFbG
IyAyRhsKseUue4FZNzrHRvttdpaiAkv/6xlDFXNXmv+ysUAsSF8qFrVt38Eayo+8
+ntqOefbPWKVL3UsazQbxCU4nVfJhcIKYYoNL3SvcHffS3Yak9blA/lZ3DecuHcI
LJ6Le2OgeA4b0AHwVVnDi7TR4kUM+68nq7JXQ+kj1dkg8lqSAwuF8zaslwoXcGU9
rGtb00d8DJGo6FjkcZh6sAtfO1Slih4gDPH9usWJ+eIgpRCathSeLKjA03bORtvD
y44kz/EvfWCSPncQCIle4Oxxc8hz93L7zNoqCDXrXhCB/rOcG8PeSd9rXRhj/Cop
tODMU878h+5kvvS7ejTWtZn2CzPWCRt4jyx6o+GBrDMpKLslaaBvLAbZhdlLvTTN
BNXlV/l7O031Yf5xEjSNIIOIaCWjeQgvz9640dTbStYZdwjoMIw9/BXJOGVs3QBl
MIV5JDD4+jOY6Vaa25ioRZRq+Bb2CNEPl5JHGBI2dHkbnDG0gsCZnngaYIUzM8WT
wWr/P8vL8x19FYmqCGKDz9RXa2KpIzy5c6hSMgymDaGjx4P0hYI=
=QawV
-----END PGP SIGNATURE-----

--5ugcf5gnqzm5c2h3--
