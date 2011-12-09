Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45234 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab1LIUFK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2011 15:05:10 -0500
Received: by bkbzv3 with SMTP id zv3so3291901bkb.19
        for <linux-media@vger.kernel.org>; Fri, 09 Dec 2011 12:05:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323457212-13507-1-git-send-email-mchehab@redhat.com>
References: <4EE252E5.2050204@iki.fi> <1323457212-13507-1-git-send-email-mchehab@redhat.com>
From: Eddi De Pieri <eddi@depieri.net>
Date: Fri, 9 Dec 2011 21:04:48 +0100
Message-ID: <CAKdnbx7s7vVPF9_uBb7w961d=keZ1F+ThdyhwFG396kcbE_M3Q@mail.gmail.com>
Subject: Re: [PATCHv2] [media] drxk: Switch the delivery system on FE_SET_PROPERTY
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
	Fredrik Lingvall <fredrik.lingvall@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> v2: Use mfe_shared

on hvr930c this patch solve the commutation issue of frontend.

still persist same issue like Fredrik on w_scan. scan still works perfectly...


root@depieri1lnx:~# w_scan -f t -c IT
w_scan version 20110616 (compiled for DVB API 5.3)
using settings for ITALY
DVB aerial
DVB-T Europe
frontend_type DVB-T, channellist 4
output format vdr-1.6
output charset 'UTF-8', use -C <charset> to override
Info: using DVB adapter auto detection.
	/dev/dvb/adapter0/frontend0 -> DVB-C "DRXK DVB-C": specified was
DVB-T -> SEARCH NEXT ONE.
	/dev/dvb/adapter0/frontend1 -> DVB-T "DRXK DVB-T": good :-)
Using DVB-T frontend (adapter /dev/dvb/adapter0/frontend1)
-_-_-_-_ Getting frontend capabilities-_-_-_-_
Using DVB API 5.4
frontend 'DRXK DVB-T' supports
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO
FEC_AUTO
FREQ (47.12MHz ... 865.00MHz)
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
Scanning 7MHz frequencies...
[...]
858000: (time: 03:10) (time: 03:13)

ERROR: Sorry - i couldn't get any working frequency/transponder
 Nothing to scan!!


this verbose mode seems interesting but I don't figure out why i get timeout.

177500: (time: 00:04) set_frontend: using DVB API 5.4
(time: 00:06) set_frontend: using DVB API 5.4
signal ok:
	QAM_AUTO f = 177500 kHz I999B7C999D999T999G999Y999
NIT (actual TS)
	new transponder:
	   (QAM_64   f = 1600000 kHz I999B8C34D0T8G16Y0)


Info: NIT(other) filter timeout
