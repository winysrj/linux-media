Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.cooptel.qc.ca ([216.144.115.12] helo=amy.cooptel.qc.ca)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rlemieu@cooptel.qc.ca>) id 1KOx6l-0002Za-IJ
	for linux-dvb@linuxtv.org; Fri, 01 Aug 2008 18:04:00 +0200
Message-ID: <489333CC.1070000@cooptel.qc.ca>
Date: Fri, 01 Aug 2008 12:03:24 -0400
From: Richard Lemieux <rlemieu@cooptel.qc.ca>
MIME-Version: 1.0
To: kurt xue <kurtxue@gmail.com>
References: <489301B6.3070706@cooptel.qc.ca>
	<f3ebb34d0808010742q6a136430pe49d2bb1c38b0d76@mail.gmail.com>
In-Reply-To: <f3ebb34d0808010742q6a136430pe49d2bb1c38b0d76@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvbscan won't tune any channel while kaffeine does
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

Kurt

No luck yet!  kaffeine locks on channels with 74% S/N ratio but
scan returns nothing.

   scan -t UNIVERSAL /opt/dvb-apps/share/dvb/dvb-s/Galaxy3C-95w 2>&1 | tee 
/tmp/tmpscan
   scanning /opt/dvb-apps/share/dvb/dvb-s/Galaxy3C-95w
   using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
   initial transponder 11780000 H 20760000 9
   >>> tune to: 11780:h:0:20760
   DVB-S IF freq is 1180000
   WARNING: >>> tuning failed!!!
   >>> tune to: 11780:h:0:20760 (tuning failed)
   DVB-S IF freq is 1180000
   WARNING: >>> tuning failed!!!
   ERROR: initial tuning failed
   dumping lists (0 services)
   Done.

kaffeine creates file '.kde/share/apps/kaffeine/channels.dvb'
which has a different format than '.szap/channels.conf'. As
an example, an entry in kaffeine/channels.dvb looks like,

TV|CCTV 
4|512(2)|650,|0|1|1|SGalaxy3C-95w|11780|20760|h|-1|-1|-1|-1|-1|-1|-1|-1|1|||65535|

szap can't parse the file 'channels.conf' as written by kaffeine.

Otherwise, here are some results I get,

 > dvbscan  -adapter 0 -frontend 0 -demux 0 
/opt/dvb-apps/share/dvb/dvb-s/Galaxy3C-95w
Failed to set frontend

 > dvbscan /opt/dvb-apps/share/dvb/dvb-s/Galaxy3C-95w
Failed to set frontend

 > dvbsnoop -s feinfo
dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/

---------------------------------------------------------
FrontEnd Info...
---------------------------------------------------------

Device: /dev/dvb/adapter0/frontend0

Basic capabilities:
     Name: "Conexant CX24116/CX24118"
     Frontend-type:       QPSK (DVB-S)
     Frequency (min):     950.000 MHz
     Frequency (max):     2150.000 MHz
     Frequency stepsiz:   1.011 MHz
     Frequency tolerance: 5.000 MHz
     Symbol rate (min):     1.000000 MSym/s
     Symbol rate (max):     45.000000 MSym/s
     Symbol rate tolerance: 0 ppm
     Notifier delay: 0 ms
     Frontend capabilities:
         auto inversion
         FEC 1/2
         FEC 2/3
         FEC 3/4
         FEC 4/5
         FEC 5/6
         FEC 6/7
         FEC 7/8
         FEC AUTO
         QPSK

Current parameters:
     Frequency:  1456.250 MHz
     Inversion:  AUTO
     Symbol rate:  20.000000 MSym/s
     FEC:  FEC 3/4


kurt xue wrote:
> Hi,
> 
> I am not sure but I think Kaffeine will generate something like 
> "channel.conf" and try use szap with it see if it can lock signal 
> without using dvbtune. Good luck!
> 
> Regards,
> Kurt
> 
...
> 
>     The problem is that 'dvbscan' won't find any channel. I used the command
>     'dvbscan /opt/dvb-apps-73b910014d07/util/scan/dvb-s/Galaxy3C-95w'
>     since I live in North-America and the dish points on that satellite.
> 
>     Would anyone have a clue?  Why dvbscan does not find any station
>     while kaffeine does?
> 
>     Thank's very much.
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
