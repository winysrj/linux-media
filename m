Return-path: <linux-media-owner@vger.kernel.org>
Received: from www49.your-server.de ([213.133.104.49]:36056 "EHLO
	www49.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab0CQRLf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 13:11:35 -0400
Received: from [188.107.127.143] (helo=[192.168.1.22])
	by www49.your-server.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <besse@motama.com>)
	id 1NrwJJ-0003W5-Lz
	for linux-media@vger.kernel.org; Wed, 17 Mar 2010 17:41:33 +0100
Message-ID: <4BA10639.3000407@motama.com>
Date: Wed, 17 Mar 2010 17:41:29 +0100
From: Andreas Besse <besse@motama.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Problems with ngene based DVB cards (Digital Devices Cine S2 Dual
 DVB-S2 , Mystique SaTiX S2 Dual)
Content-Type: multipart/mixed;
 boundary="------------030508060205030902040908"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030508060205030902040908
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

we discovered several problems with the ngene based dual DVB cards. The
problems occur with the Digital Devices Cine S2 Dual DVB-S2 device
(Linux4Media cineS2 DVB-S2 Twin Tuner), the clones like Mystique SaTiX
S2 Dual should also be affected.

We are using the ngene drivers from the linuxtv repository
http://linuxtv.org/hg/v4l-dvb and the firmware version 15 provided by
Digital Devices.

*Setup* *******************************************

OpenSuse Linux 11.0
Linux anna 2.6.25.20-0.5-pae #1 SMP 2009-08-14 01:48:11 +0200 i686 i686
i386 GNU/Linux
DVB drivers: http://linuxtv.org/hg/v4l-dvb (ngene)
2e0444bf93a4 (changeset 14233:2e0444bf93a4, date: Mon Feb 22 10:58:43
2010 -0300)

module loaded with
  modprobe ngene one_adapter=0

*Usage* *******************************************

We slightly modified the latest version of szap-s2 (available from
http://mercurial.intuxication.org/hg/szap-s2/ ); see attached .tar.gz

tar xvfz modified_szap_s2.tar.gz

make

Most importantly, the modified version prints out the total delay in
seconds of main() to allow for easier debugging.

*Problem A* *******************************************

Two running instance of szap-s2 are used:

a) one for changing channels between "Das Erste" (Astra 19.2E) and
"ZDF" (Astra 19.2E)

b) the other one for recording from "Das Erste" (or any other channel)

Result:

When only a) is running, channel tuning times between the two
different transponders of "Das Erste" and "ZDF" are around 0.5
secs. This is really good.

However, when b) is started in parallel, these times increase to 1.5
to 1.8 seconds. This is not good.

How to reproduce?

1) in one shell, run

 ./run_szap-s2_adapter0.sh | grep Delay

You will see

Delay : 0.560508
Delay : 0.545771
Delay : 0.609781
Delay : 0.593796
Delay : 0.649772
Delay : 0.614023
..

2) in parallel in another shell, run

./szap-s2 -S 1 -H -c channels_DVB-S2_transponder_switch.conf -a 1 -n 1 -r

Immediately, you will see in 1)

Delay : 1.525178
Delay : 1.781971
..

*Problem B* *******************************************

After reproducing Problem A, we terminate process 2) by hitting
Ctrl-C.

Even then, channel tuning time stay high in process 1), you will still see

Delay : 1.773303
Delay : 1.781734
Delay : 1.749948
..

This is not good.

*Problem C* *******************************************

What is even worse:

Very often, you will soon run into trouble: After a very iterations,
you will see:

Delay : 21.616521
Delay : 21.773475
Delay : 21.765678

This means that tuning was not possible anymore at all.  In this
situation, it always helps to re-load the module by runing:

su -c "rmmod ngene && modprobe ngene one_adapter=0"

*Problem D* *******************************************

When terminating process 1) and immediately restarting it, channel
tuning times - again - stay high. This is not good.

Often you will also see Problem C then.

*Problem E* *******************************************

Go back to reproducing Problem A (process 1 and 2 are running), and
the continuously start and terminate process 2) by hitting Ctrl-C
again and again. Sooner or later, you will see Problem C occur then.

*Remark* *******************************************

It _seems_ that, after terminating all szap-s2 processes, and waiting 1
to 2 minutes, and then restarting szap-s2 again, the failures/problems
seem to be gone _without_ reloading the module.

thanks for your help,
Andreas Besse



--------------030508060205030902040908
Content-Type: application/x-gzip;
 name="modified_szap_s2.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="modified_szap_s2.tar.gz"

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
AiAXIE8AyAAA
--------------030508060205030902040908--
