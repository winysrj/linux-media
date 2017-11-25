Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:40953 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbdKYSSG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Nov 2017 13:18:06 -0500
Date: Sat, 25 Nov 2017 19:17:59 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 03/10] v4l: platform: Add Renesas CEU driver
Message-ID: <20171125181759.GE12305@w540>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
 <1510743363-25798-4-git-send-email-jacopo+renesas@jmondi.org>
 <20171115124551.xrmrd34l4u4qgcms@valkosipuli.retiisi.org.uk>
 <20171115142511.GJ19070@w540>
 <20171117003651.e7oj362eqivyukcu@valkosipuli.retiisi.org.uk>
 <20171117093355.GE4668@w540>
 <20171125155613.ebblr7hdr6irs2h7@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20171125155613.ebblr7hdr6irs2h7@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari!

On Sat, Nov 25, 2017 at 05:56:14PM +0200, Sakari Ailus wrote:
> On Fri, Nov 17, 2017 at 10:33:55AM +0100, jacopo mondi wrote:
> > Hi Sakari!
> >

[snip]

> > I would like to make sure we're all on the same page with this. My
> > preference would be:
> >
> > 1) Have renesas-ceu.c driver merged with Migo-R ported to use this new
> > driver as an 'example'.
> > 2) Do not remove any of the existing soc_camera code at this point
> > 3) Port all other 4 SH users of sh_mobile_ceu_camera to use the now
> > merged renesas-ceu driver
> > 4) Remove sh_mobile_ceu_camera and soc_camera sensor drivers whose
> > only users were those 4 SH boards
> > 5) Remove soc_camera completely. For my understanding there are some
> > PXA platforms still using soc_camera provided utilities somewhere.
> > Hans knows better, but we can discuss this once we'll get there.
>
> The first point here is basically done by this patchset and your intent
> would be to proceed with the rest, right?

Yep, you're right!

>
> The above seems good; what I wanted to say was that I'd like to avoid
> ending up in a permanent situation where some hardware works with the new
> driver and some will continue to use the old one.

I hope that being the last users of soc_camera, there will be enough
motivations to complete all the above points :)

Thanks
   j

>
> --
> Kind regards,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi
