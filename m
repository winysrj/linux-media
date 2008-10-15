Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jonestejm@gmail.com>) id 1Kq4Hf-0008DH-NG
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 13:11:20 +0200
Received: by ti-out-0910.google.com with SMTP id w7so1724957tib.13
	for <linux-dvb@linuxtv.org>; Wed, 15 Oct 2008 04:11:12 -0700 (PDT)
Message-ID: <293e5e5c0810150411m6e43b514u8b540338fd5f724c@mail.gmail.com>
Date: Wed, 15 Oct 2008 21:41:12 +1030
From: "Tom Jones" <jonestejm@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Compro T300
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0209823075=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0209823075==
Content-Type: multipart/alternative;
	boundary="----=_Part_26209_5412168.1224069072694"

------=_Part_26209_5412168.1224069072694
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I'm having a problem with my Compro T300 TV tuner card and hope someone can
assist.

The card is recognized and I can scan channels using Kaffeine however it
only finds the 4 stations on the UHF channel.  The other four VHF channels
are not found.  I find this strange as the UHF frequency is the weakest of
the five.  tzap gets a lock on all 5 frequencies (UHF & VHF).

MythTV recognises the card but scanning only results in timeout messages.
Manually entering the frequency data doesn't work.

I'm not that familiar with linux however my assumption is that the card is
having problems with VHF frequencies.  I'm not sure if this is correct as
MythTV won't even find the UHF channel.  I know it's not the signal as my
2nd card (LeadTek) scans without a problem.

lspci shows
  01:07.0 Multimedia controller: Philips Semiconductors SAA7134/SAA7135HL
Video Broadcast Decoder (rev 01)

$ dmesg | grep DVB
[   35.847007] saa7134[0]: subsystem: 185b:c900, board: Compro Videomate
DVB-T300 [card=70,insmod option]
[   36.581953] DVB: registering new adapter (saa7134[0])
[   36.581962] DVB: registering frontend 0 (Philips TDA10046H DVB-T).

modules has
saa7134-dvb

options
options saa7134 card=70 oss=1 tuner=67

I'm now at a deadend?

Tom

------=_Part_26209_5412168.1224069072694
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">I&#39;m having a problem with my Compro T300 TV tuner card and hope someone can assist.<br><br>The card is recognized and I can scan channels using Kaffeine however it only finds the 4 stations on the UHF channel.&nbsp; The other four VHF channels are not found.&nbsp; I find this strange as the UHF frequency is the weakest of the five.&nbsp; tzap gets a lock on all 5 frequencies (UHF &amp; VHF).<br>
<br>MythTV recognises the card but scanning only results in timeout messages.&nbsp; Manually entering the frequency data doesn&#39;t work.&nbsp; <br><br>I&#39;m not that familiar with linux however my assumption is that the card is having problems with VHF frequencies.&nbsp; I&#39;m not sure if this is correct as MythTV won&#39;t even find the UHF channel.&nbsp; I know it&#39;s not the signal as my 2nd card (LeadTek) scans without a problem.<br>
<br>lspci shows <br>&nbsp; 01:07.0 Multimedia controller: Philips Semiconductors SAA7134/SAA7135HL Video Broadcast Decoder (rev 01)<br><br>$ dmesg | grep DVB<br>[&nbsp;&nbsp; 35.847007] saa7134[0]: subsystem: 185b:c900, board: Compro Videomate DVB-T300 [card=70,insmod option]<br>
[&nbsp;&nbsp; 36.581953] DVB: registering new adapter (saa7134[0])<br>[&nbsp;&nbsp; 36.581962] DVB: registering frontend 0 (Philips TDA10046H DVB-T).<br><br>modules has<br>saa7134-dvb<br><br>options<br>options saa7134 card=70 oss=1 tuner=67<br>
<br>I&#39;m now at a deadend?<br><br>Tom<br><br><br></div>

------=_Part_26209_5412168.1224069072694--


--===============0209823075==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0209823075==--
