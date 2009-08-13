Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:2664 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbZHMFpu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2009 01:45:50 -0400
Message-ID: <065bfdd86fae05f6c3aa55b03651979a.squirrel@webmail.xs4all.nl>
In-Reply-To: <!&!AAAAAAAAAAAYAAAAAAAAAMs7WpTkg9MRuRcAACHFyB/CgAAAEAAAACcjVxFMux1AotUWOp
 7nrWEBAAAAAA==@coolrose.fsnet.co.uk>
References: <!&!AAAAAAAAAAAYAAAAAAAAAMs7WpTkg9MRuRcAACHFyB/CgAAAEAAAAJQ52z3qEFtDsl72y5icHrgBAAAAAA==@coolrose.fsnet.co.uk>
    <f554f7485cc95254484c951ed52cb7ba.squirrel@webmail.xs4all.nl>
    <!&!AAAAAAAAAAAYAAAAAAAAAMs7WpTkg9MRuRcAACHFyB/CgAAAEAAAACcjVxFMux1AotUWOp7nrWEBAAAAAA==@coolrose.fsnet.co.uk>
Date: Thu, 13 Aug 2009 07:45:49 +0200
Subject: RE: [linux-dvb] TechnoTrend TT-connect S2-3650 CI
From: "Niels Wagenaar" <n.wagenaar@xs4all.nl>
To: "Christopher Thornley" <c.j.thornley@coolrose.fsnet.co.uk>
Cc: n.wagenaar@xs4all.nl, linux-media@vger.kernel.org
Reply-To: n.wagenaar@xs4all.nl
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op Do, 13 augustus, 2009 01:30, schreef Christopher Thornley:
> Hi,
> I have now successfully installed the S2API and s2-liplianin (Thank for
> the link Goga777)
>
> -- SNIP --
>
> I have tried to build (make) several versions of VDR from version 1.7.4 to
> 1.7.8 but I am receiving the following error message which I don't know
> what
> to do to resolve this :-
>
> system@Firefly:~/dvb/vdr-1.7.8$ make
> g++ -g -O2 -Wall -Woverloaded-virtual -Wno-parentheses -c -DREMOTE_KBD
> -DLIRC_DEVICE=\"/dev/lircd\" -DRCU_DEVICE=\"/dev/ttyS1\" -D_GNU_SOURCE
> -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE
> -DVIDEODIR=\"/video\" -DCONFDIR=\"/video\" -DPLUGINDIR=\"./PLUGINS/lib\"
> -DLOCDIR=\"./locale\" -I/usr/include/freetype2 dvbdevice.c
> dvbdevice.c: In constructor 'cDvbDevice::cDvbDevice(int)':
> dvbdevice.c:487: error: 'FE_CAN_2G_MODULATION' was not declared in this
> scope
> make: *** [dvbdevice.o] Error 1
> system@Firefly:~/dvb/vdr-1.7.8$
>

Edit Make.config in the VDR source directory and change the DVBDIR to the
following:

DVBDIR = /usr/local/src/s2-liplianin/linux

Change /usr/local/src/s2-liplianin to your location where you fetched
s2-liplianin. Also you need to do an additional command before you can
compile VDR. Go to the location where you have s2-liplianin (example: cd
/usr/local/src/s2-liplianin) and use the following commands:

cd linux/include/linux
ln -s /usr/src/linux-headers-`uname -r`/include/linux/compiler.h ./

Now go to the VDR source-folder. Do a make clean and do a make again. VDR
should now compile like it should :)

>
> Many Thanks
> Chris

If you have any problems at all, the best option is to join the VDR
mailinglist (vdr@linuxtv.org) since this mailinglist is for Linux media
and not for VDR ;).

Regards,

Niels Wagenaar

