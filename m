Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:41626 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758572Ab3HOQQZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Aug 2013 12:16:25 -0400
Received: by mail-ie0-f181.google.com with SMTP id x14so1441678ief.26
        for <linux-media@vger.kernel.org>; Thu, 15 Aug 2013 09:16:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+DZWWXd3iTRyJcPVfbqMVsxZQ+jPkrdhm9zzd2wgck71tMhvA@mail.gmail.com>
References: <CA+DZWWXd3iTRyJcPVfbqMVsxZQ+jPkrdhm9zzd2wgck71tMhvA@mail.gmail.com>
Date: Thu, 15 Aug 2013 17:16:24 +0100
Message-ID: <CA+DZWWW5rqywL0E4PgXQZcgX5r7iW10jJuiQFF5quc=ZLKfBkw@mail.gmail.com>
Subject: Fwd: scan reports wrong polarization for some multiplexes
From: Tomi Mikkonen <tomi@soundmouse.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Package: dvb-apps
  Version: Today's (15/08/2013) from mercurial

The output of scan reports wrong polarization for some channels. See
the example below for LBC News.

 ./scan -a 2 dvb-s/Astra-28.2E >out.txt

~/dvb-apps/util/scan$ grep LBC out.txt
LBC 97.3:11223:v:0:27500:0:2312:52029
LBC News:11223:v:0:27500:0:2313:52031

On the screen (stderr), it finds polarization correctly (h) :

>>> tune to: 11222:h:0:27500
DVB-S IF freq is 1472170
0x0907 0xcb2a: pmt_pid 0x0000 BSkyB -- Summer Hits TV (running)
0x0907 0xcb2d: pmt_pid 0x0000 BSkyB -- Chat Box (running)
0x0907 0xcb2e: pmt_pid 0x0000 BSkyB -- BT Sport 1 (running)
0x0907 0xcb3c: pmt_pid 0x0000 BSkyB -- BFBS Radio (running)
0x0907 0xcb3d: pmt_pid 0x0000 BSkyB -- LBC 97.3 (running)
0x0907 0xcb3e: pmt_pid 0x0000 BSkyB -- Heart (running)
0x0907 0xcb3f: pmt_pid 0x0000 BSkyB -- LBC News (running)
0x0907 0xcb48: pmt_pid 0x0000 BSkyB -- SportxxxGirls (running)
0x0907 0xcb52: pmt_pid 0x0000 BSkyB -- Northern Birds (running)
0x0907 0xcb58: pmt_pid 0x0000 BSkyB -- Controversial tv (running)
0x0907 0xcb5c: pmt_pid 0x0106 BSkyB -- Heat (running)
0x0907 0xcb61: pmt_pid 0x010f BSkyB -- Magic (running)
0x0907 0xcb66: pmt_pid 0x0100 BSkyB -- Klear TV (running)
0x0907 0xcb70: pmt_pid 0x0109 BSkyB -- Extreme Sports (running, scrambled)
0x0907 0xcb75: pmt_pid 0x0110 BSkyB -- Muslim World (running)
0x0907 0xcb21: pmt_pid 0x0108 BSkyB -- UCB TV (running)
0x0907 0xcb22: pmt_pid 0x0107 BSkyB -- horror ch+1 (running)
0x0907 0xcb24: pmt_pid 0x010d BSkyB -- Ummah TV (running)
0x0907 0xcb25: pmt_pid 0x010b BSkyB -- Sony TV (running)
0x0907 0xcb26: pmt_pid 0x0122 BSkyB -- Jewelry Maker (running)
0x0907 0xcb27: pmt_pid 0x0102 BSkyB -- CBS Action (running)
0x0907 0xcb28: pmt_pid 0x0101 BSkyB -- Get Lucky TV (running)
WARNING: filter timeout pid 0x0105
Network Name 'ASTRA'
Network Name 'ASTRA'
>>> tune to: 11223:v:0:27500
DVB-S IF freq is 1473670
0x0000 0xcf7e: pmt_pid 0x0106 BSkyB -- Jeem.TV (running)
0x0000 0xcf9b: pmt_pid 0x0112 BSkyB -- NHK World HD (running)
0x0000 0xcf9c: pmt_pid 0x0103 BSkyB -- RT HD (running)
0x0000 0xcf9d: pmt_pid 0x0100 BSkyB -- ARISE News HD (running)
Network Name 'ASTRA'
Network Name 'ASTRA'

I suspect close frequencies are mixed somehow even when polarization
is different.

I'm using 3.5.0-37-generic in Ubuntu 12.04.2 LTS server. The tuner
card is TBS-6984.
