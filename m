Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37952 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1758257AbcKCVtg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Nov 2016 17:49:36 -0400
Date: Thu, 3 Nov 2016 23:49:00 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
        linux-media@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: [PATCHv6] support for AD5820 camera auto-focus coil
Message-ID: <20161103214900.GH3217@valkosipuli.retiisi.org.uk>
References: <20160527205140.GA26767@amd>
 <20160805102611.GA13116@amd>
 <20160808080955.GA3182@valkosipuli.retiisi.org.uk>
 <20160808214132.GB2946@xo-6d-61-c0.localdomain>
 <20160810120105.GP3182@valkosipuli.retiisi.org.uk>
 <20160808232323.GC2946@xo-6d-61-c0.localdomain>
 <20160811111633.GR3182@valkosipuli.retiisi.org.uk>
 <20160818104539.GA7427@amd>
 <20160818202559.GF3182@valkosipuli.retiisi.org.uk>
 <20161103102727.GA10084@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161103102727.GA10084@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 03, 2016 at 11:27:27AM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > > > Yeah. I just compiled it but haven't tested it. I presume it'll work. :-)
> > > > > 
> > > > > I'm testing it on n900. I guess simpler hardware with ad5820 would be better for the
> > > > > test...
> > > > > 
> > > > > What hardware do you have?
> > > > 
> > > > N900. What else could it be? :-) :-)
> > > 
> > > Heh. Basically anything is easier to develop for than n900 :-(.
> > 
> > Is it?
> > 
> > I actually find the old Nokia devices very practical. It's easy to boot your
> > own kernel and things just work... until musb broke a bit recently. It
> > requires reconnecting the usb cable again to function.
> > 
> > I have to admit I mostly use an N9.
> 
> Well, if you compare that to development on PC, I prefer PC.
> 
> Even arm development boards are usually easier, as they don't need too
> complex userspace, and do have working serial ports.
> 
> But I do have a serial adapter for N900 now (thanks, sre), so my main
> problem now is that N900 takes a lot of time to boot into usable
> state.

Yeah... I just upgraded my Debian installation (armel over NFS) a few major
numbers and I find it a lot slower than it used to do. I presume that's
mostly because of systemd...

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
