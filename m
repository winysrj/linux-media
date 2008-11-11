Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from omzesmtp03a.verizonbusiness.com ([199.249.25.201])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mark.paulus@verizonbusiness.com>) id 1L007w-0000NB-7b
	for linux-dvb@linuxtv.org; Tue, 11 Nov 2008 21:46:21 +0100
Received: from dgismtp02.mcilink.com ([166.38.58.142])
	by firewall.verizonbusiness.com
	(Sun Java(tm) System Messaging Server 6.3-5.02 (built Oct 12 2007;
	32bit))
	with ESMTP id <0KA60095WSC8P600@firewall.verizonbusiness.com> for
	linux-dvb@linuxtv.org; Tue, 11 Nov 2008 20:45:44 +0000 (GMT)
Received: from dgismtp02.mcilink.com ([127.0.0.1])
	by dgismtp02.mcilink.com (iPlanet Messaging Server 5.2 HotFix 2.08
	(built Sep
	22 2005)) with SMTP id <0KA600H36SC7DB@dgismtp02.mcilink.com> for
	linux-dvb@linuxtv.org; Tue, 11 Nov 2008 20:45:43 +0000 (GMT)
Received: from [127.0.0.1] ([166.34.133.101])
	by dgismtp02.mcilink.com (iPlanet Messaging Server 5.2 HotFix 2.08
	(built Sep
	22 2005)) with ESMTP id <0KA600FIXSC6CC@dgismtp02.mcilink.com> for
	linux-dvb@linuxtv.org; Tue, 11 Nov 2008 20:45:43 +0000 (GMT)
Date: Tue, 11 Nov 2008 13:45:42 -0700
From: Mark Paulus <mark.paulus@verizonbusiness.com>
In-reply-to: <11925882.1226435183455.JavaMail.root@elwamui-ovcar.atl.sa.earthlink.net>
To: William Melgaard <piobair@mindspring.com>
Message-id: <4919EEF6.5030108@verizonbusiness.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary=------------090308070804080209060507
References: <11925882.1226435183455.JavaMail.root@elwamui-ovcar.atl.sa.earthlink.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] FusionHDTV7 RT Gold
Reply-To: mark.paulus@verizonbusiness.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------090308070804080209060507
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



William Melgaard wrote:
> I have a DViCO FusionHDTV7 RT Gold PCI card in my posession. To date, I cannot make it work with my AMD64 Debian (stable) box. This card is not to be confused with the Dual Express or the USB cards
> 
> I am getting mixed answers to request for support.
> I have been told that the card is supported. I downloaded the latest Mercurial, and installed it. As far as I can tell, the FusionHDTV7 RT Gold is NOT supported by the latest Mercurial. If it is, please provide configuration instructions.
> 
> If the RT Gold is not yet supported, what can I do to aid in providing support? I have some c programming skills, but have never dealt with a driver.
> 
> William Melgaard
> Virginia 23666, USA
> 

When you say, "I cannot make it work", what exactly do you mean?

Could you do some simple diagnostics, and send the output
to the list:

uname -a

lspci -v

the output of dmesg, starting immediately
after the Hard Disk discovery statements.

lsmod

Have you tried to scan any multiplexes, and what kind 
of results are you seeing?

How is the card wired up, physically?

What other kind of diagnostics have you done to verify
that the card is not functional? (Have you tried it in a 
MicroShaft Winblows machine to make sure the card itself
is functional?)

It's hard to diagnose problems without some more info
as to what might be wrong...

I have a DViCO FusionHDTV5 Lite in my AMD64 Stable box,
along with several other cards (PVR-150, 
Avermedia A180 QAM, Air2PC SkyStar2 ATSC).  I am 
running a 2.6.24 kernel from etch-and-half, but all 
my cards are functional, and play together well.

--------------090308070804080209060507
Content-Type: text/x-vcard; charset=utf-8;
 name="mark_paulus.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="mark_paulus.vcf"

YmVnaW46dmNhcmQNCmZuOk1hcmsgUGF1bHVzDQpuOlBhdWx1cztNYXJrDQpvcmc6TUNJO0xl
YyBJbnRlcmZhY2VzIC8gNDA0MTkNCmFkcjtkb206OzsyNDI0IEdhcmRlbiBvZiB0aGUgR29k
cyBSZDtDb2xvcmFkbyBTcHJpbmdzO0NPOzgwOTE5DQplbWFpbDtpbnRlcm5ldDptYXJrLnBh
dWx1c0B2ZXJpem9uYnVzaW5lc3MuY29tDQp0aXRsZTpNYXJrIFBhdWx1cw0KdGVsO3dvcms6
NzE5LTUzNS01NTc4DQp0ZWw7cGFnZXI6ODAwLXBhZ2VtY2kgLyAxNDA2MDUyDQp0ZWw7aG9t
ZTp2NjIyLTU1NzgNCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K
--------------090308070804080209060507
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------090308070804080209060507--
