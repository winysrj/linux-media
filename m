Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:35048 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761194Ab2DKUc2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Apr 2012 16:32:28 -0400
From: "=?utf-8?q?R=C3=A9mi?= Denis-Courmont" <remi@remlab.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] [PATCH] v4l2: use unsigned rather than enums in ioctl() structs
Date: Wed, 11 Apr 2012 23:32:21 +0300
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1333648371-24812-1-git-send-email-remi@remlab.net> <201204112147.55348.remi@remlab.net> <4F85E133.4030404@redhat.com>
In-Reply-To: <4F85E133.4030404@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204112332.24353.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mercredi 11 avril 2012 22:53:23 Mauro Carvalho Chehab, vous avez écrit :
> > But you have been royally ignoring that rule when it
> > comes to extending existing enumerations:
> The existing enumerations can be extended, by adding new values for unused
> values, otherwise API functionality can't be extended.

Yes. That's why they should be some unsigned type.

> Yet, except
> for a gcc bug (or weird optimize option), I fail to see why this would
> break the ABI.

>From the perspective of the compiler, this is a feature not a bug. In C and 
C++, loading or storing a value in an enumerated variable whereby the value is 
not a member of the enumeration is undefined. In other words, the compiler can 
assume that this does not happen, and optimize it away.

> If this is all about some gcc optimization with newer gcc versions, then
> maybe the solution may be to add some pragmas at the code to disable such
> optimization when compiling the structs with enum's at videodev2.h.

Maybe the Linux kernel could be specifically compiled to prevent GCC from 
range-optimizing enumerations. But as -fno-jump-table only disables one of 
several potential range optimizations, I doubt this is even possible.

Regardless, you cannot require all of Linux userspace to rely on an hypothetic 
non-standard GNU C extension. Thus extending enums remains a silent userspace 
ABI break in any case.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
