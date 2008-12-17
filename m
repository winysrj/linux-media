Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gavermer@gmail.com>) id 1LD2YT-0008Is-GQ
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 20:59:38 +0100
Received: by ug-out-1314.google.com with SMTP id x30so364800ugc.16
	for <linux-dvb@linuxtv.org>; Wed, 17 Dec 2008 11:59:33 -0800 (PST)
Message-ID: <468e5d620812171159g49b87f0bu484d5445c695249f@mail.gmail.com>
Date: Wed, 17 Dec 2008 20:59:33 +0100
From: "ga ver" <gavermer@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Linux DVB driver API version 5.0?
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

Hi
I download the S2API driver from
hg clone http://mercurial.intuxication.org/hg/s2-liplianin
make and make install OK

I try to install scan-s2 and got
/usr/local/src# cd scan-s2
root@gv3:/usr/local/src/scan-s2# make
gcc -I../s2/linux/include -c diseqc.c -o diseqc.o
In file included from diseqc.c:7:
scan.h:86: fout: expected specifier-qualifier-list before 'fe_rolloff_t'
make: *** [diseqc.o] Fout 1

Installing vdr-1.7.2 gives
/usr/local/src/vdr-1.7.2# make
In file included from audio.c:12:
dvbdevice.h:19:2: error: #error VDR requires Linux DVB driver API version 5.0!
In file included from dvbdevice.c:10:
dvbdevice.h:19:2: error: #error VDR requires Linux DVB driver API version 5.0!
In file included from dvbosd.c:15:

Is this not de right driver?, or what is wrong

gaver

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
