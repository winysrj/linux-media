Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41631 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbaCFArB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 19:47:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Paul Bolle <pebolle@tiscali.nl>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
Date: Thu, 06 Mar 2014 01:48:29 +0100
Message-ID: <2136780.FIdBGb725A@avalon>
In-Reply-To: <1394065683.12070.32.camel@joe-AO722>
References: <1391958577.25424.22.camel@x220> <3099833.ZhlQFyxhbo@avalon> <1394065683.12070.32.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Joe,

On Wednesday 05 March 2014 16:28:03 Joe Perches wrote:
> On Thu, 2014-03-06 at 00:50 +0100, Laurent Pinchart wrote:
> > Please note that -DDEBUG is equivalent to '#define DEBUG', not to '#define
> > CONFIG_DEBUG'. 'DEBUG' needs to be defined for dev_dbg() to have any
> > effect.
>
> Not quite.  If CONFIG_DYNAMIC_DEBUG is set, these
> dev_dbg statements are compiled in but not by default
> set to emit output.  Output can be enabled by using
> dynamic_debug controls like:
> 
> # echo -n 'file omap4iss/* +p' > <debugfs>/dynamic_debug/control
> 
> See Documentation/dynamic-debug-howto.txt for more details.

Thank you for the additional information.

Would you recommend to drop driver-specific Kconfig options related to 
debugging and use CONFIG_DYNAMIC_DEBUG instead ?

-- 
Regards,

Laurent Pinchart

