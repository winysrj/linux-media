Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38381 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750978Ab2FKIMQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 04:12:16 -0400
Date: Mon, 11 Jun 2012 11:12:11 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: Remove __user from interface structure
 definitions
Message-ID: <20120611081211.GE12505@valkosipuli.retiisi.org.uk>
References: <1338062869-23922-1-git-send-email-sakari.ailus@iki.fi>
 <2510696.MjJJuAAVnT@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2510696.MjJJuAAVnT@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 11, 2012 at 09:49:25AM +0200, Laurent Pinchart wrote:
> Hi Sakari,

Hi Laurent,

> On Saturday 26 May 2012 23:07:49 Sakari Ailus wrote:
> > The __user macro is not strictly needed in videodev2.h, and it also prevents
> > using the header file as such in the user space. __user is already not used
> > in many of the interface structs containing pointers.
> > 
> > Stop using __user in videodev2.h.
> 
> Please don't. __user is useful. You should not use kernel headers as-is in 
> userspace, they need to be installed use make headers_install first.

Then we should consistently use it, and not just in these two occasions.
Currently most structures having pointers and which are part of the user
space interface don't have that. One example is v4l2_ext_controls.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
