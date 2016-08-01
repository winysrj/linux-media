Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36655
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbcHALZc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2016 07:25:32 -0400
Date: Mon, 1 Aug 2016 08:25:27 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jani Nikula <jani.nikula@intel.com>,
	Markus Heiser <markus.heiser@darmarit.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: Functions and data structure cross references with Sphinx
Message-ID: <20160801082527.0eb7eace@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's one remaining major issue I noticed after the conversion of the
media books to Sphinx:

While sphinx complains if a cross-reference (using :ref:) points to an
undefined reference, the same doesn't happen if the reference uses
:c:func: and :c:type:.

In practice, it means that, if we do some typo there, or if we forget to
add the function/struct prototype (or use the wrong domain, like :cpp:),
Sphinx won't generate the proper cross-reference, nor warning the user.

That's specially bad for media, as, while we're using the c domain for
the kAPI and driver-specific books, we need to use the cpp domain on the 
uAPI book - as the c domain doesn't allow multiple declarations for
syscalls, and we have multiple pages for read, write, open, close, 
poll and ioctl.

It would be good to have a way to run Sphinx on some "pedantic"
mode or have something similar to xmlint that would be complaining
about invalid c/cpp domain references.

Thanks,
Mauro
