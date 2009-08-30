Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:56123 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbZH3GaD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 02:30:03 -0400
Message-ID: <4A9A1AB6.2050801@freemail.hu>
Date: Sun, 30 Aug 2009 08:22:46 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Michel Xhaard <mxhaard@users.sourceforge.net>
CC: V4L Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-2?Q?N=E9me?= =?ISO-8859-2?Q?th_M=E1rton?=
	<nm127@freemail.hu>
Subject: gspca_sunplus: problem with brightness control
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am using a "Trust 610 LCD Powerc@m Zoom" device in webcam mode
(USB ID=06d6:0031). I am running Linux 2.6.31-rc7 updated with the
http://linuxtv.org/hg/v4l-dvb repository at version 12564:6f58a5d8c7c6.

When I start watching to the webcam picture and change the brightness
value then I get the following result. The possible brigthness values
are between 0 and 255.

for i in $(seq 0 255); do echo $i; v4lctl bright $i; done

0: average image
 |
 | lighter images
 v
127: the most light image
 |
 | "jump" in brightness
 v
128: the most dark image
 |
 | lighter images
 v
255: average image

It seems to me that the values 128...255 are really negative numbers, so
the possible range should be between -128...127 (two's complement representation)
in case of this webcam.

Note that the contrast and color controls does not have any jump in
the range 0...255.

Regards,

	Márton Németh
