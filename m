Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:57166 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755815AbcKDOtm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Nov 2016 10:49:42 -0400
Date: Fri, 4 Nov 2016 07:49:36 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org,
        aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
        linux-media@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: [PATCHv6] support for AD5820 camera auto-focus coil
Message-ID: <20161104144936.GG21430@atomide.com>
References: <20160808080955.GA3182@valkosipuli.retiisi.org.uk>
 <20160808214132.GB2946@xo-6d-61-c0.localdomain>
 <20160810120105.GP3182@valkosipuli.retiisi.org.uk>
 <20160808232323.GC2946@xo-6d-61-c0.localdomain>
 <20160811111633.GR3182@valkosipuli.retiisi.org.uk>
 <20160818104539.GA7427@amd>
 <20160818202559.GF3182@valkosipuli.retiisi.org.uk>
 <20161103102727.GA10084@amd>
 <20161103214900.GH3217@valkosipuli.retiisi.org.uk>
 <20161104074533.GB3679@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20161104074533.GB3679@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Pavel Machek <pavel@ucw.cz> [161104 00:45]:
> Hi!
> 
> > > > I have to admit I mostly use an N9.
> > > 
> > > Well, if you compare that to development on PC, I prefer PC.
> > > 
> > > Even arm development boards are usually easier, as they don't need too
> > > complex userspace, and do have working serial ports.
> > > 
> > > But I do have a serial adapter for N900 now (thanks, sre), so my main
> > > problem now is that N900 takes a lot of time to boot into usable
> > > state.
> > 
> > Yeah... I just upgraded my Debian installation (armel over NFS) a few major
> > numbers and I find it a lot slower than it used to do. I presume that's
> > mostly because of systemd...
> 
> I'm not sure if systemd is to blame. (I'm booting into full GUI...)
> 
> And yes, I noticed the slowdown in Debian 7 -> 8 transition, so I'm
> basically staying at Debian 7 as far as I can.

Maybe it's the armel vs armhf causing the slowdown?

Regards,

Tony


