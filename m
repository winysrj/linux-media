Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:51152 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbcGAPep (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 11:34:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] cec: add missing inline stubs
Date: Fri, 01 Jul 2016 17:37:17 +0200
Message-ID: <6460555.uRUCQj0uFx@wuerfel>
In-Reply-To: <975908ec-c95c-170d-e7b7-31a810ad82ba@xs4all.nl>
References: <20160701112027.102024-1-arnd@arndb.de> <6419506.V8JtZUoqT3@wuerfel> <975908ec-c95c-170d-e7b7-31a810ad82ba@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, July 1, 2016 5:22:32 PM CEST Hans Verkuil wrote:
> > diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
> > index 8e6918c5c87c..8e31146d079a 100644
> > --- a/drivers/media/platform/vivid/Kconfig
> > +++ b/drivers/media/platform/vivid/Kconfig
> > @@ -26,6 +26,7 @@ config VIDEO_VIVID
> >  config VIDEO_VIVID_CEC
> >       bool "Enable CEC emulation support"
> >       depends on VIDEO_VIVID && MEDIA_CEC
> > +     depends on VIDEO_VIVID=m || MEDIA_CEC=y
> >       ---help---
> >         When selected the vivid module will emulate the optional
> >         HDMI CEC feature.
> > 
> > which is still not overly nice, but it manages to avoid the
> > IS_REACHABLE() check and it lets MEDIA_CEC be a module.
> 
> The only IS_REACHABLE is for the RC_CORE check, and that should remain.

I believe that is already taken care of by my earlier "[media] cec: add
RC_CORE dependency" patch, https://patchwork.linuxtv.org/patch/34892/
which seems to handle the dependency more gracefully (preventing nonsense
configurations rather than just not using RC_CORE).

> With my patch MEDIA_CEC can remain a module provided MEDIA_SUPPORT is also
> a module. All drivers depending on MEDIA_CEC also depend on MEDIA_SUPPORT,
> so that works.

To clarify, the problem with the option above is that VIDEO_VIVID_CEC
is a 'bool' option, and Kconfig lets that be turned on if both
VIDEO_VIVID and MEDIA_CEC are enabled, including the case where MEDIA_CEC
is a module and VIDEO_VIVID is not.

Your patch avoids that problem by making MEDIA_CEC a 'bool', my patch
above is an alternative by ensuring that VIDEO_VIVID_CEC cannot be
enabled if MEDIA_CEC is a module and VIDEO_VIVID is not.

	Arnd
