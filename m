Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0098.hostedemail.com ([216.40.44.98]:36967 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752675AbaCFAfu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Mar 2014 19:35:50 -0500
Received: from smtprelay.hostedemail.com (ff-bigip1 [10.5.19.254])
	by smtpgrave06.hostedemail.com (Postfix) with ESMTP id 17F4C17302E
	for <linux-media@vger.kernel.org>; Thu,  6 Mar 2014 00:28:17 +0000 (UTC)
Message-ID: <1394065683.12070.32.camel@joe-AO722>
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
From: Joe Perches <joe@perches.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Paul Bolle <pebolle@tiscali.nl>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Date: Wed, 05 Mar 2014 16:28:03 -0800
In-Reply-To: <3099833.ZhlQFyxhbo@avalon>
References: <1391958577.25424.22.camel@x220> <1600194.93iSF4Yz3E@avalon>
	 <20140305171006.6243354a@samsung.com> <3099833.ZhlQFyxhbo@avalon>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2014-03-06 at 00:50 +0100, Laurent Pinchart wrote:

> Please note that -DDEBUG is equivalent to '#define DEBUG', not to '#define 
> CONFIG_DEBUG'. 'DEBUG' needs to be defined for dev_dbg() to have any effect. 

Not quite.  If CONFIG_DYNAMIC_DEBUG is set, these
dev_dbg statements are compiled in but not by default
set to emit output.  Output can be enabled by using
dynamic_debug controls like:

# echo -n 'file omap4iss/* +p' > <debugfs>/dynamic_debug/control

See Documentation/dynamic-debug-howto.txt for more details.


