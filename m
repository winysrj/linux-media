Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:52430 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932464AbcLNPJm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 10:09:42 -0500
Date: Wed, 14 Dec 2016 07:08:19 -0800
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org,
        aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
        linux-media@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: [PATCHv6] support for AD5820 camera auto-focus coil
Message-ID: <20161214150819.GW4920@atomide.com>
References: <20160521054336.GA27123@amd>
 <20160808080955.GA3182@valkosipuli.retiisi.org.uk>
 <20160808214132.GB2946@xo-6d-61-c0.localdomain>
 <201612141438.16603@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <201612141438.16603@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Pali Rohár <pali.rohar@gmail.com> [161214 05:38]:
> On Monday 08 August 2016 23:41:32 Pavel Machek wrote:
> > On Mon 2016-08-08 11:09:56, Sakari Ailus wrote:
> > > On Fri, Aug 05, 2016 at 12:26:11PM +0200, Pavel Machek wrote:
> > > > This adds support for AD5820 autofocus coil, found for example in
> > > > Nokia N900 smartphone.
> > > 
> > > Thanks, Pavel!
> > > 
> > > Let's use V4L2_CID_FOCUS_ABSOLUTE, as is in the patch. If we get
> > > something better in the future, we'll switch to that then.
> > > 
> > > I've applied this to ad5820 branch in my tree.
> > 
> > Thanks. If I understands things correctly, both DTS patch and this
> > patch are waiting in your tree, so we should be good to go for 4.9
> > (unless some unexpected problems surface)?
> > 
> > Best regards,
> > 									Pavel
> 
> Was DTS patch merged into 4.9? At least I do not see updated that dts 
> file omap3-n900.dts in linus tree...

If it's not in current mainline or next, it's off my radar so sounds
like I've somehow missed it and needs resending..

Tony
