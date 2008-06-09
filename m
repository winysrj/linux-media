Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay.chp.ru ([213.170.120.254] helo=ns.chp.ru)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1K5keR-00066d-Ou
	for linux-dvb@linuxtv.org; Mon, 09 Jun 2008 18:55:26 +0200
Received: from cherep2.ptl.ru (localhost.ptl.ru [127.0.0.1])
	by cherep.quantum.ru (Postfix) with SMTP id A68BA19E605F
	for <linux-dvb@linuxtv.org>; Mon,  9 Jun 2008 20:54:49 +0400 (MSD)
Received: from localhost.localdomain (hpool.chp.ptl.ru [213.170.123.250])
	by ns.chp.ru (Postfix) with ESMTP id E472019E6064
	for <linux-dvb@linuxtv.org>; Mon,  9 Jun 2008 20:54:48 +0400 (MSD)
Date: Mon, 9 Jun 2008 20:59:00 +0400
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Message-ID: <20080609205900.69768a02@bk.ru>
In-Reply-To: <484CD9F5.60906@okg-computer.de>
References: <854d46170806081250u3e7ca97er32d47be3ccf368fb@mail.gmail.com>
	<E1K5Z0d-000P20-00.goga777-bk-ru@f172.mail.ru>
	<484CD9F5.60906@okg-computer.de>
Mime-Version: 1.0
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

Hi

> >> I'm glad everything worked out for you :).
> >> with szap to tune to DVB-S2 channels use this option "-t 2" default is
> >> "- t 0" which is for DVB-S
> >> to tune to 'Astra HD Promo 2' you do:
> >> szap -r -c 19 -t 2 "Astra HD Promo 2"
> >>     
> >
> > I will try so. It will be fine if new dvb-s2 option will include in szap --help output
> >   
> 
> jens@midas-phalanx:/usr/src/dvb-apps-patched/util/szap# ./szap -h
> 
> usage: szap -q
>          list known channels
>        szap [options] {-n channel-number|channel_name}
>          zap to channel via number or full name (case insensitive)
>      -a number : use given adapter (default 0)
>      -f number : use given frontend (default 0)
>      -d number : use given demux (default 0)
>      -c file   : read channels list from 'file'
>      -b        : enable Audio Bypass (default no)
>      -x        : exit after tuning
>      -r        : set up /dev/dvb/adapterX/dvr0 for TS recording
>      -l lnb-type (DVB-S Only) (use -l help to print types) or
>      -l low[,high[,switch]] in Mhz
>      -i        : run interactively, allowing you to type in channel names
>      -p        : add pat and pmt to TS recording (implies -r)
>                  or -n numbers for zapping
>           -t        : delivery system type DVB-S=0, DSS=1, DVB-S2=2
> 
> 
> You see the last line? The Information is included!! ;-)

yes, I see. But in my patched szap I don't see this information. I don't know why :(

/usr/src/dvb-apps# cat patch_scan_szap_jens.diff | patch -p1 --dry-run

goga:/usr/src/dvb-apps# cat patch_scan_szap_jens.diff | patch -p1 --dry-run
patching file util/scan/atsc/us-ATSC-center-frequencies-8VSB
patching file util/scan/atsc/us-NTSC-center-frequencies-8VSB
patching file util/scan/atsc/us-NY-TWC-NYC
patching file util/scan/diseqc.c
patching file util/scan/diseqc.h
patching file util/scan/dump-vdr.c
patching file util/scan/dump-vdr.h
patching file util/scan/dump-zap.c
patching file util/scan/dump-zap.h
patching file util/scan/dvb-c/at-SalzburgAG
patching file util/scan/dvb-c/be-IN.DI-Integan
patching file util/scan/dvb-c/de-Muenchen
patching file util/scan/dvb-c/fi-3ktv

[skip]


patching file util/scan/dvb-t/uk-WinterHill
patching file util/scan/list.h
patching file util/scan/lnb.c
patching file util/scan/lnb.h
patching file util/scan/Makefile
patching file util/scan/scan.c
patching file util/scan/scan.h
patching file util/szap/szap.c

goga:/usr/src/dvb-apps/util/szap# make
CC lnb.o
CC azap
CC czap
CC szap
CC tzap


goga:/usr/src/dvb-apps/util/szap# ./szap -h

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
     -H        : human readable output
     -r        : set up /dev/dvb/adapterX/dvr0 for TS recording
     -l lnb-type (DVB-S Only) (use -l help to print types) or
     -l low[,high[,switch]] in Mhz
     -i        : run interactively, allowing you to type in channel names
     -p        : add pat and pmt to TS recording (implies -r)
                 or -n numbers for zapping

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
     -H        : human readable output
     -r        : set up /dev/dvb/adapterX/dvr0 for TS recording
     -l lnb-type (DVB-S Only) (use -l help to print types) or
     -l low[,high[,switch]] in Mhz
     -i        : run interactively, allowing you to type in channel names
     -p        : add pat and pmt to TS recording (implies -r)
                 or -n numbers for zapping

Goga777

> And Faruk is right, scan should find S2-Channels "out of the box".
> 
> Jens


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
