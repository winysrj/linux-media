Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0186.hostedemail.com ([216.40.44.186]:58945 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750794AbaCFQsF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Mar 2014 11:48:05 -0500
Message-ID: <1394124479.12070.62.camel@joe-AO722>
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
From: Joe Perches <joe@perches.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Paul Bolle <pebolle@tiscali.nl>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Date: Thu, 06 Mar 2014 08:47:59 -0800
In-Reply-To: <2183657.tkSdBlXoCc@avalon>
References: <1391958577.25424.22.camel@x220> <18589524.VtEDRg43uX@avalon>
	 <1394076347.12070.41.camel@joe-AO722> <2183657.tkSdBlXoCc@avalon>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2014-03-06 at 11:55 +0100, Laurent Pinchart wrote:
> We thus need the #define DEBUG it appear before the first time device.h is 
> included, either directly or indirectly. Adding #define DEBUG to iss.h won't 
> work now as iss.h is included after all system includes (which is the usual 
> practice, #include <...> come before #include "...").

Ahh, right, good point.
I'd forgotten about that include order dependency.

cheers, Joe

