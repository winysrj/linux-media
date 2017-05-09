Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:58918 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750877AbdEIHMh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 May 2017 03:12:37 -0400
From: "Gheorghe, Alexandru" <Alexandru_Gheorghe@mentor.com>
To: Daniel Vetter <daniel@ffwll.ch>, Eric Anholt <eric@anholt.net>
CC: "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "sergei.shtylyov@cogentembedded.com"
        <sergei.shtylyov@cogentembedded.com>
Subject: RE: [PATCH v2 0/2] rcar-du, vsp1: rcar-gen3: Add support for colorkey
 alpha blending
Date: Tue, 9 May 2017 07:12:31 +0000
Message-ID: <ea75fbe96e7248a18032055d384be1c3@SVR-IES-MBX-03.mgc.mentorg.com>
References: <1494152007-30094-1-git-send-email-Alexandru_Gheorghe@mentor.com>
 <8737cf2tr2.fsf@eliezer.anholt.net>
 <20170508182958.gmi6rrwog4anqxea@phenom.ffwll.local>
In-Reply-To: <20170508182958.gmi6rrwog4anqxea@phenom.ffwll.local>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Daniel, Eric,

On Mon, Monday, May 8, 2017 9:29 PM +0200, Daniel Vetter wrote:
> -----Original Message-----
> From: Daniel Vetter [mailto:daniel.vetter@ffwll.ch] On Behalf Of Daniel
> Vetter
> Sent: 8 mai 2017 21:30
> To: Eric Anholt <eric@anholt.net>
> Cc: Gheorghe, Alexandru <Alexandru_Gheorghe@mentor.com>;
> laurent.pinchart@ideasonboard.com; linux-renesas-soc@vger.kernel.org;
> dri-devel@lists.freedesktop.org; linux-media@vger.kernel.org; geert@linux-
> m68k.org; sergei.shtylyov@cogentembedded.com
> Subject: Re: [PATCH v2 0/2] rcar-du, vsp1: rcar-gen3: Add support for
> colorkey alpha blending
> 
> On Mon, May 08, 2017 at 09:33:37AM -0700, Eric Anholt wrote:
> > Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com> writes:
> >
> > > Currently, rcar-du supports colorkeying  only for rcar-gen2 and it
> > > uses some hw capability of the display unit(DU) which is not available on
> gen3.
> > > In order to implement colorkeying for gen3 we need to use the
> > > colorkey capability of the VSPD, hence the need to change both
> > > drivers rcar-du and vsp1.
> > >
> > > This patchset had been developed and tested on top of
> > > v4.9/rcar-3.5.1 from
> > > git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas-bsp.git
> >
> > A few questions:
> >
> > Are other drivers interested in supporting this property?  VC4 has the
> > 24-bit RGB colorkey, but I don't see YCBCR support.  Should it be
> > documented in a generic location?


As far as I identified  armada, i815, nouveau, rcar-du, vmwgfx drivers have this notion of colorkey. 
There could be other HW which don't have this implemented yet.

> >
> > Does your colorkey end up forcing alpha to 1 for the plane when it's
> > not matched?

I think this  behavior is HW dependent, on R-CAR Gen3, the alpha for pixel that don't match is not touch. 

> 
> I think generic color-key for plane compositioning would be nice, but I'm not
> sure that's possible due to differences in how the key works.

I'm thinking of starting from the drivers that do have this property and see if there is any common ground for a generic color-key property/ies

> -Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch

Alex Gheorghe
