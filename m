Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:35365 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab3F1PXX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 11:23:23 -0400
Received: by mail-qa0-f49.google.com with SMTP id hu16so658569qab.1
        for <linux-media@vger.kernel.org>; Fri, 28 Jun 2013 08:23:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <011901ce73ab$9b81cce0$d28566a0$@blueflowamericas.com>
References: <010c01ce7365$9181ff30$b485fd90$@blueflowamericas.com>
	<CAGoCfiyjeqxVV8A_MM-iV58=s48FEhNPA=5MPg3WAOAKs8d2iA@mail.gmail.com>
	<011901ce73ab$9b81cce0$d28566a0$@blueflowamericas.com>
Date: Fri, 28 Jun 2013 11:23:22 -0400
Message-ID: <CALzAhNV7Cv9SR1C2mpgtLTwxD_grCZeOWc6O-2XpJEAKg1mX6w@mail.gmail.com>
Subject: Re: lgdt3304
From: Steven Toth <stoth@kernellabs.com>
To: Carl-Fredrik Sundstrom <cf@blueflowamericas.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 27, 2013 at 11:00 PM, Carl-Fredrik Sundstrom
<cf@blueflowamericas.com> wrote:
>
> I am able to detect two lgdt3304 one on each i2c bus now. As you suspected I
> had to set GPIO pin 17 for them to come alive.
>
> Now to my next question, how do I attach two front ends I have two lgdt3304
> and two TDA18271HD/C2
> Is there a good driver I can look at where they do that ?

The SAA7164 driver (amongst others) demonstrates how to expose
multiple tuners on a single card via multiple adapters,
/dev/dvb/adapterX.

The cx88 driver demonstrates how to expose multiple tuners/demods via
a single transport bus, via a single dvb adapter.
/dev/dvb/adapter0/frontendX

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
