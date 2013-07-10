Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56077 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3GJNvC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jul 2013 09:51:02 -0400
Received: by mail-qc0-f174.google.com with SMTP id m15so3647110qcq.33
        for <linux-media@vger.kernel.org>; Wed, 10 Jul 2013 06:51:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <017801ce7d0e$73eeff60$5bccfe20$@blueflowamericas.com>
References: <010c01ce7365$9181ff30$b485fd90$@blueflowamericas.com>
	<CAGoCfiyjeqxVV8A_MM-iV58=s48FEhNPA=5MPg3WAOAKs8d2iA@mail.gmail.com>
	<011901ce73ab$9b81cce0$d28566a0$@blueflowamericas.com>
	<CALzAhNV7Cv9SR1C2mpgtLTwxD_grCZeOWc6O-2XpJEAKg1mX6w@mail.gmail.com>
	<017101ce7c5b$6899c860$39cd5920$@blueflowamericas.com>
	<CALzAhNVo0gi1HZ5TH9oXnUpgsqKa+YL=uGLvQNYxqj6gLd2upw@mail.gmail.com>
	<017801ce7d0e$73eeff60$5bccfe20$@blueflowamericas.com>
Date: Wed, 10 Jul 2013 09:51:00 -0400
Message-ID: <CALzAhNULmGJSXvGogBFV4KXFH4OBvSydbJQ_7PbAnMAmwByjjA@mail.gmail.com>
Subject: Re: lgdt3304
From: Steven Toth <stoth@kernellabs.com>
To: Carl-Fredrik Sundstrom <cf@blueflowamericas.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 9, 2013 at 9:40 PM, Carl-Fredrik Sundstrom
<cf@blueflowamericas.com> wrote:
>
> I don't have digital cable only over the air ATSC. No one else on this list
> has this card ?

You are very welcome, thank you.

We generally recommend Linux users purchase cards that are already
supported (or semi supported), such as the HVR2250. If you're keen
enough to tackle adding support for a new board then that's great
news, but very few people usually have experience with hardware not
yet supported.

The channels.conf is capable of support digital cable and ATSC, simply
change the modulation scheme and your target frequency and try again.

A quick google for an equivalent ATSC channels.conf provides a lot of
useful information.

Create your channels.conf to match your target frequencies in Hz and
use azap to debug.

Eg.

KPAX-CW:177028615:8VSB:65:68:2

>
> Thanks /// Carl
>
> -----Original Message-----
> From: linux-media-owner@vger.kernel.org
> [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Steven Toth
> Sent: Tuesday, July 09, 2013 9:54 AM
> To: Carl-Fredrik Sundstrom
> Cc: Devin Heitmueller; linux-media@vger.kernel.org
> Subject: Re: lgdt3304
>
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>>>> tune to: 57028615:8VSB
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 57028615:8VSB (tuning failed)
>
> I don't have a box in front of me but that's usually a sign that the
> frequency details you are passing in are bogus, so the tuner driver is
> rejecting it.
>
> Check your command line tuning tools and args.
>
> Here's a one line channels.conf for azap (US digital cable) that works fine,
> and the azap console output:
>
> ch86:597000000:QAM_256:0:0:101
>
> stoth@mythbackend:~/.azap$ azap ch86
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 597000000 Hz
> video pid 0x0000, audio pid 0x0000
> status 00 | signal 0000 | snr b770 | ber 00000000 | unc 00000000 | status 1f
> | signal 0154 | snr 0154 | ber 000000ad | unc 000000ad | FE_HAS_LOCK status
> 1f | signal 0156 | snr 0156 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
