Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34370 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0GNAyg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jul 2010 20:54:36 -0400
Received: by iwn7 with SMTP id 7so6417787iwn.19
        for <linux-media@vger.kernel.org>; Tue, 13 Jul 2010 17:54:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <82429245-261C-49FF-962E-E768F66FB143@dons.net.au>
References: <AANLkTilzstvLDKE0VrXEw7awNLOLRVOyUpWpcf0B98HM@mail.gmail.com>
	<82429245-261C-49FF-962E-E768F66FB143@dons.net.au>
Date: Wed, 14 Jul 2010 10:54:35 +1000
Message-ID: <AANLkTilIUrBSvQXhPpMJOf4gqyztqy_OcGgfQYJ0IE2r@mail.gmail.com>
Subject: Re: Reception issue: DViCO Fusion HDTV DVB-T Dual Express
From: David Shirley <tephra@gmail.com>
To: "Daniel O'Connor" <darius@dons.net.au>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Daniel,

Can you tell me what kernel version you are using? Also are you using
vanilla kernel v4l or chris pascoes tree or the v4l tree for drivers?

So I take it you don't get any "audio blips" throughout the recording ?

Any chance of a longer TZAP run as well?

Thanks in advance!

Cheers
D.

On 13 July 2010 19:53, Daniel O'Connor <darius@dons.net.au> wrote:
>
> On 13/07/2010, at 17:24, David Shirley wrote:
>> I am having reception issues with this particular card, the problem
>> manifests itself with missing video frames and popping sounds on the
>> audio streams.
>>
>> As far as I can tell it only some channels do it, "Nine" and its
>> multiplexes are the worst for it
>
> I have the same card an It Works For Me (tm).
>
> However I had serious issues with mythtv when I upgraded recently, however mplayer seemed fine and it turned out to be a DB problem (I think it was a bit of voodoo getting it working..)
>>
>> You can see that TZAP every now and reports some unc/ber:
>>
>> crystal:/usr/share/dvb/dvb-t# tzap -a 0 -c 0 "Nine Digital HD"
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> reading channels from file '0'
>> tuning to 191625000 Hz
>> video pid 0x0200, audio pid 0x0000
>> status 00 | signal 0b28 | snr 0000 | ber 00000000 | unc 000012c8 |
>> status 1e | signal b64c | snr dede | ber 00000000 | unc 000013ce | FE_HAS_LOCK
>
>
> [mythtv 19:22] ~ >tzap -a 1 "Nine HD"
> using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
> reading channels from file '/home/myth/.tzap/channels.conf'
> tuning to 191625000 Hz
> video pid 0x0201, audio pid 0x0000
> status 00 | signal c520 | snr 0000 | ber 00000000 | unc 00003691 |
> status 1e | signal c4a8 | snr aaaa | ber 00000000 | unc 000036f0 | FE_HAS_LOCK
> status 1e | signal c4f0 | snr abab | ber 00000000 | unc 000036f0 | FE_HAS_LOCK
> status 1e | signal c4e4 | snr abab | ber 00000000 | unc 000036f0 | FE_HAS_LOCK
> status 1e | signal c4d8 | snr acac | ber 00000000 | unc 000036f0 | FE_HAS_LOCK
> status 1e | signal c50c | snr aaaa | ber 00000000 | unc 000036f0 | FE_HAS_LOCK
> status 1e | signal c4fc | snr abab | ber 00000792 | unc 000036f0 | FE_HAS_LOCK
> status 1e | signal c540 | snr acac | ber 00000792 | unc 000036f0 | FE_HAS_LOCK
>
>> Hopefully someone can help or give me instructions on how to debug...
>
> Dunno sorry :(
> However if you need some comparison stuff run let me know :)
>
> --
> Daniel O'Connor software and network engineer
> for Genesis Software - http://www.gsoft.com.au
> "The nice thing about standards is that there
> are so many of them to choose from."
>  -- Andrew Tanenbaum
> GPG Fingerprint - 5596 B766 97C0 0E94 4347 295E E593 DC20 7B3F CE8C
>
>
>
>
>
>
>
