Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:19198 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab2AJLjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 06:39:12 -0500
From: Tuukka Toivonen <tuukka.toivonen@intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [ANN] Notes on IRC meeting on new sensor control interface, 2012-01-09 14:00 GMT+2
Date: Tue, 10 Jan 2012 13:39:10 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	tuukkat76@gmail.com, dacohen@gmail.com, g.liakhovetski@gmx.de,
	hverkuil@xs4all.nl, snjw23@gmail.com
References: <20120104085633.GM3677@valkosipuli.localdomain> <4F0C0A5A.9060708@iki.fi> <201201101105.49477.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201101105.49477.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Message-Id: <201201101339.11082.tuukka.toivonen@intel.com>
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 10 January 2012 12:05:48 Laurent Pinchart wrote:
> > > That was my question, how does the user decide whether hblank or vblank
> > > is preferred ?
> > 
> > I think that should be defined in the configuration itself. It's very
> > unlikely there's any need to change this dynamically.
> 
> Sure, but that's not my point. How does the user decide in the first place
> when writing the configuration ?

As Sakari finally told,
- More vertical blanking
  -> less rolling shutter effect (ie. less slanted image) and more time to do
      some processing between frames if wanted or needed
- More horizontal blanking -> smoother data rate, especially if there are
  buffers which can contain just couple of lines

I would say that generally vertical blanking is preferred unless there are
small buffers which allow required decrease in data rate for later stages in
image processing pipeline with larger horizontal blanking.

- Tuukka
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

