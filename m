Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35112 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755864AbdAKWUS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 17:20:18 -0500
Date: Thu, 12 Jan 2017 00:19:29 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] dt: bindings: Add support for CSI1 bus
Message-ID: <20170111221929.GG10831@valkosipuli.retiisi.org.uk>
References: <20161228183036.GA13139@amd>
 <20170103203854.gyyfzxbnnxl3flov@rob-hp-laptop>
 <20170104085420.GN3958@valkosipuli.retiisi.org.uk>
 <20170111220648.GE29366@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170111220648.GE29366@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Wed, Jan 11, 2017 at 11:06:48PM +0100, Pavel Machek wrote:
> > > > +- clock-inv: Clock or strobe signal inversion.
> > > > +  Possible values: 0 -- not inverted; 1 -- inverted
> > > 
> > > "invert" assumes I know what is normal and I do not. Define what is 
> > > "normal" and name the property the opposite of that. If normal is data 
> > > shifted on clock rising edge, then call the the property 
> > > "clock-shift-falling-edge" for example..
> > 
> > The hardware documentation says this is the "strobe/clock inversion control
> > signal". I'm not entirely sure whether this is just signal polarity (it's a
> > differential signal) or inversion of an internal signal of the CCP2 block.
> > 
> > It might make sense to make this a private property for the OMAP 3 ISP
> > instead. If it's seen elsewhere, then think about it again. I doubt it
> > would, as CCP2 is an old bus that's used on Nokia N9, N950 and N900.
> > 
> > As strobe is included, I'd add that to the name. Say,
> > "ti,clock-strobe-inv".
> 
> Hmm. N900 does not use inversion. Would it make sense to simply
> hardcode it to "not-inverted" for now?
> 
> Device tree changes are PITA :-(.

I can't remember what's used for the N9 secondary camera. As you said, we
can always add it if needed though. So works for me.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
