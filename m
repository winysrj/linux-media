Return-path: <mchehab@gaivota>
Received: from lo.gmane.org ([80.91.229.12]:60364 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab1EKSfJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 14:35:09 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QKEFW-0002tF-VM
	for linux-media@vger.kernel.org; Wed, 11 May 2011 20:35:06 +0200
Received: from nemi.mork.no ([148.122.252.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 11 May 2011 20:35:06 +0200
Received: from bjorn by nemi.mork.no with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 11 May 2011 20:35:06 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: dvb-core/dvb_frontend.c: Synchronizing legacy and new tuning API
Date: Wed, 11 May 2011 20:34:52 +0200
Message-ID: <87sjslaxwz.fsf@nemi.mork.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

I see in drivers/media/dvb/dvb-core/dvb_frontend.c that there is some
synchronization between the old and the new API.

But it is incomplete: The new FE_GET_PROPERTY will report only cached
values, which is whatever the application has written and not the
actual tuned values like FE_GET_FRONTEND will.  The problem is that 
FE_GET_PROPERTY only will call fe->ops.get_property even for legacy
drivers.  It could have fallen back to calling fe->ops.get_frontend
followed by a cache synchronization.

Is this difference intentional (because it costs too much, doesn't
matter, or whatever)?  Or should I prepare a patch for dvb_frontend.c?


I made a small util comparing the two APIs, basically just doing

       fd = open("/dev/dvb/adapter0/frontend0",  O_RDONLY);
       ioctl(fd, FE_GET_INFO, &fe_info);
       ioctl(fd, FE_GET_FRONTEND, &fe_param);
       ioctl(fd, FE_GET_PROPERTY, &dtv_props);
       close(fd);

and pretty-printing some of the results from the three ioctl()s.  It
reports typically something like this:

bjorn@canardo:~$ /tmp/dvb_fe_test /dev/dvb/adapter1/frontend0
== /dev/dvb/adapter1/frontend0 ==
name: Philips TDA10023 DVB-C
type: FE_QAM

== FE_GET_FRONTEND ==
frequency     : 394013477
inversion     : off (0)
symbol_rate   : 6900000
fec_inner     : FEC_NONE (0)
modulation    : QAM_256 (5)

== FE_GET_PROPERTY ==
[17] DTV_DELIVERY_SYSTEM : SYS_DVBC_ANNEX_AC (1)
[03] DTV_FREQUENCY       : 394000000
[06] DTV_INVERSION       : auto (2)
[08] DTV_SYMBOL_RATE     : 6900000
[09] DTV_INNER_FEC       : FEC_AUTO (9)
[04] DTV_MODULATION      : QAM_256 (5)
[35] DTV_API_VERSION     : 5.1
[05] DTV_BANDWIDTH_HZ    : BANDWIDTH_AUTO (3)



Notice how FE_GET_PROPERTY returns "auto" settings for inversion and
inner_fec, while FE_GET_FRONTEND reports the actual values currently set
in the tuner.  Also notice how the frequency differs.

It's not a big issue I believe, but I do find this a bit confusing as
two different apps using different APIs will report different settings.



Bjørn

