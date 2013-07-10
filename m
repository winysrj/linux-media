Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-auth.no-ip.com ([8.23.224.61]:31261 "EHLO
	out.smtp-auth.no-ip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752372Ab3GJBlB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jul 2013 21:41:01 -0400
From: "Carl-Fredrik Sundstrom" <cf@blueflowamericas.com>
To: "'Steven Toth'" <stoth@kernellabs.com>
Cc: "'Devin Heitmueller'" <dheitmueller@kernellabs.com>,
	<linux-media@vger.kernel.org>
References: <010c01ce7365$9181ff30$b485fd90$@blueflowamericas.com>	<CAGoCfiyjeqxVV8A_MM-iV58=s48FEhNPA=5MPg3WAOAKs8d2iA@mail.gmail.com>	<011901ce73ab$9b81cce0$d28566a0$@blueflowamericas.com>	<CALzAhNV7Cv9SR1C2mpgtLTwxD_grCZeOWc6O-2XpJEAKg1mX6w@mail.gmail.com>	<017101ce7c5b$6899c860$39cd5920$@blueflowamericas.com> <CALzAhNVo0gi1HZ5TH9oXnUpgsqKa+YL=uGLvQNYxqj6gLd2upw@mail.gmail.com>
In-Reply-To: <CALzAhNVo0gi1HZ5TH9oXnUpgsqKa+YL=uGLvQNYxqj6gLd2upw@mail.gmail.com>
Subject: RE: lgdt3304
Date: Tue, 9 Jul 2013 20:40:26 -0500
Message-ID: <017801ce7d0e$73eeff60$5bccfe20$@blueflowamericas.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I don't have digital cable only over the air ATSC. No one else on this list
has this card ?

Thanks /// Carl

-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Steven Toth
Sent: Tuesday, July 09, 2013 9:54 AM
To: Carl-Fredrik Sundstrom
Cc: Devin Heitmueller; linux-media@vger.kernel.org
Subject: Re: lgdt3304

> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>>> tune to: 57028615:8VSB
> WARNING: >>> tuning failed!!!
>>>> tune to: 57028615:8VSB (tuning failed)

I don't have a box in front of me but that's usually a sign that the
frequency details you are passing in are bogus, so the tuner driver is
rejecting it.

Check your command line tuning tools and args.

Here's a one line channels.conf for azap (US digital cable) that works fine,
and the azap console output:

ch86:597000000:QAM_256:0:0:101

stoth@mythbackend:~/.azap$ azap ch86
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 597000000 Hz
video pid 0x0000, audio pid 0x0000
status 00 | signal 0000 | snr b770 | ber 00000000 | unc 00000000 | status 1f
| signal 0154 | snr 0154 | ber 000000ad | unc 000000ad | FE_HAS_LOCK status
1f | signal 0156 | snr 0156 | ber 00000000 | unc 00000000 | FE_HAS_LOCK

--
Steven Toth - Kernel Labs
http://www.kernellabs.com
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

