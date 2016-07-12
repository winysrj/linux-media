Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37310 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbcGLXcV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 19:32:21 -0400
Date: Tue, 12 Jul 2016 20:32:01 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH] userspace API definitions for auto-focus coil
Message-ID: <20160712203201.7ffd8f22@recife.lan>
In-Reply-To: <20160618153846.GA15662@amd>
References: <20160602074544.GR26360@valkosipuli.retiisi.org.uk>
	<20160602193027.GB7984@amd>
	<20160602212746.GT26360@valkosipuli.retiisi.org.uk>
	<20160605190716.GA11321@amd>
	<575512E5.5030000@gmail.com>
	<20160611220654.GC26360@valkosipuli.retiisi.org.uk>
	<20160612084811.GA27446@amd>
	<20160612112253.GD26360@valkosipuli.retiisi.org.uk>
	<20160613191753.GA17459@amd>
	<20160617213545.GH24980@valkosipuli.retiisi.org.uk>
	<20160618153846.GA15662@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 18 Jun 2016 17:38:46 +0200
Pavel Machek <pavel@ucw.cz> escreveu:

> Hi!
> 
> > > Not V4L2_CID_USER_AD5820...?  
> > 
> > The rest of the controls have no USER as part of the macro name, so I
> > wouldn't use it here either.  
> 
> Ok.
> 
> > > Ok, separate header file for 2 lines seemed like a bit of overkill,
> > > but why not.  
> > 
> > That follows an existing pattern of how controls have been implemented in
> > other drivers.  
> 
> Ok.
> 
> > Could you merge this with the driver patch? I've dropped that from my ad5820
> > branch as it does not compile.  
> 
> Yes, merged patch should be in your inbox now.

The V4L2 core changes should be on a separate patch. Btw, you'll also
need to patch documentation to reflect such changes. We're right now
moving from DocBook to ReST markup language. The patches for it are
right now on a separate topic branch (docs-next), to be merged for
Kernel 4.8 on the next merge window.

You should either base the patch on such branch or wait for it to be
merged back mainstream to write such documentation additions.


> 
> Thanks,
> 									Pavel
> 


-- 
Thanks,
Mauro
