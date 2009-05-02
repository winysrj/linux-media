Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:47989 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbZEBNTn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 May 2009 09:19:43 -0400
Date: Sat, 2 May 2009 15:19:38 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: hverkuil@xs4all.nl, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: ivtv-ioctl.c: possible problem with IVTV_F_I_DMA
Message-ID: <Pine.LNX.4.64.0905021519040.9563@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The file drivers/media/video/ivtv/ivtv-ioctl.c contains the following code:

(starting at line 183 in a recent linux-next)

		while (itv->i_flags & IVTV_F_I_DMA) {
			got_sig = signal_pending(current);
			if (got_sig)
				break;
			got_sig = 0;
			schedule();
		}

The only possible value of IVTV_F_I_DMA, however, seems to be 0, as defined
in drivers/media/video/ivtv/ivtv-driver.h, and thus the test is never true.
Is this what is intended, or should the test be expressed in another way?

julia

This problem was found using the following semantic match:
(http://www.emn.fr/x-info/coccinelle/)

@r expression@
identifier C;
expression E;
position p;
@@

(
 E & C@p && ...
|
 E & C@p || ...
)

@s@
identifier r.C;
position p1;
@@

#define C 0

@t@
identifier r.C;
expression E != 0;
@@

#define C E

@script:python depends on s && !t@
p << r.p;
C << r.C;
@@

cocci.print_main("and with 0", p)
