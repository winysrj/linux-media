Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ydgoo9@gmail.com>) id 1Kpa9X-0003Aj-3v
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 05:00:57 +0200
Received: by ti-out-0910.google.com with SMTP id w7so1183735tib.13
	for <linux-dvb@linuxtv.org>; Mon, 13 Oct 2008 20:00:46 -0700 (PDT)
Message-ID: <38dc7fce0810132000x426cf910j3b91413206fec3ab@mail.gmail.com>
Date: Tue, 14 Oct 2008 12:00:45 +0900
From: YD <ydgoo9@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] question about demuxing from hdd or memory
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

Hello all,

I got a question on dvb-api driver.

If I want to use the hardware demux when I play the file from hdd or memory,
Do I need to change the code in dvb_dvr_write() and some more  at dmxdev.c ?

In my understanding, linux dvb api only supports software demux(filtering)
when we filter the section or packet from hdd or memory.

Thanks,
youngduk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
