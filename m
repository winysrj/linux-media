Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41043 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751355Ab2FQHyh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jun 2012 03:54:37 -0400
Date: Sun, 17 Jun 2012 10:54:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR 3.6] V4L2 API cleanups
Message-ID: <20120617075432.GL12505@valkosipuli.retiisi.org.uk>
References: <4FD50223.4030501@iki.fi>
 <6836133.PoLuVdfeXV@avalon>
 <20120611093944.GF12505@valkosipuli.retiisi.org.uk>
 <5239489.ghNmaKI2zP@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5239489.ghNmaKI2zP@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 17, 2012 at 12:03:06AM +0200, Laurent Pinchart wrote:
> Hi Sakari,

Hi Laurent,

> On Monday 11 June 2012 12:39:44 Sakari Ailus wrote:
> > On Mon, Jun 11, 2012 at 09:50:54AM +0200, Laurent Pinchart wrote:
> > > On Sunday 10 June 2012 23:22:59 Sakari Ailus wrote:
> > > > Hi Mauro,
> > > > 
> > > > Here are two V4L2 API cleanup patches; the first removes __user from
> > > > videodev2.h from a few places, making it possible to use the header file
> > > > as such in user space, while the second one changes the
> > > > v4l2_buffer.input field back to reserved.
> > > > 
> > > > The following changes since commit 
> 5472d3f17845c4398c6a510b46855820920c2181:
> > > >   [media] mt9m032: Implement V4L2_CID_PIXEL_RATE control (2012-05-24
> > > > 
> > > > 09:27:24 -0300)
> > > > 
> > > > are available in the git repository at:
> > > >   ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.6
> > > > 
> > > > Sakari Ailus (2):
> > > >       v4l: Remove __user from interface structure definitions
> > > 
> > > NAK, sorry.
> > > 
> > > __user has a purpose, we need to add it where it's missing, not remove it
> > > where it's rightfully present.
> > 
> > It's not quite as simple as adding __user everywhere it might belong to ---
> > these structs are being used in kernel space, too. The structs that are part
> > of the user space interface may at some point contain pointers to memory
> > which is in user space. That is being dealt by video_usercopy(), so the
> > individual drivers or the rest of the V4L2 framework always gets pointers
> > pointing to kernel memory.
> 
> Very good point, I haven't thought about that. I'm not sure how to deal with 
> this, splitting structures in a __user and a non __user version isn't really a 
> good option. Maybe the sparse tool should be somehow extended ?

Wouldn't type casting in video_usercopy() just do the job? Albeit I'm far
from certain it'd make the code better, just make the sparse warnings go
away...

regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
