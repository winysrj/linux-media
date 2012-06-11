Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:44172 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab2FKIWA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 04:22:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/1] v4l: Remove __user from interface structure definitions
Date: Mon, 11 Jun 2012 10:21:49 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <1338062869-23922-1-git-send-email-sakari.ailus@iki.fi> <2510696.MjJJuAAVnT@avalon> <20120611081211.GE12505@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120611081211.GE12505@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206111021.49337.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 11 June 2012 10:12:11 Sakari Ailus wrote:
> On Mon, Jun 11, 2012 at 09:49:25AM +0200, Laurent Pinchart wrote:
> > Hi Sakari,
> 
> Hi Laurent,
> 
> > On Saturday 26 May 2012 23:07:49 Sakari Ailus wrote:
> > > The __user macro is not strictly needed in videodev2.h, and it also prevents
> > > using the header file as such in the user space. __user is already not used
> > > in many of the interface structs containing pointers.
> > > 
> > > Stop using __user in videodev2.h.
> > 
> > Please don't. __user is useful. You should not use kernel headers as-is in 
> > userspace, they need to be installed use make headers_install first.
> 
> Then we should consistently use it, and not just in these two occasions.
> Currently most structures having pointers and which are part of the user
> space interface don't have that. One example is v4l2_ext_controls.

Yes, that should be fixed. All pointers in structs whose contents is going
to be copied to/from kernelspace need a __user annotation.

The sparse checker checks for that. I'm running it in my daily build, but
nobody ever pays any attention to it :-)

There are too many error/warnings reported for it to be any use.

Regards,

	Hans
