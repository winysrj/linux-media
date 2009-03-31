Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:39651 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263AbZCaQ5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 12:57:36 -0400
Received: by rv-out-0506.google.com with SMTP id f9so3120481rvb.1
        for <linux-media@vger.kernel.org>; Tue, 31 Mar 2009 09:57:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <412bdbff0903301447k6bd27643s7188c17e3ca2798e@mail.gmail.com>
References: <3731df090903301437k49c310bbha71946ab14c0d6c9@mail.gmail.com>
	 <412bdbff0903301447k6bd27643s7188c17e3ca2798e@mail.gmail.com>
Date: Tue, 31 Mar 2009 09:57:34 -0700
Message-ID: <3731df090903310957v119c97e9vbca96d1293d3aef8@mail.gmail.com>
Subject: Re: Correct signal strength and SNR output for DViCO FusionHDTV7 Dual
	Express?
From: Dave Johansen <davejohansen@gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 30, 2009 at 2:47 PM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> On Mon, Mar 30, 2009 at 5:37 PM, Dave Johansen <davejohansen@gmail.com> wrote:
>> I am trying to get a MythTV setup working with a DViCO FusionHDTV7
>> Dual Express using Mythbuntu 8.10 and I have been able to generate a
>> channels.conf file using the latest v4l-dvb source code and the scan
>> utility that comes with the dvb-utils in Mythbuntu (the dvbscan
>> utility in latest dvb-apps source code give me the error "Unable to
>> query frontend status"). I am also able to watch channels using
>> mplayer, but the the problem is that MythTV does not identify any
>> channels. I am able to watch channels using MythTV, but I have to
>> manually enter the channel data since the tuning is not working.
>>
>> The belief is that the signal strength and SNR output must be
>> incorrect and that is causing the problem with MythTV. I would like to
>> help get this fixed, so others don't have the problems that I have run
>> into, so what can I do to help get the signal strength and SNR outputs
>> working?
>>
>> If it's helpful, I have attached an example output using azap with one
>> of the channels that I can watch with mplayer:
>>
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> tuning to 503028615 Hz
>> video pid 0x0011, audio pid 0x0014
>> status 01 | signal e000 | snr e450 | ber 00000000 | unc 00000000 |
>> status 1f | signal 00ff | snr 00ff | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status 1f | signal 00ff | snr 00ff | ber 00000ab7 | unc 00000ab7 | FE_HAS_LOCK
>> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>>
>> Thanks,
>> Dave
>
> Hello Dave,
>
> There has been an ongoing discussion about the representation of SNR
> and strength to applications such as MythTV.  Currently it is very
> inconsistent across drivers.
>
> To my knowledge, MythTV does not rely on either of these fields during
> its scanning.  It relies entirely on the FE_HAS_LOCK to make it's
> determination.
>
> You should probably see what additional logging capabilities are
> available in MythTV.
>
> Also, you might want to see if you can change the lock timeout in your
> application, as some applications may have the interval set to a value
> too short, which results in it timing out before the lock is acquired.
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
>

So, I tried upping the tuning timeout and MythTV under Mythbuntu 8.10
was able to find 1 of the channels (I can find 19 using scan and
azap).

I then downloaded the Mythbuntu 9.04 beta and got a new antenna. The
driver worked out of the box so I didn't need to download/compile the
latest v4l-dvb drivers, and it was able to get all 19 channels in
MythTV (it took 3 or 4 scans to finally get them all). I realize that
that wasn't the most scientific approach, so I will re-try with the
old antenna and see if it was the antenna or the software upgrade that
did the trick.

I also tried cranking the tuning timeout up to 15 seconds and it still
couldn't find all of the channels during every scan. Is that something
that I need to look into from a MythTV perspective? Or is there
something wrong with v4l-dvb that's causing that?

Dave
