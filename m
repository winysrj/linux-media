Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from ahdehnhardt.de ([88.80.200.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dehnhardt@ahdehnhardt.de>) id 1JQ8Bz-0007hE-5u
	for linux-dvb@linuxtv.org; Fri, 15 Feb 2008 22:33:59 +0100
Received: from [88.73.130.233] (helo=musik.ahdehnhardt.de)
	by ahdehnhardt.de with esmtpsa (TLS-1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.63) (envelope-from <dehnhardt@ahdehnhardt.de>)
	id 1JQ8C6-00055w-QA
	for linux-dvb@linuxtv.org; Fri, 15 Feb 2008 22:34:07 +0100
From: Holger Dehnhardt <dehnhardt@ahdehnhardt.de>
To: linux-dvb@linuxtv.org
Date: Fri, 15 Feb 2008 22:33:24 +0100
References: <200802112223.11129.hfvogt@gmx.net>
	<ea4209750802141220s2402e94bvbd1479037d48cfc8@mail.gmail.com>
	<20080215181815.2583a2e5@gaivota>
In-Reply-To: <20080215181815.2583a2e5@gaivota>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802152233.25423.dehnhardt@ahdehnhardt.de>
Subject: Re: [linux-dvb] [PATCH] support Cinergy HT USB XE (0ccd:0058)
Reply-To: dehnhardt@ahdehnhardt.de
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Albert, Hi Mauro,

I have successfulli patched and compiled the driver. Im using the terratec 
cinergy device and it works fine.

> > [ 2251.856000] xc2028 4-0061: Error on line 1063: -5

This error message looked very familar to me, so i searched my log and guess 
what I found:

Feb 15 20:42:18 musik kernel: xc2028 3-0061: xc2028_sleep called
Feb 15 20:42:18 musik kernel: xc2028 3-0061: xc2028_sleep called
Feb 15 20:42:18 musik kernel: xc2028 3-0061: Error on line 1064: -5
Feb 15 20:42:18 musik kernel: DiB7000P: setting output mode for demod df75e800 
to 0
Feb 15 20:42:18 musik kernel: DiB7000P: setting output mode for demod df75e800 
to 0

It identifies the marked line (just to be sure because of the differen line 
numbers)

	if (priv->firm_version < 0x0202)
->		rc = send_seq(priv, {0x00, 0x08, 0x00, 0x00});
	else
		rc = send_seq(priv, {0x80, 0x08, 0x00, 0x00});

> The above error is really weird. It seems to be related to something that
> happened before xc2028, since firmware load didn't start on that point of
> the code.

The error really is weird, but it does not seem to cause the troubles - my 
card works despite the error!

>
> > [ 2289.284000] xc2028 4-0061: Device is Xceive 3028 version 1.0, firmware
> > version 2.7
>
> This message means that xc3028 firmware were successfully loaded and it is
> running ok.

This and the following messages look similar...

Holger

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
