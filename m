Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42530 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751201AbbLUMpf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 07:45:35 -0500
Date: Mon, 21 Dec 2015 14:45:32 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Subject: Re: [v4l-utils PATCH 1/1] Allow building static binaries
Message-ID: <20151221124532.GT17128@valkosipuli.retiisi.org.uk>
References: <1449587901-12784-1-git-send-email-sakari.ailus@linux.intel.com>
 <20151210132124.GK17128@valkosipuli.retiisi.org.uk>
 <5671C7BC.9090002@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5671C7BC.9090002@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

On Wed, Dec 16, 2015 at 09:21:16PM +0100, Gregor Jasny wrote:
> Hello,
> 
> On 10/12/15 14:21, Sakari Ailus wrote:
> > I discussed with Hans and he thought you'd be the best person to take a look
> > at this.
> > 
> > The case is that I'd like to build static binaries and that doesn't seem to
> > work with what's in Makefile.am for libv4l1 and libv4l2 at the moment.
> 
> Sorry for the late reply. Didi not notice this email earlier. Your patch
> does not do what you'd like to achieve. Both v4l1compat and v4l2convert
> are libraries which only purpose is to get preloaded by the loader. So
> build them statically does not make sense. Instead they should not be
> built at all. To achieve this the WITH_V4L_WRAPPERS variable should
> evaluate to false. This is triggered by
> 
> AM_CONDITIONAL([WITH_V4L_WRAPPERS], [test x$enable_libv4l != xno -a
> x$enable_shared != xno])
> 
> So changing
> 
> LDFLAGS="--static -static" ./configure --enable-static
> 
> to
> 
> LDFLAGS="--static -static" ./configure --enable-static --disabled-shared
> 
> should do the trick. Does this help?

It does. I get statically linked binaries now without changes. Thank you,
Gregor!

Hans, Mauro, please ignore the patch.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
