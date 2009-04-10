Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:11533 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbZDJUk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2009 16:40:56 -0400
Received: by yx-out-2324.google.com with SMTP id 31so1278264yxl.1
        for <linux-media@vger.kernel.org>; Fri, 10 Apr 2009 13:40:55 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 Apr 2009 22:40:54 +0200
Message-ID: <621110570904101340y3d342cc8r4f3b2cb80ffbbc70@mail.gmail.com>
Subject: Re: SkyStar HD2 (TwinHan VP-1041) S2API/multiproto issues
From: Dave Lister <foceni@gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/4/10 Markus Rechberger <mrechberger@gmail.com>:
> On Fri, Apr 10, 2009 at 1:30 PM, Dave Lister <foceni@gmail.com> wrote:
>> ...
>> Drivers tried: http://jusst.de/hg/multiproto,
>> http://jusst.de/hg/mantis (couldn't make it compile)
>
> hmm this seems to work fine with linux 2.6.27 maybe try to downgrade
> your kernel?
>

Thank you for the tip! I presume you mean the
http://jusst.de/hg/mantis driver. When I was trying mantis tree with
kernels 2.6.26 & 2.6.29 yesterday, I got this compilation error in
both cases (mentioning for archival purposes, to help others):

In file included from /n/data/src/mantis/v4l/tuner-xc2028.h:10,
                from /n/data/src/mantis/v4l/tuner-xc2028.c:21:
./v4l/dvb_frontend.h:52: error: field 'fe_params' has incomplete type
./v4l/dvb_frontend.h:297: warning: 'struct dvbfe_info' declared inside
parameter list
./v4l/dvb_frontend.h:299: warning: 'enum dvbfe_delsys' declared inside
parameter list
./v4l/dvb_frontend.h:316: error: field 'fe_events' has incomplete type
./v4l/dvb_frontend.h:317: error: field 'fe_params' has incomplete type
./v4l/dvb_frontend.h:354: warning: 'enum dvbfe_fec' declared inside
parameter list
./v4l/dvb_frontend.h:354: warning: 'enum dvbfe_modulation' declared
inside parameter list
make[3]: *** [./v4l/tuner-xc2028.o] Error 1


Now, trying again (and harder) as you suggested, I realized my
kernel's V4L headers (linux/dvb/frontend.h, etc) were taking
precedence over mantis tree. I "fixed" it (just moved conflicting
headers), but still ended up with the same fatal error as yesterday -
struct net_device doesn't have a member called "priv". Turns out this
incompatibility was introduced somewhere between 2.6.28-29. Debian
2.6.26 kernel worked fine this time and the driver compiled!

Thanks to your heads up, I can finally scan and zap channels! :) There
are still some issues, though. Perhaps you or somebody else will be
able to help me. I tried several versions of dvb-apps/utils (deb,
http://linuxtv.org/hg/dvb-apps, s2-liplianin,
http://jusst.de/manu/scan.tar.bz2) and the only one working is the
Debian package. This means, however, that I cannot use DVB-S2. To make
it short:

1) Where do I get working S2-enabled dvb-apps for the mantis tree?
2) Zapping and scanning is _extremely_ slow - szap takes about 30
seconds to lock on any channel. Is it normal?
3) DiSEqC is not working with the standard packaged dvb-apps (-s 0, -s
1). Is DiSEqC supported at all?
4) I'm using trunk MythTV and compiled it yesterday against
liplianin-s2. Do I need any patches (b/c of mantis driver) or will
clean recompilation work (considering S2, etc)?

I'll welcome any suggestions that might point me in the right direction.

Thank you,
--
David Lister
