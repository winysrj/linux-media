Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f49.google.com ([209.85.128.49]:49264 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab3GIOxp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jul 2013 10:53:45 -0400
Received: by mail-qe0-f49.google.com with SMTP id cz11so3019505qeb.8
        for <linux-media@vger.kernel.org>; Tue, 09 Jul 2013 07:53:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <017101ce7c5b$6899c860$39cd5920$@blueflowamericas.com>
References: <010c01ce7365$9181ff30$b485fd90$@blueflowamericas.com>
	<CAGoCfiyjeqxVV8A_MM-iV58=s48FEhNPA=5MPg3WAOAKs8d2iA@mail.gmail.com>
	<011901ce73ab$9b81cce0$d28566a0$@blueflowamericas.com>
	<CALzAhNV7Cv9SR1C2mpgtLTwxD_grCZeOWc6O-2XpJEAKg1mX6w@mail.gmail.com>
	<017101ce7c5b$6899c860$39cd5920$@blueflowamericas.com>
Date: Tue, 9 Jul 2013 10:53:43 -0400
Message-ID: <CALzAhNVo0gi1HZ5TH9oXnUpgsqKa+YL=uGLvQNYxqj6gLd2upw@mail.gmail.com>
Subject: Re: lgdt3304
From: Steven Toth <stoth@kernellabs.com>
To: Carl-Fredrik Sundstrom <cf@blueflowamericas.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>>> tune to: 57028615:8VSB
> WARNING: >>> tuning failed!!!
>>>> tune to: 57028615:8VSB (tuning failed)

I don't have a box in front of me but that's usually a sign that the
frequency details you are passing in are bogus, so the tuner driver is
rejecting it.

Check your command line tuning tools and args.

Here's a one line channels.conf for azap (US digital cable) that works
fine, and the azap console output:

ch86:597000000:QAM_256:0:0:101

stoth@mythbackend:~/.azap$ azap ch86
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 597000000 Hz
video pid 0x0000, audio pid 0x0000
status 00 | signal 0000 | snr b770 | ber 00000000 | unc 00000000 |
status 1f | signal 0154 | snr 0154 | ber 000000ad | unc 000000ad | FE_HAS_LOCK
status 1f | signal 0156 | snr 0156 | ber 00000000 | unc 00000000 | FE_HAS_LOCK

--
Steven Toth - Kernel Labs
http://www.kernellabs.com
