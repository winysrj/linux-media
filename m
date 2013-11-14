Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46039 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab3KNOE3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Nov 2013 09:04:29 -0500
Message-ID: <5284D863.1080306@iki.fi>
Date: Thu, 14 Nov 2013 16:04:19 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Walls <awalls@md.metrocast.net>,
	LMML <linux-media@vger.kernel.org>
Subject: SDR API libv4lconvert remove packet headers in-Kernel or userspace
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
Should I feed whole raw USB packet to libv4lconvert or rip headers off 
inside Kernel and feed only data? It is very trivial to remove headers 
in kernel and in a case of USB it does not even cost about nothing as 
you have to mem copy data out from URB in any case (if you do it on that 
phase).

Lets take a most complex case I have. There is not only raw data, but 
some meta-data to process samples. In that case those samples are 
bit-shifted according to control bits in order to increase nominal 
sample resolution from 10 to 12 bits (not sure if it is bit shift or 
some other algo, but shifting bits sounds reasonable and testing against 
RF-signal generator results looked correct as it is now implemented).

So do I feed that whole USB packet to userspace or do I have to remove 
headers + do bit bit shifting and forward only raw samples to userspace?

That example could be found from:
drivers/staging/media/msi3101/sdr-msi3101.c

Here is what on USB packet looks like:

+===============================================================
|   00-1023 | USB packet type '384'
+===============================================================
|   00-  03 | sequence number of first sample in that USB packet
+---------------------------------------------------------------
|   04-  15 | garbage
+---------------------------------------------------------------
|   16- 175 | samples
+---------------------------------------------------------------
|  176- 179 | control bits for previous samples
+---------------------------------------------------------------
|  180- 339 | samples
+---------------------------------------------------------------
|  340- 343 | control bits for previous samples
+---------------------------------------------------------------
|  344- 503 | samples
+---------------------------------------------------------------
|  504- 507 | control bits for previous samples
+---------------------------------------------------------------
|  508- 667 | samples
+---------------------------------------------------------------
|  668- 671 | control bits for previous samples
+---------------------------------------------------------------
|  672- 831 | samples
+---------------------------------------------------------------
|  832- 835 | control bits for previous samples
+---------------------------------------------------------------
|  836- 995 | samples
+---------------------------------------------------------------
|  996- 999 | control bits for previous samples
+---------------------------------------------------------------
| 1000-1023 | garbage
+---------------------------------------------------------------


regards
Antti

-- 
http://palosaari.fi/
