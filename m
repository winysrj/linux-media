Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35044 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S938928AbcHJTHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 15:07:17 -0400
Date: Wed, 10 Aug 2016 15:00:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: [PATCHv6] support for AD5820 camera auto-focus coil
Message-ID: <20160810120032.GO3182@valkosipuli.retiisi.org.uk>
References: <573FFF51.1000004@gmail.com>
 <20160521105607.GA20071@amd>
 <574049EF.2090208@gmail.com>
 <20160524090433.GA1277@amd>
 <20160524091746.GA14536@amd>
 <20160525212659.GK26360@valkosipuli.retiisi.org.uk>
 <20160527205140.GA26767@amd>
 <20160805102611.GA13116@amd>
 <20160808080955.GA3182@valkosipuli.retiisi.org.uk>
 <20160810073403.GB30047@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160810073403.GB30047@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 10, 2016 at 09:34:03AM +0200, Pali Rohár wrote:
> On Monday 08 August 2016 11:09:56 Sakari Ailus wrote:
> > On Fri, Aug 05, 2016 at 12:26:11PM +0200, Pavel Machek wrote:
> > > 
> > > This adds support for AD5820 autofocus coil, found for example in
> > > Nokia N900 smartphone.
> > 
> > Thanks, Pavel!
> > 
> > Let's use V4L2_CID_FOCUS_ABSOLUTE, as is in the patch. If we get something
> > better in the future, we'll switch to that then.
> 
> Ok, and what with AD5820_RAMP_TIME and AD5820_RAMP_MODE?
> 
> > I've applied this to ad5820 branch in my tree.
> 
> Are you going to finally send this patch to media tree or pull request
> to Linus?

That'll be through media-tree.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
