Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:46078 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab2CFPul (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 10:50:41 -0500
Date: Tue, 6 Mar 2012 17:50:36 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com
Subject: Re: [PATCH v4 04/34] v4l: VIDIOC_SUBDEV_S_SELECTION and
 VIDIOC_SUBDEV_G_SELECTION IOCTLs
Message-ID: <20120306155036.GJ1075@valkosipuli.localdomain>
References: <20120302173219.GA15695@valkosipuli.localdomain>
 <1330709442-16654-4-git-send-email-sakari.ailus@iki.fi>
 <12441257.HgrTH0oxIp@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12441257.HgrTH0oxIp@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 05, 2012 at 11:59:22AM +0100, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the patch.
> 
> On Friday 02 March 2012 19:30:12 Sakari Ailus wrote:
> > Add support for VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION
> > IOCTLs. They replace functionality provided by VIDIOC_SUBDEV_S_CROP and
> > VIDIOC_SUBDEV_G_CROP IOCTLs and also add new functionality (composing).
> > 
> > VIDIOC_SUBDEV_G_CROP and VIDIOC_SUBDEV_S_CROP continue to be supported.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Except for the ACTIVE name, 
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Maybe we could discuss this on IRC with Tomasz ?

Tomasz wasn't online when I checked.

How about "CURRENT"?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
