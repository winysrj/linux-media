Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from [212.57.247.218] (helo=glcweb.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael.curtis@glcweb.co.uk>) id 1JQfyI-0007lf-L0
	for linux-dvb@linuxtv.org; Sun, 17 Feb 2008 10:38:08 +0100
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Sun, 17 Feb 2008 09:36:35 -0000
Message-ID: <A33C77E06C9E924F8E6D796CA3D635D1023973@w2k3sbs.glcdomain.local>
From: "Michael Curtis" <michael.curtis@glcweb.co.uk>
To: "Igor" <goga777@bk.ru>,
	"henk schaap" <haschaap@planet.nl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] multiproto and tt3200: don't get a lock
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Igor

I see in your thread '[linux-dvb] parm: dvb_powerdown_on_sleep:0 &
multiproto' that you have got the frontend to tune

I am in the same position as you were in your mail yesterday "
[linux-dvb]multiproto and tt3200: don't get a lock"

What did you do to get that part to work?

Michael Curtis


> henk@mediapark:~/bin/szap> ./szap -n 1775

try please witch patched szap2

http://abraham.manu.googlepages.com/szap.c

==========================================
Make sure you have the updated headers (frontend.h, version.h in your
include 
path)
(You need the same headers from the multiproto tree)

wget http://abraham.manu.googlepages.com/szap.c
copy lnb.c and lnb.h from dvb-apps to the same folder where you
downloaded 
szap.c
cc -c lnb.c
cc -c szap.c
cc -o szap szap.o lnb.o
That's it
Manu
==========================================


> reading channels from file '/home/henk/.szap/channels.conf'
> zapping to 1775 'WDR 3;ARD':
> sat 0, frequency = 12109 MHz H, symbolrate 27500000, vpid = 0x1fff,
apid 
> = 0x05dd sid = 0x0000
> Querying info .. Delivery system=DVB-S
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> ----------------------------------> Using 'STB0899 DVB-S' DVB-Sstatus
00 
> | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

-- 
This message has been scanned for viruses and
dangerous content by IC-MailScanner, and is
believed to be clean.

For queries or information please contact:-

=================================
Internet Central Technical Support


 http://www.netcentral.co.uk
=================================


No virus found in this incoming message.
Checked by AVG Free Edition. 
Version: 7.5.516 / Virus Database: 269.20.7/1283 - Release Date:
16/02/2008 14:16
 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
