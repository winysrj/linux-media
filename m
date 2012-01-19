Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:51481 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab2ASTNI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 14:13:08 -0500
Date: Thu, 19 Jan 2012 21:13:05 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH 16/23] media: Add link_validate op to check links to
 the sink pad
Message-ID: <20120119191305.GI13236@valkosipuli.localdomain>
References: <4F0DFE92.80102@iki.fi>
 <201201161535.08191.laurent.pinchart@ideasonboard.com>
 <20120117200958.GE13236@valkosipuli.localdomain>
 <201201191720.56539.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201191720.56539.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Jan 19, 2012 at 05:20:55PM +0100, Laurent Pinchart wrote:
...
> > > Do we really need a generic link walking code for a single user ? Merging
> > > this in the function below would result in much simpler code.
> > 
> > It's a single funcition but it's being used from two locations in it.
> 
> Is it ? Not in this patch at least.

Hmm. Good point. I'll check if I can get rid of it and still keep it looking
nice.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
