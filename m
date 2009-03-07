Return-path: <linux-media-owner@vger.kernel.org>
Received: from nat-warsl417-02.aon.at ([195.3.96.120]:1948 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754008AbZCGSTa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2009 13:19:30 -0500
Received: from smarthub94.highway.telekom.at (HELO email.aon.at) ([172.18.5.236])
          (envelope-sender <estellnb@yahoo.de>)
          by fallback43.highway.telekom.at (qmail-ldap-1.03) with SMTP
          for <linux-media@vger.kernel.org>; 7 Mar 2009 18:19:26 -0000
Received: from 93-82-75-144.adsl.highway.telekom.at (HELO [10.0.0.7]) ([93.82.75.144])
          (envelope-sender <estellnb@yahoo.de>)
          by smarthub94.highway.telekom.at (qmail-ldap-1.03) with SMTP
          for <linux-media@vger.kernel.org>; 7 Mar 2009 18:19:24 -0000
Message-ID: <49B2BAAE.8040808@yahoo.de>
Date: Sat, 07 Mar 2009 19:19:26 +0100
From: Elmar Stellnberger <estellnb@yahoo.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Technisat Skystar 2 on Suse Linux 11.1, kernel 2.6.27.19-3.2-default
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Following the instructions at
http://www.linuxtv.org/wiki/index.php/TechniSat_SkyStar_2_TV_PCI_/_Sky2PC_PCI
I have tried to make my Technisat Skystar 2 work.

The thing is that suse ships most of the required kernel modules out of
the box; iter sunt
stv0299
mt312
budget
Only skystar2 is missing, so that I have no /dev/video0 and no
/dev/dvb/adapter0/video0 as required by all these dvb players.
> > ls /dev/dvb/adapter0/
demux0  dvr0  frontend0  net0

  Now I have tried to compile the patched drivers from
http://linuxtv.org/hg/v4l-dvb.
If I try to make everything in v4l-dvb as described at
http://forum.ubuntuusers.de/topic/treiber-fuer-dvb-karte-technisat-skystar2-rev/,

make returns with the following error message:

/home/elm/4thattempt/v4l-dvb-0276304b76b9/v4l/cxusb.c: In function
'bluebird_patch_dvico_firmware_download':
/home/elm/4thattempt/v4l-dvb-0276304b76b9/v4l/cxusb.c:795: error:
assignment of read-only location '*(fw->data + ((unsigned int)id
                                       off + 2u))'
/home/elm/4thattempt/v4l-dvb-0276304b76b9/v4l/cxusb.c:797: error:
assignment of read-only location '*(fw->data + ((unsigned int)id
                                       off + 3u))'

Fetching the elder sources from
http://linuxtv.org/hg/v4l-dvb/archive/0276304b76b9.tar.bz2
and retrying results in exactly the same error.

Consequently I have tried to uncheck everything but
Multimedia devices ->
  DVB for Linux
  Load and attach frontend and tuner driver modules as needes
  DVB/ATSC adapters
    Technisat 1.
    Technisat 2.
    Technisat 3.

Then it compiles without any error message, but no skystar2.ko
will be created. However this seems to be the only missing kernel module.




