Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35950 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab2DBRkx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Apr 2012 13:40:53 -0400
Message-ID: <4F79E49D.1020802@iki.fi>
Date: Mon, 02 Apr 2012 20:40:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add fc0011 tuner driver
References: <20120402181432.74e8bd50@milhouse> <4F79DA52.2050907@iki.fi> <20120402192011.4edc82ff@milhouse>
In-Reply-To: <20120402192011.4edc82ff@milhouse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02.04.2012 20:20, Michael Büsch wrote:
> On Mon, 02 Apr 2012 19:56:50 +0300
> Antti Palosaari<crope@iki.fi>  wrote:
>
>> On 02.04.2012 19:14, Michael Büsch wrote:
>>> This adds support for the Fitipower fc0011 DVB-t tuner.
>>>
>>> Signed-off-by: Michael Buesch<m@bues.ch>
>>
>> Applied, thanks!
>> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_experimental
>>
>> I looked it through quickly, no big issues. Anyhow, when I ran
>> checkpatch.pl and it complains rather much. All Kernel developers must
>> use checkpatch.pl before sent patches and fix findings if possible,
>> errors must be fixed and warnings too if there is no good reason to
>> leave as it is.
>
> Well, I _did_ run it on the patch.
> There is no error. Only (IMO bogus) warnings. Most of them
> are about the 80 char limit. Which isn't really a hard limit. And those lines
> only exceed the 80 char limit by a few chars (one, two or such). Splitting
> those line serves no readability purpose. In fact, it just worsens it.


git show --pretty=email b650f4d701859ccff76870208c9fd8093cc64209 | 
./scripts/checkpatch.pl -
WARNING: please write a paragraph that describes the config symbol fully
#37: FILE: drivers/media/common/tuners/Kconfig:207:
+config MEDIA_TUNER_FC0011

WARNING: msleep < 20ms can sleep for up to 20ms; see 
Documentation/timers/timers-howto.txt
+	msleep(10);
WARNING: quoted string split across lines
#334: FILE: drivers/media/common/tuners/fc0011.c:270:
+		dev_warn(&priv->i2c->dev, "Unsupported bandwidth %u kHz. "
+			 "Using 6000 kHz.\n",

WARNING: line over 80 characters
#397: FILE: drivers/media/common/tuners/fc0011.c:333:
+		err |= fc0011_writereg(priv, FC11_REG_RCCAL, regs[FC11_REG_RCCAL]);

WARNING: line over 80 characters
#420: FILE: drivers/media/common/tuners/fc0011.c:356:
+			regs[FC11_REG_VCOSEL] &= ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);

WARNING: line over 80 characters
#430: FILE: drivers/media/common/tuners/fc0011.c:366:
+			regs[FC11_REG_VCOSEL] &= ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);

WARNING: line over 80 characters
#439: FILE: drivers/media/common/tuners/fc0011.c:375:
+			regs[FC11_REG_VCOSEL] &= ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);

WARNING: line over 80 characters
#449: FILE: drivers/media/common/tuners/fc0011.c:385:
+			regs[FC11_REG_VCOSEL] &= ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);

WARNING: line over 80 characters
#456: FILE: drivers/media/common/tuners/fc0011.c:392:
+			regs[FC11_REG_VCOSEL] &= ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);

WARNING: line over 80 characters
#468: FILE: drivers/media/common/tuners/fc0011.c:404:
+			regs[FC11_REG_VCOSEL] &= ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);

WARNING: line over 80 characters
#478: FILE: drivers/media/common/tuners/fc0011.c:414:
+			regs[FC11_REG_VCOSEL] &= ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);

WARNING: msleep < 20ms can sleep for up to 20ms; see 
Documentation/timers/timers-howto.txt
+	msleep(10);
WARNING: quoted string split across lines
#504: FILE: drivers/media/common/tuners/fc0011.c:440:
+	dev_dbg(&priv->i2c->dev, "Tuned to "
+		"fa=%02X fp=%02X xin=%02X%02X vco=%02X vcosel=%02X "

WARNING: please, no spaces at the start of a line
#620: FILE: drivers/media/common/tuners/fc0011.h:26:
+    defined(CONFIG_MEDIA_TUNER_FC0011_MODULE)$

total: 0 errors, 14 warnings, 598 lines checked

Your patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.


hmmmm, I think Mauro will at least complain when I ask he to PULL that 
master. Personally I would like to see line len something more than 80 
chars, but as checkpatch.pl complains it I have shortened lines despite 
very few cases.

@Mauro what do you think are that kind of WARNINGs, those are not 
errors, allowed?

>> And one note about tuner driver, my AF9035 + FC0011 device founds only 1
>> mux of 4. Looks like some performance issues still to resolve.
>
> I have no idea what this means.
> So I have no remote idea of what could possibly be wrong here.
> Is this a bug on af903x or the tuner driver?

Likely tuner driver, or demod driver. But as demod tuner initialization 
tables are likely correct I suspect it is tuner issue at first hand. And 
secondly my other hardware with TUA9001 performs very well, better than 
old AF9015 sticks.


regards
Antti
-- 
http://palosaari.fi/
