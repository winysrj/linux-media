Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:47967 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbZEBNTJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 May 2009 09:19:09 -0400
Date: Sat, 2 May 2009 15:19:03 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: tvaudio.c: possible problem with V4L2_TUNER_MODE_MONO
Message-ID: <Pine.LNX.4.64.0905021518250.9563@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The file drivers/media/video/tvaudio.c contains the following code:

(starting at line 1257 in a recent linux-next)

		if (mode & V4L2_TUNER_MODE_MONO)
			s1 |= TDA8425_S1_STEREO_MONO;
		if (mode & V4L2_TUNER_MODE_STEREO)
			s1 |= TDA8425_S1_STEREO_SPATIAL;

(starting at line 1856 in a recent linux-next)

	if (mode & V4L2_TUNER_MODE_MONO)
		vt->rxsubchans |= V4L2_TUNER_SUB_MONO;
	if (mode & V4L2_TUNER_MODE_STEREO)
		vt->rxsubchans |= V4L2_TUNER_SUB_STEREO;

The only possible value of V4L2_TUNER_MODE_MONO, however, seems to be 0, as
defined in include/linux/videodev2.h, and thus the first test in each case
is never true.  Is this what is intended, or should the tests be expressed
in another way?

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
