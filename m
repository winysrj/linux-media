Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:58961 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbZJ0QUx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 12:20:53 -0400
Received: by ewy4 with SMTP id 4so315801ewy.37
        for <linux-media@vger.kernel.org>; Tue, 27 Oct 2009 09:20:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8d0bb7650910270755v38f37f6fh3937e9727493854c@mail.gmail.com>
References: <8d0bb7650910261544i4ebed975rf81ec6bc38076927@mail.gmail.com>
	 <a413d4880910261623x44d106f4h167a7dab80a4a3f8@mail.gmail.com>
	 <83bcf6340910270717n12066fb8oa4870eb3214d7597@mail.gmail.com>
	 <8d0bb7650910270755v38f37f6fh3937e9727493854c@mail.gmail.com>
Date: Tue, 27 Oct 2009 12:20:56 -0400
Message-ID: <83bcf6340910270920i4323faf8mb5b482b75bda7291@mail.gmail.com>
Subject: Re: Hauppage HVR-2250 Tuning problems
From: Steven Toth <stoth@kernellabs.com>
To: dan <danwalkeriv@gmail.com>
Cc: Another Sillyname <anothersname@googlemail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 27, 2009 at 10:55 AM, dan <danwalkeriv@gmail.com> wrote:
> Steve,
>
> Thanks for responding.  I created the channels.conf file and ran the
> azap command you suggested.  In both cases I get something that looks
> like this:
>
> $ azap -r c112
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 723000000 Hz
> video pid 0x0120, audio pid 0x0121
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 1f | signal 0172 | snr 0172 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS_LOCK

Are you amping up or splitting the signal in any way? If so, for test
purposes remove anything that can degrade or improve RF. It looks like
the tuner gets into lock briefly but falls out, implying abnormal RF
conditions. When it locks you have perfect SNR, kind of implying that
the signal may be too strong.

Additionally, for all your testing, repeat the tests on tuner#2 by
azap -a1 -r c112.

Additionally, try channel 83 or edit the conf file and add some lower
channels in the 40-80 range where the RF characteristics would be
wildly different. I'd like to see how the card performs in these
circumstances for you.

Regards,

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
