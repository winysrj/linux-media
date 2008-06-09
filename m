Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailhost.okg-computer.de ([85.131.254.125])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@okg-computer.de>) id 1K5bh3-0000KJ-3C
	for linux-dvb@linuxtv.org; Mon, 09 Jun 2008 09:21:32 +0200
Received: from [10.10.43.120] (f053208039.adsl.alicedsl.de [78.53.208.39])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mailhost.okg-computer.de (Postfix) with ESMTP id 88DC94429A
	for <linux-dvb@linuxtv.org>; Mon,  9 Jun 2008 09:21:23 +0200 (CEST)
Message-ID: <484CD9F5.60906@okg-computer.de>
Date: Mon, 09 Jun 2008 09:21:25 +0200
From: =?ISO-8859-1?Q?Jens_Krehbiel-Gr=E4ther?=
 <linux-dvb@okg-computer.de>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <854d46170806081250u3e7ca97er32d47be3ccf368fb@mail.gmail.com>
	<E1K5Z0d-000P20-00.goga777-bk-ru@f172.mail.ru>
In-Reply-To: <E1K5Z0d-000P20-00.goga777-bk-ru@f172.mail.ru>
Subject: Re: [linux-dvb] scan & szap for new multiproto api (was - How to
 get a PCTV Sat HDTC Pro USB (452e) running?)
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

Goga777 schrieb:
>> I'm glad everything worked out for you :).
>> with szap to tune to DVB-S2 channels use this option "-t 2" default is
>> "- t 0" which is for DVB-S
>> to tune to 'Astra HD Promo 2' you do:
>> szap -r -c 19 -t 2 "Astra HD Promo 2"
>>     
>
> I will try so. It will be fine if new dvb-s2 option will include in szap --help output
>   

jens@midas-phalanx:/usr/src/dvb-apps-patched/util/szap# ./szap -h

usage: szap -q
         list known channels
       szap [options] {-n channel-number|channel_name}
         zap to channel via number or full name (case insensitive)
     -a number : use given adapter (default 0)
     -f number : use given frontend (default 0)
     -d number : use given demux (default 0)
     -c file   : read channels list from 'file'
     -b        : enable Audio Bypass (default no)
     -x        : exit after tuning
     -r        : set up /dev/dvb/adapterX/dvr0 for TS recording
     -l lnb-type (DVB-S Only) (use -l help to print types) or
     -l low[,high[,switch]] in Mhz
     -i        : run interactively, allowing you to type in channel names
     -p        : add pat and pmt to TS recording (implies -r)
                 or -n numbers for zapping
          -t        : delivery system type DVB-S=0, DSS=1, DVB-S2=2


You see the last line? The Information is included!! ;-)
And Faruk is right, scan should find S2-Channels "out of the box".

Jens

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
