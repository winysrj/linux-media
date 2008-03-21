Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out113.alice.it ([85.37.17.113])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sarkiaponius@alice.it>) id 1JconI-0004BW-5z
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 22:28:56 +0100
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by debian (Postfix) with ESMTP id 628D91040BD
	for <linux-dvb@linuxtv.org>; Fri, 21 Mar 2008 22:27:26 +0100 (CET)
Message-ID: <47E4283D.8020700@alice.it>
Date: Fri, 21 Mar 2008 22:27:25 +0100
From: Andrea Giuliano <sarkiaponius@alice.it>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] No channels on just some frequencies...
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

I can szap many free channels from Hotbird 13E, but none on some 
frequencies. For example, if the "test" file just contains the line:

   S 11766000 V 27500000 2/3

that I took from http://www.lyngsat.com/hotbird.html as many other which 
instead work percectly, the command:

   scan test > channels.conf

alway gives the following output:

scanning prova
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 11766000 V 27500000 2
 >>> tune to: 11766:v:0:27500
WARNING: >>> tuning failed!!!
 >>> tune to: 11766:v:0:27500 (tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

On the other hand, if I put manually some lines in channels.conf for 
such a frequency, I can zap to those channels, but in most cases I watch 
a different channel, not the one I expected to see.

This doesn't happen on other frequencies.

May be of some help the fact that I'm writing from Italy, and I cannot 
get channels from the scan for the most important italian channels: in 
particular, none of RAI network, nor Mediaset network, the biggest 
network in Italy.

Also, the signal became rather good after I bought an amplifier. 
Actually, I can see and record perfectly fine many channels. I don't 
think I have signal strength problems.

Any hint will be very much appreciated.

Best regards.

-- 
Andrea

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
