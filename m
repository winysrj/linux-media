Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38800 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933674Ab3JOVmW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 17:42:22 -0400
Date: Wed, 16 Oct 2013 00:41:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, sylwester.nawrocki@gmail.com,
	a.hajda@samsung.com
Subject: Re: [PATCH v2.1 1/4] media: Add pad flag MEDIA_PAD_FL_MUST_CONNECT
Message-ID: <20131015214146.GD7584@valkosipuli.retiisi.org.uk>
References: <524DEC22.5090107@gmail.com>
 <1381661924-26365-1-git-send-email-sakari.ailus@iki.fi>
 <20131013110313.GC7584@valkosipuli.retiisi.org.uk>
 <3422963.Ua6Z8kTtzN@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3422963.Ua6Z8kTtzN@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 15, 2013 at 05:22:50PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Sunday 13 October 2013 14:03:13 Sakari Ailus wrote:
> > On Sun, Oct 13, 2013 at 01:58:43PM +0300, Sakari Ailus wrote:
> > > Pads that set this flag must be connected by an active link for the entity
> > > to stream.
> > 
> > Oh --- btw. what has changed since v2:
> > 
> > - Rmoved the last sentence of MEDIA_PAD_FL_MUST_CONNECT documentation. The
> >   sentence was about the flag having no effect on pads w/o links.
> 
> That change is part of 2/4. I believe that's a mistake.

Indeed. I'll resend in a moment.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
