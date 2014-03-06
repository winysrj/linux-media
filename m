Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0196.hostedemail.com ([216.40.44.196]:51735 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752886AbaCFDZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Mar 2014 22:25:51 -0500
Message-ID: <1394076347.12070.41.camel@joe-AO722>
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
From: Joe Perches <joe@perches.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Paul Bolle <pebolle@tiscali.nl>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Date: Wed, 05 Mar 2014 19:25:47 -0800
In-Reply-To: <18589524.VtEDRg43uX@avalon>
References: <1391958577.25424.22.camel@x220> <3032500.9J1uSX3lel@avalon>
	 <1394069742.12070.39.camel@joe-AO722> <18589524.VtEDRg43uX@avalon>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2014-03-06 at 02:52 +0100, Laurent Pinchart wrote:

Hi again Laurent

> I've thought about that, but it would require iss.h to be included before all 
> other headers. I've also thought about creating an iss-debug.h header to be 
> included first just to #define DEBUG, but decided to go for handling the OMAP4 
> ISS debug option in the Makefile instead. If that's ugly and discouraged as 
> reported by Mauro I can try to come up with something else.

Unless debugging logging statements are in system level static inlines,
adding #define DEBUG to iss.h should otherwise produce the same output
as -DDEBUG in a Makefile.

