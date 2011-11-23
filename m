Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:41436 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754767Ab1KWToQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 14:44:16 -0500
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 4/4] ivtv: implement new decoder command ioctls.
Date: Wed, 23 Nov 2011 20:44:14 +0100
Cc: linux-media@vger.kernel.org
References: <201111231254.18805.martin.dauskardt@gmx.de> <201111231314.42496.hverkuil@xs4all.nl>
In-Reply-To: <201111231314.42496.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111232044.14863.martin.dauskardt@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > I suggest to increase the ivtv driver version number when implementing
> > the  changes. The application (which must be backward compatible) should
> > be able to determine which ioctl it has to use.
> 
> These days the version number of all drivers is the same as the kernel
> version number, so it is easy to check when new ioctls became available.

Does this mean that the ivtv driver version is also 3.3 when somebody uses an 
older kernel with updated drivers from media_build?

I am worried that this might be the case if somebody checks out from the 
staging/for_v3.3 Branch **before** the patch is merged.
 
>  
> 
> > It would be much better if the ivtv driver would continue to support the
> > old  ioctl for the few years we still have any PVR350 user.
> 
> Don't worry, I won't be removing anything.

good :-)

> 
> I checked the plugin code and you aren't using VIDEO_GET_EVENT. The
> VIDEO_GET_EVENT ioctl is the only one I'd really like to get rid of in
> ivtv in favor of the V4L2 event API. It's only used as far as I can tell
> in ivtv-ctl and ivtvplay, both ivtv utilities that can easily be changed.
> 
> Are you perhaps aware of any other userspace applications that use that
> ioctl?

no. I think mythtv used it, but I doubt that the dropped support for the 
decoder will come back anytime. 
