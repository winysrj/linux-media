Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.182])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JYPNw-0003iB-P8
	for linux-dvb@linuxtv.org; Sun, 09 Mar 2008 18:32:35 +0100
Received: by py-out-1112.google.com with SMTP id a29so1636564pyi.0
	for <linux-dvb@linuxtv.org>; Sun, 09 Mar 2008 10:32:27 -0700 (PDT)
Message-ID: <47D41F26.6050905@googlemail.com>
Date: Sun, 09 Mar 2008 17:32:22 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] How to start a DVB reception
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

Hi,

What does exactly trigger the DVB architecture to start receiving data?

It seems that I can only receive DVB as long as there is a running application that has opened the 
fronted in read/write mode and tuned.

The following does not work (if it is the only application running)
(Even if it reports a LOCK)

1) open the fronted in read only
2) check for LOCK
3) open the demux
4) set some filter, output to DEMUX
5) start the demux
6) read from demux

The is no data to read.

I've tried test_pes in dvb-apps/test and it behaves the same.

Someone has to call FE_SET_FRONTEND and keep the fd open.

Is it true?

I would like to receive the whole TS of whatever is currently tuned. (possibly in read only).

Andrea


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
