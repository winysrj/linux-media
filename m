Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1JdCIg-0006UR-HF
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 23:34:55 +0100
Date: Sat, 22 Mar 2008 23:34:15 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Filippo Argiolas <filippo.argiolas@gmail.com>
In-Reply-To: <1205266452.15469.2.camel@tux>
Message-ID: <Pine.LNX.4.64.0803222310370.26601@pub6.ifh.de>
References: <1205266452.15469.2.camel@tux>
MIME-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] support key repeat with dib0700 ir receiver
 - (resend signed off)
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

Hi Filippo,

thanks for your patch - I committed it some minutes ago.

Patrick.

On Tue, 11 Mar 2008, Filippo Argiolas wrote:

> This patch enables support for repeating last event when a key is holded
> down with dib0700 devices. It works with rc5 and nec remotes.
> It also fixes an annoying bug that floods kernel log with "Unknown key"
> messages after each keypress. This happened because the driver was not
> resetting infrared register after each poll so it kept polling last key
> even if nothing was being pressed. Fixing this, (calling rc_setup after
> each poll), permits to implement key repeat.
>
> Signed-off-by: Filippo Argiolas <filippo.argiolas at gmail.com>
>
> I'm resending the patch because I didn't sign it off the first time.
> It's been a while since it's out, it has been tested and received many
> positive comments and no complaint. Please refer to my previous post for
> a complete description of the problem and how the patch fixes it.
> Hope everything is ok for inclusion :P
> Thanks,
>
> Cheers,
> Filippo
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
