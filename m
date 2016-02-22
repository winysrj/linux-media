Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49138 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752429AbcBVTw7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 14:52:59 -0500
Date: Mon, 22 Feb 2016 21:52:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC 1/4] media: Sanitise the reserved fields of the G_TOPOLOGY
 IOCTL arguments
Message-ID: <20160222195222.GV32612@valkosipuli.retiisi.org.uk>
References: <1456090575-28354-1-git-send-email-sakari.ailus@linux.intel.com>
 <1456090575-28354-2-git-send-email-sakari.ailus@linux.intel.com>
 <20160222070047.2a7ee4e1@recife.lan>
 <20160222072321.382b235d@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160222072321.382b235d@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Feb 22, 2016 at 07:23:21AM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 22 Feb 2016 07:00:47 -0300
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
> 
> > Em Sun, 21 Feb 2016 23:36:12 +0200
> > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> > 
> > > From: Sakari Ailus <sakari.ailus@iki.fi>
> > > 
> > > Align them up to a power of two.  
> > 
> > Looks OK to me, but I would comment that the structs are aligned to
> > 2^n for those structs.
> 
> Hmm... on a second tought, I don't think this patch makes any sense.
> As those structs will be part of an array at media_v2_topology,
> this won't be aligned to a power of two, as we don't require that
> the number of links, entities, etc.. to be a aligned.

Well... that's a valid point indeed. Still I think the reserved fields do
need some changes, at least aligning the size to the common ABI alignment
(e.g. 8 bytes) rather than relying on the compiler to do it.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
