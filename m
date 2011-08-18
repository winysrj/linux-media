Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43681 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab1HRPrd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 11:47:33 -0400
Received: by vxi9 with SMTP id 9so1825845vxi.19
        for <linux-media@vger.kernel.org>; Thu, 18 Aug 2011 08:47:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL9G6WUFyWuKJQnTBCW6StEfoWeKhXix3rFkU9eC8AxEbuD5Uw@mail.gmail.com>
References: <CAPz3gmkRoh_gXU4PtzVhXb=0BOBjcgmhK7CCCq5ioajfjHZg3A@mail.gmail.com>
	<CAL9G6WUFyWuKJQnTBCW6StEfoWeKhXix3rFkU9eC8AxEbuD5Uw@mail.gmail.com>
Date: Thu, 18 Aug 2011 17:47:32 +0200
Message-ID: <CAPz3gm=ABUESbFNjL+RJ6RHMCGW_a4T70h6A3GP4b_B2ves92w@mail.gmail.com>
Subject: Re: Record DVB-T from command line
From: shacky <shacky83@gmail.com>
To: Josu Lazkano <josu.lazkano@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> szap -a 0 -c channels_astra.conf -r "TV3 CAT"
> cat /dev/dvb/adapter0/dvr0 > testvideo.mpg
> mplayer testvideo.mpg

I tried that, but cat tells me that the device is busy:

root@werecit1:/opt/utils/tv# tzap -c /etc/channels.conf -r "Rai 1"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/etc/channels.conf'
tuning to 177500000 Hz
video pid 0x0200, audio pid 0x028a
status 00 | signal 1b1b | snr 000c | ber 0000ffff | unc 00000000 |
status 1f | signal fefe | snr 00f6 | ber 000000bd | unc 00000282 | FE_HAS_LOCK
[last line repeated several times]

In another console:

root@werecit1:~# cat /dev/dvb/adapter0/dvr0 > prova.mpg
cat: /dev/dvb/adapter0/dvr0: Dispositivo o risorsa occupata

Could you help me please?
