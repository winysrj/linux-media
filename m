Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:40890 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab1IMMAl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 08:00:41 -0400
Date: Tue, 13 Sep 2011 15:00:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Subash Patel <subashrp@gmail.com>, linux-media@vger.kernel.org,
	s.nawrocki@samsung.com, hechtb@googlemail.com,
	g.liakhovetski@gmx.de
Subject: Re: [RFC] New class for low level sensors controls?
Message-ID: <20110913120036.GD1845@valkosipuli.localdomain>
References: <20110906113653.GF1393@valkosipuli.localdomain>
 <4E68A5E7.8070800@gmail.com>
 <20110908114428.GC1724@valkosipuli.localdomain>
 <201109131233.59003.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109131233.59003.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 13, 2011 at 12:33:58PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Thursday 08 September 2011 13:44:28 Sakari Ailus wrote:
> > On Thu, Sep 08, 2011 at 04:54:23PM +0530, Subash Patel wrote:
> > > On 09/06/2011 05:52 PM, Sakari Ailus wrote:
> > > > On Tue, Sep 06, 2011 at 01:41:11PM +0200, Laurent Pinchart wrote:
> > > > >
> > > > > Other controls often found in bayer sensors are black level
> > > > > compensation and test pattern.
> > > 
> > > Does all BAYER sensor allow the dark level compensation programming?
> > 
> > I'm not sure. I have always seen ISPs being used for that, not sensors.
> > 
> > > I thought it must be auto dark level compensation, which is done by
> > > the sensor. The sensor detects the optical black value at start of
> > > each frame, and analog-to-digital conversion is shifted to
> > > compensate the dark level for that frame. Hence I am thinking if
> > > this should be a controllable feature.
> > 
> > This is probably what smart sensors could do. If we have a raw bayer sensor
> > the computation of the optimal black level compensation could be done by
> > some of the controls algorithms run in the user space. Automatic exposure
> > probably?
> 
> Many "non-smart" raw bayer sensors implement both manual and automatic black 
> level compensation. In the first case the user programs a value to be 
> subtracted from the pixels (whether that's done in the analog or digital 
> domain might be sensor-specific), and in the second case the sensor computes a 
> mean black level value based on black lines (optically unexposed) at the top 
> of the image.

Sounds like two controls to me, right?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
