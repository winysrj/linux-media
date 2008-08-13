Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f20.google.com ([209.85.217.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sparkmaul@gmail.com>) id 1KTJOi-0004Fp-Or
	for linux-dvb@linuxtv.org; Wed, 13 Aug 2008 18:40:36 +0200
Received: by gxk13 with SMTP id 13so1668176gxk.17
	for <linux-dvb@linuxtv.org>; Wed, 13 Aug 2008 09:39:57 -0700 (PDT)
Message-ID: <8e5b27790808130939m43918485kb81128ccbe782621@mail.gmail.com>
Date: Wed, 13 Aug 2008 09:39:57 -0700
From: "Paul Marks" <paul@pmarks.net>
To: "Chaogui Zhang" <czhang1974@gmail.com>
In-Reply-To: <bd41c5f0808130905y30efc79m84bdcf5128c425a@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <8e5b27790808120058o52c4c6bcw21152364b2613c39@mail.gmail.com>
	<8e5b27790808122233r539e6404y777e2bade7c78b47@mail.gmail.com>
	<bd41c5f0808130905y30efc79m84bdcf5128c425a@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] FusionHDTV5 IR not working.
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

On Wed, Aug 13, 2008 at 9:05 AM, Chaogui Zhang <czhang1974@gmail.com> wrote:
>
> Do the following and see if it works:
>
> Power off your system (don't just reboot), then unplug power, wait for
> 20 seconds and plug it back in then start your Ubuntu.

Hey, you're right!  Thanks.  The remote is working perfectly on Gentoo
now.  0x6b is also visible in i2cdetect.

On Wed, Aug 13, 2008 at 9:11 AM, Steven Toth <stoth@linuxtv.org> wrote:
>
> If this is true, and the IR device reset line is wired to the bridge, we
> should try to identify the GPIO and force a device reset on driver load.

If you can't figure out how to reset it, then at least put a comment
in the kernel code mentioning the need to power off.  It might save
someone a lot of effort in the future.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
