Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailhost.tue.nl ([131.155.3.8])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bas@kompasmedia.nl>) id 1JjDxo-0002hc-M1
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 15:34:17 +0200
Received: from localhost (localhost [127.0.0.1])
	by mailhost.tue.nl (Postfix) with ESMTP id 11EE76D6A1
	for <linux-dvb@linuxtv.org>; Tue,  8 Apr 2008 15:34:13 +0200 (CEST)
Received: from mailhost.tue.nl ([131.155.3.8])
	by localhost (kweetal.tue.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cDuTSUpir4m8 for <linux-dvb@linuxtv.org>;
	Tue,  8 Apr 2008 15:34:12 +0200 (CEST)
Received: from [131.155.156.90] (KC14189.buro.tue.nl [131.155.156.90])
	by mailhost.tue.nl (Postfix) with ESMTP id CDC346D66E
	for <linux-dvb@linuxtv.org>; Tue,  8 Apr 2008 15:34:12 +0200 (CEST)
Message-ID: <47FB7454.3030109@kompasmedia.nl>
Date: Tue, 08 Apr 2008 15:34:12 +0200
From: "Bas v.d. Wiel" <bas@kompasmedia.nl>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Mantis 2033 + CI
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

Hello everyone,
Please excuse me if I came to the wrong place with my question, but I've 
been searching high and low and couldn't find a definitive answer to my 
question. Is it at all possible to use a TwinHan Mantis 2033 card with 
integrated CI to receive encrypted DVB-C under Linux?

I've got the whole setup working quite well using Windows XP and 
Mediaportal, so hardware-wise things are ok and I managed to compile a 
list of frequencies and symbol rates from the Windows applications to 
use for tuning in Linux. Sadly though I get no further than a 
custom-compiled 2.6.18.1 kernel that loads the mantis module and seems 
to detect my card, but no channels are ever found when tuning even 
though there are a few FTA channels available to me. Also, is it normal 
for the mantis module to put a line in syslog whenever it changes 
frequencies?

I simply don't feel like buying a soon-to-be-EOL'ed OS just to do 
something that I feel MythTV+Linux does better so I hope there's a way 
to do this. If not, any suggestions for different DVB-C hardware that I 
can use to view Irdeto2 encrypted TV?

Thanks for any help!

Bas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
