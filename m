Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42260 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbaLaCLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Dec 2014 21:11:40 -0500
Date: Wed, 31 Dec 2014 00:11:34 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David Liontooth <lionteeth@cogweb.net>
Cc: Olli Salonen <olli.salonen@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: dvbv5-scan needs which channel file?
Message-ID: <20141231001134.64c38344@concha.lan>
In-Reply-To: <54A2C971.6090807@cogweb.net>
References: <54A1B4FD.70006@cogweb.net>
	<CAAZRmGxoOTf9f4gq05RgbcD44tmiySMXo-_ZHtBQX0pw6ZXPUA@mail.gmail.com>
	<54A26109.1040109@cogweb.net>
	<CAAZRmGz1Xp9bL+R-sMsHpeuwAJ4aR=Dhu2Hwo-wAqbbFkr1B9w@mail.gmail.com>
	<54A2C971.6090807@cogweb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

Em Tue, 30 Dec 2014 07:49:05 -0800
David Liontooth <lionteeth@cogweb.net> escreveu:

> 
> OK, perfect; thank you. This should be documented in dvbv5-scan. And we 
> should have a man page for it.

This is documented, and there is a man page for it:

dvbv5-scan(1)                    User Commands                   dvbv5-scan(1)



NAME
       dvbv5-scan - DVBv5 tool for frequency scanning

SYNOPSIS
       dvbv5-scan [OPTION]... initial-file

DESCRIPTION
       dvbv5-scan  is  a  command  line frequency scanning tool for digital TV
       services that is compliant with version 5 of the DVB API, and  backward
       compatible with the older v3 DVB API.

       dvbv5-scan  uses by default the new channel/service file format that it
       is capable of supporting all types of Digital TV standards. It can also
       support the legacy format used by the legacy dvb-apps.

       A single physical channel (also called as transponder) may have several
       virtual channels inside it, encapsulated via a MPEG Transport stream.

       Those virtual channels are called as 'service' at the MPEG-TS terminol‐
       ogy,  and may have one or more audio, video and other types of elements
       inside it.

       The  dvbv5-scan  goal  is  to  scan  for  a  list  of  physical   chan‐
       nels/transponders and identify there the MPEG-TS services available.

       The  dvbv5-scan tool is smart enough to retrieve the information at the
       MPEG-TS Network Information Table (NIT) about other channels  available
       on the stream.

OPTIONS
       The following options are valid:

       -3, --dvbv3
              Force dvbv5-scan to use DVBv3 only.

       -a, --adapter=adapter#
              Use the given adapter. Default value: 0.

       -d, --demux=demux#
              Use the given demux. Default value: 0.

       -f, --frontend=frontend#
              Use the given frontend. Default value: 0.

       -F, --file-freqs-only
              Don't  use  the  other  frequencies  discovered  during scan. By
              default, dvbv5-scan will find new transponder/physical  channels
              and  add  them at the internal frequency table it uses for scan.
              This option disables such feature.

       -G, --get_frontend
              Use data from get_frontend  on  the  output  file.  By  default,
              dvbv5-scan  will  repeat the same network parameters as found at
              the scan file. This should work fine if the output file will  be
              used  by  the  same  frontend. However, if you intend to use the
              generated file on another frontend, or  wants  a  faster  tuner,
              this option can be used to store the actual detected parameters,
              instead of the ones that came from the source channel file.

       -I, --input-format=format
              Format of the input file. Please notice that caps is ignored. It
              can be:

              channel         - for dvb-apps compatible channel file;

              zap             - for dvb-apps compatible zap file;

              dvbv5 (default) - for the dvbv5 apps format.

       -l, --lnbf=LNBf_type
              Type of LNBf to use 'help' lists the available ones.

       -N, --nit
              Use  data  from  NIT  table  on  the  output  file.  By default,
              dvbv5-scan will repeat the same network parameters as  found  at
              the  scan file. This should work fine if the output file will be
              used by the same frontend. However, if you  intend  to  use  the
              generated  file  on  another  frontend, or wants a faster tuner,
              this option can  be  used  to  store  the  parameters  that  are
              announced by the broadcaster via the MPEG-TS Network Information
              Table (NIT), instead of the ones that came from the source chan‐
              nel file.

       -o, --output=file
              output filename (default: dvb_channel.conf)

       -O, --output-format=format
              Output format:

              channel         - for dvb-apps compatible channel file;

              zap             - for dvb-apps compatible zap file;

              vdr             - for vdr compatible zap file;

              dvbv5 (default) - for the dvbv5 apps format.

       -p, --parse-other-nit
              Parse  the  other  NIT/SDT  tables that could be found mainly on
              some DVB-C carriers.

       -S, --sat_number=satellite_number
              Satellite number.  Used only on satellite delivery systems.   If
              not specified, disable DISEqC satellite switch.

       -T, --timeout-multiply=factor
              Multiply  the  scan  lock wait time and MPEG-TS table parsing by
              this factor.

       -U, --freq_bpf=frequency
              SCR/Unicable band-pass filter frequency to use,  in  kHz.   Used
              only on satellite delivery systems.

       -v, --verbose
              Be  (very) verbose. Useful to check if the MPEG-TS is happenning
              fine.  This option can be used multiple times to  increase  ver‐
              bosity.

       -w, --lna=LNA
              Enable, disable or put LNA power in auto mode. Not all frontends
              support it.  Valid values are:

               0 - disable

               1 - enable

              -1 - auto

       -W, --wait=time
              Adds additional wait time for DISEqC command completion.

       -?, --help
              Outputs the usage help.

       --usage
              Gives a short usage message.

       -V, --version
              Prints the program version.

       Mandatory or optional arguments to long options are also  mandatory  or
       optional for any corresponding short options.

   NOTE
       If both --nit and --get_frontend options are used at the same time, the
       --nit parameters will be applied  after  the  ones  that  the  frontend
       detected.

EXIT STATUS
       On success, it returns 0.

EXAMPLE
       $ dvbv5-scan /usr/share/dvbv5/dvb-c/the-brownfox

       Scanning frequency #1 573000000
       Lock   (0x1f) Quality= Good Signal= 100.00% C/N= -13.80dB UCB= 0 postBER= 3.14x10^-3 PER= 0
       Service The, provider (null): digital television
       Service Quick, provider BrownFox: digital television
       Service Brown, provider (null): digital television
       Service Jumps, provider (null): digital television
       …
       Service Dog, provider (null): digital television
       New transponder/channel found: #2: 579000000
       …
       New transponder/channel found: #39: 507000000

       The  scan  process will then scan the other 38 discovered new transpon‐
       ders, and generate a dvb_channel.com with  several  entries  with  will
       have  not only the physical channel/transponder info, but also the Ser‐
       vice ID, and the corresponding  audio/video/other  program  IDs  (PID),
       like:

       [Quick]
               SERVICE_ID = 5
               VIDEO_PID = 288
               AUDIO_PID = 289
               FREQUENCY = 573000000
               MODULATION = QAM/256
               INVERSION = OFF
               SYMBOL_RATE = 5247500
               INNER_FEC = NONE
               DELIVERY_SYSTEM = DVBC/ANNEX_A

BUGS
       Report bugs to Linux Media Mailing List <linux-media@vger.kernel.org>

COPYRIGHT
       Copyright (c) 2011-2014 by Mauro Carvalho Chehab.

       License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
       This  is  free  software:  you  are free to change and redistribute it.
       There is NO WARRANTY, to the extent permitted by law.



DVBv5 Utils 1.6.2               Fri Oct 3 2014                   dvbv5-scan(1)
