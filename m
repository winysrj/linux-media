Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:53707 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756176AbcB0Jsn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 04:48:43 -0500
Received: from [192.168.11.10] ([80.219.76.43]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0MLA45-1aZKVV2OmH-000Ib1 for
 <linux-media@vger.kernel.org>; Sat, 27 Feb 2016 10:48:40 +0100
From: =?UTF-8?Q?David_M=c3=bcller?= <dave.mueller@gmx.ch>
Subject: Unable to write V4L2 capture buffers to O_DIRECT file
To: Linux Media <linux-media@vger.kernel.org>
Message-ID: <56D170F7.9030200@gmx.ch>
Date: Sat, 27 Feb 2016 10:48:39 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

I'm trying to store data received from a V4L2 capture device to a SATA
storage device.

For performance reasons, i would like to do the writing using a file
opened with the O_DIRECT flag.


As a test, I have modified the v4lcap example code to support writing
output files directly (-F option) and to select IO mode (-B option).

Running this code results in a -EFAULT error returned by the write()
function used to write to the output file as shown below:

/ # v4lcap -c 2 -o -F /dev/sda1 -Bd
IO: O_DIRECT mode
error writing file: Bad address
        buf: 0x76ac8000, size: 0x2DC800
.error writing file: Bad address
        buf: 0x767eb000, size: 0x2DC800


Without "O_DIRECT", the v4lcap tool works ok but the overall performance
is pretty bad.

/ # v4lcap -c 2 -o -F /dev/sda1 -Bb
IO: normal mode
..


Any ideas/hints how to fix this?


HW: i.MX6Q based custom board
SW: kernel 4.2.0 + some patches (mainly CSI capture related)


Dave
