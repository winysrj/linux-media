Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59168 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab1IMNMS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 09:12:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC] New class for low level sensors controls?
Date: Tue, 13 Sep 2011 15:12:16 +0200
Cc: Subash Patel <subashrp@gmail.com>, linux-media@vger.kernel.org,
	s.nawrocki@samsung.com, hechtb@googlemail.com,
	g.liakhovetski@gmx.de
References: <20110906113653.GF1393@valkosipuli.localdomain> <201109131233.59003.laurent.pinchart@ideasonboard.com> <20110913120036.GD1845@valkosipuli.localdomain>
In-Reply-To: <20110913120036.GD1845@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109131512.16667.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 13 September 2011 14:00:36 Sakari Ailus wrote:
> On Tue, Sep 13, 2011 at 12:33:58PM +0200, Laurent Pinchart wrote:
> > On Thursday 08 September 2011 13:44:28 Sakari Ailus wrote:
> > > On Thu, Sep 08, 2011 at 04:54:23PM +0530, Subash Patel wrote:
> > > > On 09/06/2011 05:52 PM, Sakari Ailus wrote:
> > > > > On Tue, Sep 06, 2011 at 01:41:11PM +0200, Laurent Pinchart wrote:
> > > > > > Other controls often found in bayer sensors are black level
> > > > > > compensation and test pattern.
> > > > 
> > > > Does all BAYER sensor allow the dark level compensation programming?
> > > 
> > > I'm not sure. I have always seen ISPs being used for that, not sensors.
> > > 
> > > > I thought it must be auto dark level compensation, which is done by
> > > > the sensor. The sensor detects the optical black value at start of
> > > > each frame, and analog-to-digital conversion is shifted to
> > > > compensate the dark level for that frame. Hence I am thinking if
> > > > this should be a controllable feature.
> > > 
> > > This is probably what smart sensors could do. If we have a raw bayer
> > > sensor the computation of the optimal black level compensation could
> > > be done by some of the controls algorithms run in the user space.
> > > Automatic exposure probably?
> > 
> > Many "non-smart" raw bayer sensors implement both manual and automatic
> > black level compensation. In the first case the user programs a value to
> > be subtracted from the pixels (whether that's done in the analog or
> > digital domain might be sensor-specific), and in the second case the
> > sensor computes a mean black level value based on black lines (optically
> > unexposed) at the top of the image.
> 
> Sounds like two controls to me, right?

At least two, an auto control and a manual value control. Additional controls 
(such as the number of lines on which to compute the black level average 
automatically for instance, or a read-only control to report the computed 
average) will probably be added later.

-- 
Regards,

Laurent Pinchart
