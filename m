Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1JpuSK-00082N-B0
	for linux-dvb@linuxtv.org; Sun, 27 Apr 2008 02:09:25 +0200
From: Andy Walls <awalls@radix.net>
To: linux-dvb@linuxtv.org
Date: Sat, 26 Apr 2008 20:05:11 -0400
Message-Id: <1209254711.28704.10.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: ivtv-devel@ivtvdriver.org
Subject: [linux-dvb] [PATCH 0/2] mxl500x: debug module param and
	checkpatch.pl	compliance
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In the next two messages are a patch set for the mxl500x module that the
cx18 module uses for ATSC/DVB on the HVR-1600.

Patch 1/2: Control mxl500x module logging with "debug" module parameter
Patch 2/2: checkpatch.pl compliance for mxl500x

Patch 1/2 is the patch I submitted a few days ago, with absolutely no
changes.  I include it here because Patch 2/2 that implements
checkpatch.pl compliance depends on it.

My hope here is to get the cx18 driver closer to inclusion in the
kernel, by helping the mxl500x driver get closer to inclusion in the
kernel.


Regards,
Andy Walls


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
