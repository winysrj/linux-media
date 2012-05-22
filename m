Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:62971 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978Ab2EVLAY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 07:00:24 -0400
Date: Tue, 22 May 2012 13:00:18 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org
Subject: Problems with the gspca_ov519 driver
Message-ID: <20120522110018.GX1927@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm trying to get video using v4l2 ioctls from a gspca_ov519 camera, and after
STREAMOFF all buffers are still flagged as QUEUED, and QBUF fails.  DQBUF also
fails (blocking for a 3 sec timeout), after streamoff. So I'm stuck, after
STREAMOFF, unable to get pictures coming in again. (Linux 3.3.5).

As an additional note, pinchartl on irc #v4l says to favour a moving of gspca to
vb2. I don't know what it means.

Can someone take care of the bug, or should I consider the camera 'non working'
in linux?

Thank you,
Lluís.
