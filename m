Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55033 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab3GKMqx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 08:46:53 -0400
Message-ID: <51DEA90D.8030309@iki.fi>
Date: Thu, 11 Jul 2013 15:46:05 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Carl-Fredrik Sundstrom <cf@blueflowamericas.com>
CC: 'Steven Toth' <stoth@kernellabs.com>,
	'Devin Heitmueller' <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: lgdt3304
References: <010c01ce7365$9181ff30$b485fd90$@blueflowamericas.com>	<CAGoCfiyjeqxVV8A_MM-iV58=s48FEhNPA=5MPg3WAOAKs8d2iA@mail.gmail.com>	<011901ce73ab$9b81cce0$d28566a0$@blueflowamericas.com>	<CALzAhNV7Cv9SR1C2mpgtLTwxD_grCZeOWc6O-2XpJEAKg1mX6w@mail.gmail.com>	<017101ce7c5b$6899c860$39cd5920$@blueflowamericas.com>	<CALzAhNVo0gi1HZ5TH9oXnUpgsqKa+YL=uGLvQNYxqj6gLd2upw@mail.gmail.com>	<017801ce7d0e$73eeff60$5bccfe20$@blueflowamericas.com> <CALzAhNULmGJSXvGogBFV4KXFH4OBvSydbJQ_7PbAnMAmwByjjA@mail.gmail.com> <019d01ce7de9$f620cdc0$e2626940$@blueflowamericas.com>
In-Reply-To: <019d01ce7de9$f620cdc0$e2626940$@blueflowamericas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Carl-Fredrik,

On 07/11/2013 06:51 AM, Carl-Fredrik Sundstrom wrote:
>
> Thanks Steven for all the support,
>
> Now I got the master slave to work and I can scan the local FOX channel with
> azap
>
> tridentsx@tridentsx-P5K-E:~/.kde/share/apps/kaffeine$ azap FOX
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 599028615 Hz
> video pid 0x0031, audio pid 0x0034
> status 01 | signal 0000 | snr 0000 | ber 00000000 | unc 0000ca8b |
> status 1f | signal 8e53 | snr 00c4 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal 907a | snr 00c5 | ber 00000000 | unc 00000165 |
> FE_HAS_LOCK
> status 1f | signal 8dc8 | snr 00c4 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal 8d3f | snr 00c1 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
>
> However when I try to view or scan channels in mplayer or kaffeine it can't
> find them and there
> are some timeouts Similar to the ones I got in scan utility.
>
> kaffeine(5476) DvbScanFilter::timerEvent: timeout while reading section;
> type = 3 pid = 8187
> kaffeine(5476) DvbScanFilter::timerEvent: timeout while reading section;
> type = 0 pid = 0
> kaffeine(5476) DvbScanFilter::timerEvent: timeout while reading section;
> type = 3 pid = 8187
>
> Playing dvb://.
> dvb_tune Freq: 599028615
> dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 2048 bytes
> dvb_streaming_read, attempt N. 5 failed with errno 0 when reading 2048 bytes
> dvb_streaming_read, attempt N. 4 failed with errno 0 when reading 2048 bytes
> dvb_streaming_read, attempt N. 3 failed with errno 0 when reading 2048 bytes
> dvb_streaming_read, attempt N. 2 failed with errno 0 when reading 2048 bytes
> dvb_streaming_read, attempt N. 1 failed with errno 0 when reading 2048 bytes
> dvb_streaming_read, return 0 bytes
> Failed to recognize file format.
>
> When I use the scan tool I get the following for every channel that I can
> get a lock on in azap
>
>>>> tune to: 473028615:8VSB
> WARNING: filter timeout pid 0x0000
> WARNING: filter timeout pid 0x1ffb
>
>
> Below is a kernel  trace at the same time. It seems the tuning is successful
> still no channels are output at the end of scan.

Your problem is somewhere between demod and bus interface. Tuner and 
demod are working as demod is able to gain lock. Interface between demod 
and bus interface - bridge - (USB, PCI) is transport stream (aka mpeg 
TS). There is two main wiring used, serial ts and parallel ts. Check 
that first. Both demod and bridge should be configured properly.

If TS interface it is correct then bug is somewhere in bridge settings.

regards
Antti


-- 
http://palosaari.fi/
