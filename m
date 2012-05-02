Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53943 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752745Ab2EBVjT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 May 2012 17:39:19 -0400
Date: Thu, 3 May 2012 00:39:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	mchehab@redhat.com, remi@remlab.net, nbowler@elliptictech.com,
	james.dutton@gmail.com
Subject: Re: [RFC v3 1/2] v4l: Do not use enums in IOCTL structs
Message-ID: <20120502213915.GG852@valkosipuli.localdomain>
References: <20120502191324.GE852@valkosipuli.localdomain>
 <1335986028-23618-1-git-send-email-sakari.ailus@iki.fi>
 <201205022245.22585.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205022245.22585.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, May 02, 2012 at 10:45:22PM +0200, Hans Verkuil wrote:
> On Wed May 2 2012 21:13:47 Sakari Ailus wrote:
> > Replace enums in IOCTL structs by __u32. The size of enums is variable and
> > thus problematic. Compatibility structs having exactly the same as original
> > definition are provided for compatibility with old binaries with the
> > required conversion code.
> 
> Does someone actually have hard proof that there really is a problem? You know,
> demonstrate it with actual example code?
> 
> It's pretty horrible that you have to do all those conversions and that code
> will be with us for years to come.
> 
> For most (if not all!) architectures sizeof(enum) == sizeof(u32), so there is
> no need for any compat code for those.

Cases I know where this can go wrong are, but there may well be others:

- ppc64: int is 64 bits there, and thus also enums,

- Enums are quite a different concept in C++ than in C --- the compiler may
  make assumpton based on the value range of the enums --- videodev2.h should
  be included with extern "C" in that case, though,

- C does not specify which integer type enums actually use; this is what GCC
  manual says about it:

  <URL:http://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html#Enumerations>

  So a compiler other than GCC should use 16-bit enums and conform to C
  while breaking V4L2. This might be a theoretical issue, though.

More discussion took place in this thread:

<URL:http://www.spinics.net/lists/linux-media/msg46167.html>

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
