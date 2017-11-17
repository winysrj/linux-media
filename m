Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:51562 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbdKQJeB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 04:34:01 -0500
Date: Fri, 17 Nov 2017 10:33:55 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 03/10] v4l: platform: Add Renesas CEU driver
Message-ID: <20171117093355.GE4668@w540>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
 <1510743363-25798-4-git-send-email-jacopo+renesas@jmondi.org>
 <20171115124551.xrmrd34l4u4qgcms@valkosipuli.retiisi.org.uk>
 <20171115142511.GJ19070@w540>
 <20171117003651.e7oj362eqivyukcu@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20171117003651.e7oj362eqivyukcu@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari!

On Fri, Nov 17, 2017 at 02:36:51AM +0200, Sakari Ailus wrote:
> Hi Jacopo,
>
> On Wed, Nov 15, 2017 at 03:25:11PM +0100, jacopo mondi wrote:
> > Hi Sakari,
> >    thanks for review!
>
> You're welcome!
>
> > On Wed, Nov 15, 2017 at 02:45:51PM +0200, Sakari Ailus wrote:
> > > Hi Jacopo,
> > >
> > > Could you remove the original driver and send the patch using git
> > > send-email -C ? That way a single patch would address converting it to a
> > > proper V4L2 driver as well as move it to the correct location. The changes
> > > would be easier to review that way since then, well, it'd be easier to see
> > > the changes. :-)
> >
> > Actually I prefer not to remove the existing driver at the moment. See
> > the cover letter for reasons why not to do so right now...
>
> So it's about testing mostly? Does someone (possibly you) have those boards
> to test? I'd like to see this patchset to remove that last remaining SoC
> camera bridge driver. :-)

Well, we agreed that for most of those platforms, compile testing it
would be enough (let's believe in "if it compiles, it works"). I
personally don't have access to those boards, and frankly I'm not even
sure there are many of them around these days (I guess most of them
are not even produced anymore).

>
> >
> > Also, there's not that much code from the old driver in here, surely
> > less than the default 50% -C and -M options of 'git format-patch' use
> > as a threshold for detecting copies iirc..
>
> Oh, if that's so, then makes sense to review it as a new driver.

thanks :)

>
> >
> > > The same goes for the two V4L2 SoC camera sensor / video decoder drivers at
> > > the end of the set.
> > >
> >
> > Also in this case I prefer not to remove existing code, as long as
> > there are platforms using it..
>
> Couldn't they use this driver instead?

Oh, they will eventually, I hope :)

I would like to make sure we're all on the same page with this. My
preference would be:

1) Have renesas-ceu.c driver merged with Migo-R ported to use this new
driver as an 'example'.
2) Do not remove any of the existing soc_camera code at this point
3) Port all other 4 SH users of sh_mobile_ceu_camera to use the now
merged renesas-ceu driver
4) Remove sh_mobile_ceu_camera and soc_camera sensor drivers whose
only users were those 4 SH boards
5) Remove soc_camera completely. For my understanding there are some
PXA platforms still using soc_camera provided utilities somewhere.
Hans knows better, but we can discuss this once we'll get there.

Let me know if this is ok for everyone.

Thanks
   j
