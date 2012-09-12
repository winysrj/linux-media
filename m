Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab2ILLLK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 07:11:10 -0400
Message-ID: <50506DCB.6040101@redhat.com>
Date: Wed, 12 Sep 2012 08:11:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: Kconfig DVB_CAPTURE_DRIVERS no longer exists?
References: <201209120901.14575.hverkuil@xs4all.nl>
In-Reply-To: <201209120901.14575.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 12-09-2012 04:01, Hans Verkuil escreveu:
> Hi Mauro,
> 
> Two drivers, au0828 and cx2341xx depend on the DVB_CAPTURE_DRIVERS config
> option, which no longer exists. So au0828 and the DVB part of cx231xx are
> no longer built. Should this dependency be removed or was it renamed?

Thanks for reporting it!

Those dependencies got somewhat renamed, somewhat removed ;)
Truly, the logic was simplified.

At the usb menu, checking for MEDIA_DIGITAL_TV_SUPPORT is now enough.
For hybrid drivers, like the two above, a "depends on DVB_CORE" is enough.

So, we can simply drop the dependency for DVB_CAPTURE_DRIVERS, as both
already depends on DVB_CORE (and MEDIA_DIGITAL_TV_SUPPORT is a boolean).

> Can you take a look at it?

Ok, I'll write a patch fixing it.

Thanks for reporting it.

Regards,
Mauro
