Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56647 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbZCDIdS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Mar 2009 03:33:18 -0500
Message-ID: <49AE3E2F.70905@redhat.com>
Date: Wed, 04 Mar 2009 09:39:11 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Kyle Guinn <elyk03@gmail.com>
CC: kilgota@banach.math.auburn.edu,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
References: <20090217200928.1ae74819@free.fr> <200902171907.40054.elyk03@gmail.com> <alpine.LNX.2.00.0903031746030.21483@banach.math.auburn.edu> <200903032050.13915.elyk03@gmail.com>
In-Reply-To: <200903032050.13915.elyk03@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Kyle Guinn wrote:
> On Tuesday 03 March 2009 18:12:33 kilgota@banach.math.auburn.edu wrote:

<snip>

> Just a random thought, but maybe the pac207 driver can benefit from such a 
> change as well?

It could, but it is to late for that, the pac207 driver and corresponding libv4l
functionality has been out there for 2 kernel releases now, so we cannot change that.

Which also makes me wonder about the same change for the mr97310a, is that cam already
supported in a released kernel ?

If not we MUST make sure we get this change in before 2.6.29 final, if it is I'm afraid
we cannot make these changes. In that case if we ever need to header data we need to
define a new PIXFMT for mr97310a with the header data, and deprecate the old one.

Regards,

Hans
