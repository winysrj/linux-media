Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0038.hostedemail.com ([216.40.44.38]:46088 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757232AbaCFBfp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Mar 2014 20:35:45 -0500
Message-ID: <1394069742.12070.39.camel@joe-AO722>
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
From: Joe Perches <joe@perches.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Paul Bolle <pebolle@tiscali.nl>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Date: Wed, 05 Mar 2014 17:35:42 -0800
In-Reply-To: <3032500.9J1uSX3lel@avalon>
References: <1391958577.25424.22.camel@x220> <2136780.FIdBGb725A@avalon>
	 <1394067637.12070.36.camel@joe-AO722> <3032500.9J1uSX3lel@avalon>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2014-03-06 at 02:27 +0100, Laurent Pinchart wrote:
> On Wednesday 05 March 2014 17:00:37 Joe Perches wrote:
> > On Thu, 2014-03-06 at 01:48 +0100, Laurent Pinchart wrote:
> > > Would you recommend to drop driver-specific Kconfig options related to
> > > debugging and use CONFIG_DYNAMIC_DEBUG instead ?
> > For development, sure, if there's sufficient memory.
> > For embedded systems with limited memory, using dynamic_debug isn't always
> > possible or effective.
> > Also, there are sometimes reasons to have debugging messages always enabled
> > or emitted.
> > For those cases, either adding #define DEBUG or using printk(KERN_DEBUG
> > would be fine.
> My goal here is to offer an easy way for users to enable debugging without 
> requiring changes to the source code.

Dynamic debugging works, but various distributions don't
have it enabled.

> The driver includes various dev_dbg() 
> messages, I don't want to ask people reporting problems to turn them into 
> printk() calls :-) Even adding #define DEBUG at the beginning of the source 
> files is likely too error prone for users without much programming experience.

I think your best bet is to add #define DEBUG to a common
header file like iss.h or omap4iss.h




