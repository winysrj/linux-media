Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ysangkok@gmail.com>) id 1JT546-00089C-Qa
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 01:50:02 +0100
Received: by fk-out-0910.google.com with SMTP id z22so1204717fkz.1
	for <linux-dvb@linuxtv.org>; Sat, 23 Feb 2008 16:49:59 -0800 (PST)
Message-ID: <15a344380802231649m6911cf25s326ba782d0706331@mail.gmail.com>
Date: Sun, 24 Feb 2008 01:49:58 +0100
From: Ysangkok <ysangkok@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <15a344380802221804v1c4cf298oa80ac3552eb645ff@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <15a344380802220720j4ce3a2f0y8401c4e9b90bb553@mail.gmail.com>
	<15a344380802220739i15ba0739na6372c8b61695fca@mail.gmail.com>
	<20080222204943.GA16321@aidi.santinoli.com>
	<15a344380802221801n70ba6595o61e7df8d34bca116@mail.gmail.com>
	<15a344380802221804v1c4cf298oa80ac3552eb645ff@mail.gmail.com>
Subject: Re: [linux-dvb] Hauppauge WinTV Nova-T Stick problems
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

2008/2/23, Ysangkok <ysangkok@gmail.com>:
>   2008/2/22, David Santinoli <marauder@tiscali.it>:
>
>  > On Fri, Feb 22, 2008 at 04:39:05PM +0100, Ysangkok wrote:
>   >  > However I cannot get it to work. I have fetched the firmware
>   >  > dvb-usb-dib0700-1.10.fw (34306 bytes). When I use (dvb)scan I get
>   >  > "tuning failed".
>   >
>   >
>   > Hi Ysangkok,
>   >   I have a Nova-T Stick very similar to yours (mine has USB
>   >  vendor:product ID 2040:7060 while yours is 2040:7070).  Assuming the
>   >  hardware is substantially the same, you might want to 'modprobe mt2060'
>   >  and check for this line in the dmesg output:
>   >
>   >  MT2060: successfully identified (IF1 = 1220)
>   >
>   >  Cheers,
>   >
>   >  David
>   >
>
>
> Hello David,
>
>   I modprobe'd mt2060, however it doesn't render any additional lines in
>   dmesg. The module does show up in lsmod (attached).
>
>   Anyway, I forgot to tell you that I _did_ compile the latest linux-dvb
>   git tree (about three days ago), however I am using the default Ubuntu
>   kernel (2.6.22-14-generic). However if I compiled my own linux-dvb I
>   understood that I did not need to have the absolute latest kernel.
>
>   Next time I reboot I'll check what makes it show all those error
>   messages in dmesg.
>
>   I have an old syslog which has all the error messages, which look like this:
>
>   Feb 21 09:44:35 Gigabob kernel: [  541.199844] dib0700: RC Query Failed
>   Feb 21 09:44:35 Gigabob kernel: [  541.199856] dvb-usb: error while
>   querying for an remote control event.
>   Feb 21 09:44:35 Gigabob kernel: [  541.351680] dib0700: RC Query Failed
>   Feb 21 09:44:35 Gigabob kernel: [  541.351692] dvb-usb: error while
>   querying for an remote control event.
>   Feb 21 09:44:35 Gigabob kernel: [  541.503522] dib0700: RC Query Failed
>   Feb 21 09:44:35 Gigabob kernel: [  541.503538] dvb-usb: error while
>   querying for an remote control event.
>   Feb 21 09:44:36 Gigabob kernel: [  541.655351] dib0700: RC Query Failed
>
>   And it goes on like that :P
>
>   The full syslog is 2,5 MB. I can upload if you wan't it, but there is
>   not anything special.
>
>   Regards,
>   Ysangkok
>

Hello again,

I am sorry for top posting in the past. I forgot that I shouldn't.

I thought maybe that the firmware was wrong. Since the device works in
Vista, maybe I should try stealing its firmware. However, I do not
know how to do this.

I am also wondering if I can just boot into Vista and let it load the
firmware. If I then reboot, I wonder if the firmware will still be in
the stick, so Linux can use it?

BTW, here's the output from dvbscan:
$ scan -vvvvvvvv /usr/share/doc/dvb-utils/examples/scan/dvb-t/dk-Copenhagen
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/dk-Copenhagen
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 714000000 0 3 9 1 1 0 0
>>> tune to: 714000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
WARNING: >>> tuning failed!!!
>>> tune to: 714000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
(tuning failed)
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
>>> tuning status == 0x01
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

No output in dmesg.

Regards,
Janus Troelsen

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
