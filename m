Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37920 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab1DFBFv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 21:05:51 -0400
Received: by vws1 with SMTP id 1so746386vws.19
        for <linux-media@vger.kernel.org>; Tue, 05 Apr 2011 18:05:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinkRdq4=5tHYvCfvsKAisnq=Xt00Q@mail.gmail.com>
References: <mailman.466.1301890961.26790.linux-dvb@linuxtv.org>
	<SNT124-W658C9CDE54575A79B73D6FACA30@phx.gbl>
	<BANLkTimEtbx6HkqBQLBTc7XX_wEYgs7fJg@mail.gmail.com>
	<F8BDDD6D-6870-4291-99C9-D8FCABFEEB05@dons.net.au>
	<BANLkTimBYhq_Ag3nkU1105Em0-AXvMiQbQ@mail.gmail.com>
	<B6690ADE-0D4F-4E22-8AB2-DB68AD43E749@dons.net.au>
	<BANLkTinkRdq4=5tHYvCfvsKAisnq=Xt00Q@mail.gmail.com>
Date: Wed, 6 Apr 2011 11:05:50 +1000
Message-ID: <BANLkTi=dxkiGNYb+7Z+QQ7pZBx75xsSrJQ@mail.gmail.com>
Subject: Re: [linux-dvb] DVICO HDTV Dual Express2
From: Nathan Stitt <nathan.j.stitt@gmail.com>
To: "Daniel O'Connor" <darius@dons.net.au>
Cc: Vincent McIntyre <vincent.mcintyre@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I know I shouldn't have quoted mythtv to identify a problem, so I've
tinkered with this a little more and can reproduce it using the dvb
utilities.

I can reproduce the problem using tzap and cat'ing
/dev/dvb/adapter[23]/dvr0 to files. When one of the tuners tunes the
the bad transponder, the files stop growing. Not always immediately,
but typically within a few seconds.

Turning on debugging in various dvb modules shows nothing obviously
suspicious when it occurs, but I notice that when the problem occurs,
when I kill the offending tzap, the following messages are logged.

Apr  6 10:45:39 media kernel: [95234.332590] cx23885_wakeup: 0 buffers
handled (should be 1)
Apr  6 10:45:39 media kernel: [95234.332606] cx23885_wakeup: 0 buffers
handled (should be 1)

But if I kill it without the problem manifesting (either by using a
non-offending transponder, or by killing it before the failure occurs
with the problematic transponder) these messages don't appear.

Also perhaps noteworthy is that once the offending tzap process is
terminated, the file generated from the other resumes growing.

Here are the modules I thought to turn on debugging. Any other suggestions?

nathan@media:/sys/module$ grep -r 1 */parameters/*debug*
af9013/parameters/debug:1
cx23885/parameters/debug:1
cx23885/parameters/i2c_debug:1
cx23885/parameters/vbi_debug:1
cx23885/parameters/video_debug:1
dvb_core/parameters/cam_debug:1
dvb_core/parameters/debug:1
dvb_core/parameters/dvbdev_debug:1
dvb_core/parameters/frontend_debug:1
dvb_usb_af9015/parameters/debug:1
tuner_xc2028/parameters/debug:1
videobuf_core/parameters/debug:1
videobuf_dma_sg/parameters/debug:1
videobuf_dvb/parameters/debug:1
zl10353/parameters/debug:1
zl10353/parameters/debug_regs:1

I'm happy to help track this down further if anyone can advise how to proceed.

(I hope I haven't hijacked this thread, I never saw the earlier
emails, but from what I could tell, it seems to be related to my
experiences).

(sorry for the repeated email, Daniel, I accidentally didn't Reply-to-all)

Regards,
Nathan.
