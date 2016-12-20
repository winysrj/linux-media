Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49124 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932357AbcLTOB1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Dec 2016 09:01:27 -0500
Date: Tue, 20 Dec 2016 16:01:19 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161220140119.GE16630@valkosipuli.retiisi.org.uk>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161214130310.GA15405@pali>
 <20161214201202.GB28424@amd>
 <20161218220105.GS16630@valkosipuli.retiisi.org.uk>
 <20161220123756.GA23035@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161220123756.GA23035@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Tue, Dec 20, 2016 at 01:37:56PM +0100, Pavel Machek wrote:
> Hi!
> 
> > I think WARN() is good. It's a driver bug and it deserves to be notified.
> ...
> > I guess it's been like this since 2008 or so. I guess the comment could be
> > simply removed, it's not a real problem.
> ...
> > AFAIR the module is called Stingray.
> 
> Ok, so it seems we are pretty good? Can you take the patch now? Device

Did you see this:

<URL:http://www.spinics.net/lists/linux-media/msg109426.html>

> tree documentation is in
> 
> Subject: [PATCH v6] media: et8ek8: add device tree binding documentation
> 
> and we have
> 
> Acked-by: Rob Herring <robh@kernel.org>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
