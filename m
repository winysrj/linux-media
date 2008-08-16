Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n24.bullet.mail.mud.yahoo.com ([68.142.206.163])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <rvf16@yahoo.gr>) id 1KUKuu-0006Pf-70
	for linux-dvb@linuxtv.org; Sat, 16 Aug 2008 14:30:02 +0200
Message-ID: <48A6C80E.7050001@yahoo.gr>
Date: Sat, 16 Aug 2008 15:29:02 +0300
From: rvf16 <rvf16@yahoo.gr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] CX23885 based AVerMedia AVerTV Hybrid Express Slim tv
 card
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

Hello again.
No one seems to be interested in my attempts so i must be doing 
something wrong.
I find hard to locate where i can add a wiki about this card, and a 
simple howto for trying to make this card work.
It may be my mistake but i find all that i have red insufficient to 
understand how to continue.

Anyway after thorough examination of the vista driver i ended up in this 
section :
;-----------------------------------------------
; XC3028 + Afa9013
;-----------------------------------------------
%CX23885.HC81R%=CX23885.HC81_C,          
PCI\VEN_14F1&DEV_8852&SUBSYS_D9391461    ;PCI-e     XCeive_L+FM+Afa9013
(this is my model : AVer Media AVerTV Hybrid Express Slim HC81R HC81_C)

After googling around i found the following :
CX23885 = PCI Express Video and Broadcast Audio Decoder
http://www.conexant.com/products/entry.jsp?id=393
http://www.conexant.com/servlets/DownloadServlet/PBR-200865-004.pdf?docid=866&revid=4

XC3028 = Hybrid tuner
http://www.xceive.com/technology_XC3028.htm
http://www.xceive.com/docs/XC3028_prodbrief.pdf
I have the L model which is same as standard just with "L"ower energy  
consumption)

Afa9013 = Demodulator

from linux lspci -n :
0c:00.0 0400: 14f1:8852 (rev 02)
        Subsystem: 1461:d939

I can find no xc3028 module in the v4l tree and absolutely nothing on 
the Afa9013.
Please confirm the above are tuner and demodulator chips respectively 
and show me where i can create a wiki with the above info, my dmesg info 
and my card pictures.

Thank you.
Regards.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
