Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0159.hostedemail.com ([216.40.44.159]:39117 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754846AbaCFBAl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Mar 2014 20:00:41 -0500
Message-ID: <1394067637.12070.36.camel@joe-AO722>
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
From: Joe Perches <joe@perches.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Paul Bolle <pebolle@tiscali.nl>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Date: Wed, 05 Mar 2014 17:00:37 -0800
In-Reply-To: <2136780.FIdBGb725A@avalon>
References: <1391958577.25424.22.camel@x220> <3099833.ZhlQFyxhbo@avalon>
	 <1394065683.12070.32.camel@joe-AO722> <2136780.FIdBGb725A@avalon>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2014-03-06 at 01:48 +0100, Laurent Pinchart wrote:
> Would you recommend to drop driver-specific Kconfig options related to 
> debugging and use CONFIG_DYNAMIC_DEBUG instead ?

For development, sure, if there's sufficient memory.

For embedded systems with limited memory, using
dynamic_debug isn't always possible or effective.

Also, there are sometimes reasons to have debugging
messages always enabled or emitted.

For those cases, either adding #define DEBUG or using
printk(KERN_DEBUG would be fine.


