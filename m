Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44105 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab2ENBqW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 21:46:22 -0400
Message-ID: <4FB063EC.90609@iki.fi>
Date: Mon, 14 May 2012 04:46:20 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] rtl2832 ver 0.3: suport for RTL2832 demodulator revised
 version
References: <1336846109-30070-1-git-send-email-thomas.mair86@googlemail.com> <1336846109-30070-2-git-send-email-thomas.mair86@googlemail.com> <4FB061C2.90006@iki.fi>
In-Reply-To: <4FB061C2.90006@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I forget to ran checkpatch.pl. Looks like you too. Mostly simple 
fixes... You should always ran checkpatch.pl when dending patches.

On 14.05.2012 04:37, Antti Palosaari wrote:
> Puuuh, there was more findings what I supposed earlier. Most of those
> are easy to fix.
>
> But it seems like all the statistics are broken, returning wrong values
> and one BER was even inplemented as a signal quality meter.
>
> What you say if I propose you to remove those statistics and sent driver
> without? Add those then later.
>
> Statistics are not mandatory and it is 3.4-RC7 phase ongoing. It means
> driver should be quite ready during that week if we want it to the
> Kernel 3.5. I am almost sure Kernel 3.4 is released next weekend...

[crope@localhost linux]$ ./scripts/checkpatch.pl --file 
drivers/media/dvb/frontends/rtl2832.c
WARNING: line over 80 characters
#587: FILE: media/dvb/frontends/rtl2832.c:587:
+			0xf5, 0xff, 0x15, 0x38, 0x5d, 0x6d, 0x52, 0x07, 0xfa, 0x2f,

WARNING: line over 80 characters
#588: FILE: media/dvb/frontends/rtl2832.c:588:
+			0x53, 0xf5, 0x3f, 0xca, 0x0b, 0x91, 0xea, 0x30, 0x63, 0xb2,

WARNING: line over 80 characters
#589: FILE: media/dvb/frontends/rtl2832.c:589:
+			0x13, 0xda, 0x0b, 0xc4, 0x18, 0x7e, 0x16, 0x66, 0x08, 0x67,

WARNING: line over 80 characters
#595: FILE: media/dvb/frontends/rtl2832.c:595:
+			0xe7, 0xcc, 0xb5, 0xba, 0xe8, 0x2f, 0x67, 0x61, 0x00, 0xaf,

WARNING: line over 80 characters
#596: FILE: media/dvb/frontends/rtl2832.c:596:
+			0x86, 0xf2, 0xbf, 0x59, 0x04, 0x11, 0xb6, 0x33, 0xa4, 0x30,

WARNING: line over 80 characters
#597: FILE: media/dvb/frontends/rtl2832.c:597:
+			0x15, 0x10, 0x0a, 0x42, 0x18, 0xf8, 0x17, 0xd9, 0x07, 0x22,

WARNING: line over 80 characters
#603: FILE: media/dvb/frontends/rtl2832.c:603:
+			0x09, 0xf6, 0xd2, 0xa7, 0x9a, 0xc9, 0x27, 0x77, 0x06, 0xbf,

WARNING: line over 80 characters
#604: FILE: media/dvb/frontends/rtl2832.c:604:
+			0xec, 0xf4, 0x4f, 0x0b, 0xfc, 0x01, 0x63, 0x35, 0x54, 0xa7,

WARNING: line over 80 characters
#605: FILE: media/dvb/frontends/rtl2832.c:605:
+			0x16, 0x66, 0x08, 0xb4, 0x19, 0x6e, 0x19, 0x65, 0x05, 0xc8,

WARNING: please, no space before tabs
#646: FILE: media/dvb/frontends/rtl2832.c:646:
+^I* ^I/ ConstWithBandwidthMode)$

WARNING: please, no space before tabs
#658: FILE: media/dvb/frontends/rtl2832.c:658:
+^I* ^I/ (CrystalFreqHz * 7))$

total: 0 errors, 11 warnings, 1009 lines checked

drivers/media/dvb/frontends/rtl2832.c has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.
[crope@localhost linux]$
[crope@localhost linux]$ ./scripts/checkpatch.pl --file 
drivers/media/dvb/frontends/rtl2832_priv.h
ERROR: Macros with complex values should be enclosed in parenthesis
#30: FILE: media/dvb/frontends/rtl2832_priv.h:30:
+#define dbg(f, arg...) \
+	if (rtl2832_debug) \
+		printk(KERN_INFO LOG_PREFIX": " f "\n" , ## arg)

WARNING: do not add new typedefs
#52: FILE: media/dvb/frontends/rtl2832_priv.h:52:
+typedef struct {

WARNING: do not add new typedefs
#60: FILE: media/dvb/frontends/rtl2832_priv.h:60:
+typedef struct {

total: 1 errors, 2 warnings, 260 lines checked

drivers/media/dvb/frontends/rtl2832_priv.h has style problems, please 
review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.
[crope@localhost linux]$
[crope@localhost linux]$ ./scripts/checkpatch.pl --file 
drivers/media/dvb/frontends/rtl2832.h
total: 0 errors, 0 warnings, 81 lines checked

drivers/media/dvb/frontends/rtl2832.h has no obvious style problems and 
is ready for submission.
[crope@localhost linux]$


regards
Antti

-- 
http://palosaari.fi/
