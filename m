Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46595 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751547Ab0FMHNC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 03:13:02 -0400
Received: from [192.168.129.248] (dino.hcc-intra.de [192.168.129.248])
	by dino.hcc-intra.de (Postfix) with ESMTPS id 6F124690AF3
	for <linux-media@vger.kernel.org>; Sun, 13 Jun 2010 09:12:59 +0200 (CEST)
Message-ID: <4C1484FB.8090806@gmx.net>
Date: Sun, 13 Jun 2010 09:12:59 +0200
From: "C. Hemsing" <C.Hemsing@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: af9015, af9013 DVB-T problems
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To the maintainer of the af9015, af9013 modules:

A recent kernel (but the problem had been the same with older kernels):
2.6.32-22-generic #36-Ubuntu SMP Thu Jun 3 22:02:19 UTC 2010 i686 GNU/Linux

Latest (as of yesterday) checkout of v4l-dvb (but the problem had been
the same with older checkouts).

Dual channel USB DVB-T stick initialized ok, but
regularly the stick does not tune properly on one of the two channels
and the kernel shows these error messages at the same time:

[14410.717905] af9015: command failed:2
[14410.717913] af9013: I2C read failed reg:d330
[18208.030546] af9015: command failed:2
[18208.030554] af9013: I2C read failed reg:d2e6

I'm willing to help debug. Who is the maintainer of af9015, af9013?

Cheers,
Chris


