Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35395 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751604AbdEHSaE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 May 2017 14:30:04 -0400
Received: by mail-wm0-f68.google.com with SMTP id v4so12433025wmb.2
        for <linux-media@vger.kernel.org>; Mon, 08 May 2017 11:30:03 -0700 (PDT)
Date: Mon, 8 May 2017 20:29:58 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Eric Anholt <eric@anholt.net>
Cc: Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, geert@linux-m68k.org,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v2 0/2] rcar-du, vsp1: rcar-gen3: Add support for
 colorkey alpha blending
Message-ID: <20170508182958.gmi6rrwog4anqxea@phenom.ffwll.local>
References: <1494152007-30094-1-git-send-email-Alexandru_Gheorghe@mentor.com>
 <8737cf2tr2.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8737cf2tr2.fsf@eliezer.anholt.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 08, 2017 at 09:33:37AM -0700, Eric Anholt wrote:
> Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com> writes:
> 
> > Currently, rcar-du supports colorkeying  only for rcar-gen2 and it uses 
> > some hw capability of the display unit(DU) which is not available on gen3.
> > In order to implement colorkeying for gen3 we need to use the colorkey
> > capability of the VSPD, hence the need to change both drivers rcar-du and
> > vsp1.
> >
> > This patchset had been developed and tested on top of v4.9/rcar-3.5.1 from
> > git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas-bsp.git
> 
> A few questions:
> 
> Are other drivers interested in supporting this property?  VC4 has the
> 24-bit RGB colorkey, but I don't see YCBCR support.  Should it be
> documented in a generic location?
> 
> Does your colorkey end up forcing alpha to 1 for the plane when it's not
> matched?

I think generic color-key for plane compositioning would be nice, but I'm
not sure that's possible due to differences in how the key works.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
