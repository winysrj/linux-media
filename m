Return-path: <mchehab@pedra>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60383 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475Ab1EUTeW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 15:34:22 -0400
Received: by gwaa18 with SMTP id a18so1668293gwa.19
        for <linux-media@vger.kernel.org>; Sat, 21 May 2011 12:34:22 -0700 (PDT)
MIME-Version: 1.0
From: Roman Gaufman <hackeron@gmail.com>
Date: Sat, 21 May 2011 20:34:02 +0100
Message-ID: <BANLkTin=Fs-ugm13yT89PtT4bds4WobszA@mail.gmail.com>
Subject: Connexant cx25821 help
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I have a PCI-E capture card with two connexant cx25821 chips.
04:00.0 Multimedia video controller: Conexant Systems, Inc. Device 8210
05:00.0 Multimedia video controller: Conexant Systems, Inc. Device 8210


There is a staging driver in latest linux kernels. Looks like it uses v4l2
api.
I tried to use precompiled module cx25821 provided with Ubuntu 10.10 beta
(2.6.35-19-generic #28-Ubuntu SMP Sun Aug 29 06:36:51 UTC 2010 i686
GNU/Linux).

# modprobe cx25821

The module looks like to be loaded successfully.

# lsmod | grep cx
cx25821               108646  0
v4l2_common            17329  1 cx25821
videodev               43098  2 cx25821,v4l2_common
videobuf_dma_sg         9806  1 cx25821
videobuf_core          16907  2 cx25821,videobuf_dma_sg
btcx_risc               3636  1 cx25821
tveeprom               11178  1 cx25821

dmesg says:
[ 1980.986232] Linux video capture interface: v2.00
[ 1980.989245] cx25821: module is from the staging directory, the quality is
unknown, you have been warned.
[ 1980.993152] cx25821 driver version 0.0.106 loaded

And now I can not see any /dev/video0-7 devices to get input from the card.
I'l greatly appreciate if someone could tell me about additional actions to
make this work.

Thank you.

Roman
