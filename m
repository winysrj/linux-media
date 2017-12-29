Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56156 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750929AbdL2Ji7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 04:38:59 -0500
Date: Fri, 29 Dec 2017 11:38:55 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>, pali.rohar@gmail.com,
        sre@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        clayton@craftyguy.net, martijn@brixit.nl,
        Filip =?utf-8?Q?Matijevi=C4=87?= <filip.matijevic.pz@gmail.com>,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: Re: v4.15: camera problems on n900
Message-ID: <20171229093855.hz44vpssb5mufzop@valkosipuli.retiisi.org.uk>
References: <20171227210543.GA19719@amd>
 <20171227211718.favif66afztygfje@kekkonen.localdomain>
 <20171228202453.GA20142@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171228202453.GA20142@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 28, 2017 at 09:24:53PM +0100, Pavel Machek wrote:
> On Wed 2017-12-27 23:17:19, Sakari Ailus wrote:
> > On Wed, Dec 27, 2017 at 10:05:43PM +0100, Pavel Machek wrote:
> > > Hi!
> > > 
> > > In v4.14, back camera on N900 works. On v4.15-rc1.. it works for few
> > > seconds, but then I get repeated oopses.
> > > 
> > > On v4.15-rc0.5 (commit ed30b147e1f6e396e70a52dbb6c7d66befedd786),
> > > camera does not start.	  
> > > 
> > > Any ideas what might be wrong there?
> > 
> > What kind of oopses do you get?
> 
> Hmm. bisect pointed to commit that can't be responsible.... Ideas
> welcome.

Hi Pavel,

I tested N9 and capture appears to be working from the CSI-2 receiver
(media tree master, i.e. v4.15-rc3 now).

Which pipeline did you use?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
