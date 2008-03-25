Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout.perfora.net ([74.208.4.194])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tlenz@vorgon.com>) id 1JeEcb-0006io-Fh
	for linux-dvb@linuxtv.org; Tue, 25 Mar 2008 20:15:46 +0100
Message-ID: <001d01c88eac$9e7adbb0$0a00a8c0@vorg>
From: "Timothy D. Lenz" <tlenz@vorgon.com>
To: <linux-dvb@linuxtv.org>
Date: Tue, 25 Mar 2008 12:15:35 -0700
MIME-Version: 1.0
Subject: [linux-dvb] Compile problem with hg dvb-apps
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I think this is another 64-bit compatibility problem. This is with a
download from hg last night of 2686c080e0b5 tip:

vorg@x64VDR:/usr/local/src/VDR/scan/dvb-apps$ make
make -C lib all
make[1]: Entering directory `/usr/local/src/VDR/scan/dvb-apps/lib'
make -C libdvbapi all
make[2]: Entering directory `/usr/local/src/VDR/scan/dvb-apps/lib/libdvbapi'
CC dvbaudio.o
CC dvbca.o
CC dvbdemux.o
CC dvbfe.o
CC dvbnet.o
CC dvbvideo.o
In file included from dvbvideo.c:28:
/usr/include/linux/dvb/video.h:100: error: expected specifier-qualifier-list
before =E2__u32=E2
make[2]: *** [dvbvideo.o] Error 1
make[2]: Leaving directory `/usr/local/src/VDR/scan/dvb-apps/lib/libdvbapi'
make[1]: *** [all] Error 2
make[1]: Leaving directory `/usr/local/src/VDR/scan/dvb-apps/lib'
make: *** [all] Error 2


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
