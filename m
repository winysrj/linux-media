Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51680 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753760AbcLOGwc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 01:52:32 -0500
Date: Thu, 15 Dec 2016 08:50:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tony Lindgren <tony@atomide.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org,
        aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
        linux-media@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: [PATCHv6] support for AD5820 camera auto-focus coil
Message-ID: <20161215065022.GC16630@valkosipuli.retiisi.org.uk>
References: <20160521054336.GA27123@amd>
 <20160808080955.GA3182@valkosipuli.retiisi.org.uk>
 <20160808214132.GB2946@xo-6d-61-c0.localdomain>
 <201612141438.16603@pali>
 <20161214150819.GW4920@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20161214150819.GW4920@atomide.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pali and Tony,

On Wed, Dec 14, 2016 at 07:08:19AM -0800, Tony Lindgren wrote:
> * Pali Rohár <pali.rohar@gmail.com> [161214 05:38]:
> > On Monday 08 August 2016 23:41:32 Pavel Machek wrote:
> > > On Mon 2016-08-08 11:09:56, Sakari Ailus wrote:
> > > > On Fri, Aug 05, 2016 at 12:26:11PM +0200, Pavel Machek wrote:
> > > > > This adds support for AD5820 autofocus coil, found for example in
> > > > > Nokia N900 smartphone.
> > > > 
> > > > Thanks, Pavel!
> > > > 
> > > > Let's use V4L2_CID_FOCUS_ABSOLUTE, as is in the patch. If we get
> > > > something better in the future, we'll switch to that then.
> > > > 
> > > > I've applied this to ad5820 branch in my tree.
> > > 
> > > Thanks. If I understands things correctly, both DTS patch and this
> > > patch are waiting in your tree, so we should be good to go for 4.9
> > > (unless some unexpected problems surface)?
> > > 
> > > Best regards,
> > > 									Pavel
> > 
> > Was DTS patch merged into 4.9? At least I do not see updated that dts 
> > file omap3-n900.dts in linus tree...
> 
> If it's not in current mainline or next, it's off my radar so sounds
> like I've somehow missed it and needs resending..

Where's this patch? I remember seeing the driver patch and the DT
documentation but no actual DT source patch for the N900.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
