Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37214 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752801Ab2KLWrA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 17:47:00 -0500
Date: Tue, 13 Nov 2012 00:46:55 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: dacohen@gmail.com
Subject: [PATCH 0/3] Remove V4L2 int device and drivers using it
Message-ID: <20121112224655.GP25623@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patchset removes V4L2 int device interface and the two drivers using
it: omap24xxcam and tcm825x. The status is that these drives do not work;
the last time I hacked on it I managed to get them to compile about a year
ago with a number of hacks. There was a hard crash without logs over the
serial port, after which I had no further time left to continue debugging.

Where I left off with is available here, in the n800-cam branch. That's not
pretty. Anyway, that's likely a better starting point than the current
mainline, should someone have some extra time to spend on this.

<URL:git://salottisipuli.retiisi.org.uk/~sakke/linux-omap>

Remove these drivers for now so we can get rid of V4L2 int device. Perhaps I
will have time to fix them at some point but it'll likely come after the
N900 support.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
