Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rpooser@gmail.com>) id 1JZdhw-0008QN-7D
	for linux-dvb@linuxtv.org; Thu, 13 Mar 2008 04:02:19 +0100
Received: by fg-out-1718.google.com with SMTP id 22so2563452fge.25
	for <linux-dvb@linuxtv.org>; Wed, 12 Mar 2008 20:02:12 -0700 (PDT)
Message-ID: <b5c3de730803122002t3dbe49d7j8150848b57cae514@mail.gmail.com>
Date: Wed, 12 Mar 2008 22:02:12 -0500
From: raphy <rpooser@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <b5c3de730803121851ifb30923tbb761ce1b2520119@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <b5c3de730803121851ifb30923tbb761ce1b2520119@mail.gmail.com>
Subject: Re: [linux-dvb] HVR-1250: detected ok but can't tune or get video
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

On Wed, Mar 12, 2008 at 8:51 PM, raphy <rpooser@gmail.com> wrote:
> Hi all,
>  A while back I reported I was having problems with compiling drivers
>  for a HVR-1250.
>  I got the drivers compiled recently using the latest source from
>  v4l-dvb. I saw that cx23885 loaded and detected the card ok, so I
>  tried watching video in mythtv, to no avail. I then tried dumping
>  /dev/dvb/adaptor0/dvr0 to a file and got something 0KB in size. Also
>  using azap, I don't get a lock...
>
>  But the card seems to be loading drivers ok.
>  the output of "dmesg |grep cx" gives the following:
>  [ 1230.386126] cx23885 driver version 0.0.1 loaded
>  [ 1230.386186] CORE cx23885[0]: subsystem: 0070:7911, board: Hauppauge
>  WinTV-HVR1250 [card=3,autodetected]
>  [ 1230.487835] cx23885[0]: i2c bus 0 registered
>  [ 1230.487852] cx23885[0]: i2c bus 1 registered
>  [ 1230.487863] cx23885[0]: i2c bus 2 registered
>  [ 1230.514568] cx23885[0]: warning: unknown hauppauge model #0
>  [ 1230.514569] cx23885[0]: hauppauge eeprom: model=0
>  [ 1230.514571] cx23885[0]: cx23885 based dvb card
>  [ 1230.575799] DVB: registering new adapter (cx23885[0])
>  [ 1230.575944] cx23885_dev_checkrevision() Hardware revision = 0xb0
>  [ 1230.575950] cx23885[0]/0: found at 0000:03:00.0, rev: 2, irq: 17,
>  latency: 0, mmio: 0xfd000000
>
>  So It looks like the card should be working. However, the output of azap shows:
>  using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>  tuning to 677028615 Hz
>  video pid 0x0031, audio pid 0x0034
>  status 00 | signal 0082 | snr 0087 | ber 00000000 | unc 00000000 |
>  status 00 | signal 0087 | snr 0087 | ber 00000000 | unc 00000000 |
>  status 00 | signal 007d | snr 007d | ber 00000000 | unc 00000000 |
>  status 00 | signal 0082 | snr 0082 | ber 00000000 | unc 00000000 |
>  status 00 | signal 0087 | snr 0087 | ber 00000000 | unc 00000000 |
>  status 00 | signal 0082 | snr 0082 | ber 00000000 | unc 00000000 |
>
>  and so on. I never get FE_HAS_LOCK, which seems to mean that my tuner
>  can't actually change channels or tune a particular one...?
>  The next thing I tried was upgrading my kernel to 2.6.24, because I
>  read that the HVR-1250 is supported in this kernel. However, still no
>  luck, and I get the same output of azap and can't seem to watch TV.
>
>  I'm stumped at this point, can anyone see what I'm doing wrong?
>
>  Cheers,
>  Raphael
>

Ok, scratch that.... It looks like I forgot that the included antenna
with this card is a total piece of junk. Everything was working fine;
I just needed to replace the antenna with one that came with a usb
tuner and suddenly I could lock and view TV, etc. I should have known
better on this one.
Cheers,
Raphael

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
