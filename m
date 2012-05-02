Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53880 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755726Ab2EBTNa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 May 2012 15:13:30 -0400
Date: Wed, 2 May 2012 22:13:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@redhat.com,
	remi@remlab.net, nbowler@elliptictech.com, james.dutton@gmail.com
Subject: [RFC v2 0/2] V4L2 IOCTL enum compat wrapper
Message-ID: <20120502191324.GE852@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is my first intended-to-be-complete RFC patch to get rid of the enums
in V4L2 IOCTL structs. The approach is the one outlined first by Mauro
(AFAIR):

<URL:http://www.spinics.net/lists/linux-media/msg46504.html>

A set of compat structs (and compat IOCTLs) are created and there are a few
functions to convert between the in-kernel representation and the old
representation with enums the user space may well be using. On many archs
the two IOCTLs are actually the same.

This patchset depends on my earlier patch to remove v4l2_buffer.input:

<URL:http://www.spinics.net/lists/linux-media/msg47144.html>

All three patches are also available here:

<URL:http://git.linuxtv.org/sailus/media_tree.git/shortlog/refs/heads/enum-fix>

Open questions:

- Orring the return values of {get,put}_user etc. is time-consuming on
  modern CPUs with deep pipelines. Would if be better to use | (logical or)
  instead? The regular case where the access is successful would be
  optimised on the expense of the error case. The end result in error cases
  may be different, too, but does that matter?

- Testing this patch completely is difficult. I've only got access to
  capture hardware on 32-bit systems which generally do not easily exhibit
  problems with enums in IOCTLs (since they're 32-bit ints) in first place.
  I've tested this by changing fields from __u32 to __u64 where the old code
  had enums; that works, so at least something is working correctly. Help in
  testing would be very much appreciated.

Questions and comments are welcome.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
