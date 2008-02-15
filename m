Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1JQ8M6-0008Kw-TN
	for linux-dvb@linuxtv.org; Fri, 15 Feb 2008 22:44:27 +0100
Date: Fri, 15 Feb 2008 22:43:18 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Holger Dehnhardt <dehnhardt@ahdehnhardt.de>
In-Reply-To: <200802152233.25423.dehnhardt@ahdehnhardt.de>
Message-ID: <Pine.LNX.4.64.0802152241520.29944@pub5.ifh.de>
References: <200802112223.11129.hfvogt@gmx.net>
	<ea4209750802141220s2402e94bvbd1479037d48cfc8@mail.gmail.com>
	<20080215181815.2583a2e5@gaivota>
	<200802152233.25423.dehnhardt@ahdehnhardt.de>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] support Cinergy HT USB XE (0ccd:0058)
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

Aah now I remember that issue, in fact it is no issue. I was seeing that 
problem when send the sleep command or any other firmware command without 
having a firmware running. In was, so far, no problem.

Patrick.



On Fri, 15 Feb 2008, Holger Dehnhardt wrote:

> Hi Albert, Hi Mauro,
>
> I have successfulli patched and compiled the driver. Im using the terratec
> cinergy device and it works fine.
>
>>> [ 2251.856000] xc2028 4-0061: Error on line 1063: -5
>
> This error message looked very familar to me, so i searched my log and guess
> what I found:
>
> Feb 15 20:42:18 musik kernel: xc2028 3-0061: xc2028_sleep called
> Feb 15 20:42:18 musik kernel: xc2028 3-0061: xc2028_sleep called
> Feb 15 20:42:18 musik kernel: xc2028 3-0061: Error on line 1064: -5
> Feb 15 20:42:18 musik kernel: DiB7000P: setting output mode for demod df75e800
> to 0
> Feb 15 20:42:18 musik kernel: DiB7000P: setting output mode for demod df75e800
> to 0
>
> It identifies the marked line (just to be sure because of the differen line
> numbers)
>
> 	if (priv->firm_version < 0x0202)
> ->		rc = send_seq(priv, {0x00, 0x08, 0x00, 0x00});
> 	else
> 		rc = send_seq(priv, {0x80, 0x08, 0x00, 0x00});
>
>> The above error is really weird. It seems to be related to something that
>> happened before xc2028, since firmware load didn't start on that point of
>> the code.
>
> The error really is weird, but it does not seem to cause the troubles - my
> card works despite the error!
>
>>
>>> [ 2289.284000] xc2028 4-0061: Device is Xceive 3028 version 1.0, firmware
>>> version 2.7
>>
>> This message means that xc3028 firmware were successfully loaded and it is
>> running ok.
>
> This and the following messages look similar...
>
> Holger
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
