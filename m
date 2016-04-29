Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41952 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752269AbcD2LXi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 07:23:38 -0400
Date: Fri, 29 Apr 2016 14:23:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Hans Verkuil <hverkuil@xs4all.nl>,
	sre@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
	patrikbachan@gmail.com, serge@hallyn.com, tuukkat76@gmail.com,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org
Subject: Re: v4l subdevs without big device was Re:
 drivers/media/i2c/adp1653.c: does not show as /dev/video* or v4l-subdev*
Message-ID: <20160429112304.GJ32125@valkosipuli.retiisi.org.uk>
References: <20160428084546.GA9957@amd>
 <20160429071525.GA4823@amd>
 <57230DE7.3020701@xs4all.nl>
 <20160429075649.GG32125@valkosipuli.retiisi.org.uk>
 <20160429095002.GA22743@amd>
 <20160429105944.GH32125@valkosipuli.retiisi.org.uk>
 <20160429110546.GU12528@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160429110546.GU12528@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 29, 2016 at 01:05:46PM +0200, Pali Rohár wrote:
> On Friday 29 April 2016 13:59:44 Sakari Ailus wrote:
> > > pavel@amd:/data/l/linux-n900$ git fetch
> > > git://git.retiisi.org.uk/~sailus/linux.git leds-as3645a:leds-as3645a
> > > fatal: unable to connect to git.retiisi.org.uk:
> > > git.retiisi.org.uk: Name or service not known
> > > 
> > > pavel@amd:/data/l/linux-n900$ git fetch
> > > git://salottisipuli.retiisi.org.uk/~sailus/linux.git
> > > leds-as3645a:leds-as3645a
> > > remote: Counting objects: 132, done.
> > > remote: Compressing objects: 100% (46/46), done.
> > > remote: Total 132 (delta 111), reused 107 (delta 86)
> > > Receiving objects: 100% (132/132), 22.80 KiB | 0 bytes/s, done.
> > > Resolving deltas: 100% (111/111), completed with 34 local objects.
> > > From git://salottisipuli.retiisi.org.uk/~sailus/linux
> > >  * [new branch]      leds-as3645a -> leds-as3645a
> > 
> > Yeah, that works, too. git alias has been added some three weeks ago so
> > there seem to be something strange going on with DNS.
> 
> Maybe update SOA record?

The host has been added before that. It looks like the slaves are performing
the zone transfer nicely but for some reason they don't seem to correctly
respond when the newly added name is queried.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
