Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57760 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754803AbbDHWIy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2015 18:08:54 -0400
Date: Thu, 9 Apr 2015 01:08:21 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	s.nawrocki@samsung.com
Subject: Re: [PATCH v3 2/4] v4l: of: Instead of zeroing bus_type and bus
 field separately, unify this
Message-ID: <20150408220821.GX20756@valkosipuli.retiisi.org.uk>
References: <1428361053-20411-1-git-send-email-sakari.ailus@iki.fi>
 <1428361053-20411-3-git-send-email-sakari.ailus@iki.fi>
 <14728842.HyHhcxnctu@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14728842.HyHhcxnctu@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 07, 2015 at 12:47:56PM +0300, Laurent Pinchart wrote:
> Hello Sakari,
> 
> Thank you for the patch.
> 
> On Tuesday 07 April 2015 01:57:30 Sakari Ailus wrote:
> > Clean the entire struct starting from bus_type. As more fields are added, no
> > changes will be needed in the function to reset their value explicitly.
> 
> I would s/Clean/Clear/ or s/Clean/Zero/. Same for the comment in the code. 
> Apart from that,

I'll use zero. It's clearer. :-)

> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
