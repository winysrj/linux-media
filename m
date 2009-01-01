Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <redtux1@googlemail.com>) id 1LISMg-0007Bo-48
	for linux-dvb@linuxtv.org; Thu, 01 Jan 2009 19:33:51 +0100
Received: by bwz11 with SMTP id 11so13154654bwz.17
	for <linux-dvb@linuxtv.org>; Thu, 01 Jan 2009 10:33:16 -0800 (PST)
Message-ID: <ecc841d80901011033s58b2fecawd3dd2d42c1b09cd7@mail.gmail.com>
Date: Thu, 1 Jan 2009 18:33:16 +0000
From: "Mike Martin" <redtux1@googlemail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] dvbsream v0-5 and -n switch
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

Hi - hope this is the right list to ask questions about dvbstream.

I am using dvbstream for an application I am developing
(www.sourceforge.net/epgrec) and when I try using the -n switch
(according to help should set number of seconds to record) it has no
effect

I have tried all place on command line and no errors just no effect

example
dvbstream -ps  640 641 -n 1800 -o >
/media/video2/BBC_NewsREC_2009_01_01_18_31_45.mpeg

Am I missing something?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
