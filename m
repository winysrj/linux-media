Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37991 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab3AaU7c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 15:59:32 -0500
Received: by mail-wi0-f174.google.com with SMTP id hj13so4589665wib.13
        for <linux-media@vger.kernel.org>; Thu, 31 Jan 2013 12:59:30 -0800 (PST)
Message-ID: <510ADB2F.4080901@googlemail.com>
Date: Thu, 31 Jan 2013 20:59:27 +0000
From: Chris Clayton <chris2553@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: WinTV-HVR-1400: scandvb (and kaffeine) fails to find any channels
References: <510A9A1E.9090801@googlemail.com> <CAGoCfiwQNBv1r5KgCzYFf7X1hP--fyQpqvRHCDtKFcSxwbJWpA@mail.gmail.com>
In-Reply-To: <CAGoCfiwQNBv1r5KgCzYFf7X1hP--fyQpqvRHCDtKFcSxwbJWpA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin

On 01/31/13 16:31, Devin Heitmueller wrote:
> On Thu, Jan 31, 2013 at 11:21 AM, Chris Clayton
> <chris2553@googlemail.com> wrote:
>> Hi.
>>
>> On linuxtv.org, the Hauppauge WinTV-HVR-1400 is listed as being supported.
>> I've bought one, but I find that when I run the scan for dvb-t channels,
>> none are found. I have tried kernels 2.6.11, 2.7.5 and 3.8.0-rc5+ (pulled
>> from Linus' tree today)
>>
>> I know the aerial and cable are OK because, using the same cable, scanning
>> with an internal PCI dvb-t card in a desktop computer finds 117 TV and radio
>> channels. I know the HVR-1400 expresscard is OK because, again using the
>> same cable, on Windows 7 the Hauppauge TV viewing application also finds all
>> those channels.
>
> Try the patch described in this email sent last week:
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg57577.html
>
> There's a very good chance you have the same problem.
>

Thanks for the suggestion. Unfortunately, it doesn't fix my problem.

I've been doing some more investigating and I find that w_scan can't 
"get any working frequency/transponder". The output is:

[chris:~]$ w_scan -c GB -x -C ASCII
w_scan version 20121111 (compiled for DVB API 5.5)
using settings for UNITED KINGDOM
DVB aerial
DVB-T GB
scan type TERRESTRIAL, channellist 6
output format initial tuning data
output charset 'ASCII'
Info: using DVB adapter auto detection.
         /dev/dvb/adapter0/frontend0 -> TERRESTRIAL "DiBcom 7000PC": 
good :-)
Using TERRESTRIAL frontend (adapter /dev/dvb/adapter0/frontend0)
-_-_-_-_ Getting frontend capabilities-_-_-_-_
Using DVB API 5.9
frontend 'DiBcom 7000PC' supports
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO
FEC_AUTO
FREQ (44.25MHz ... 864.00MHz)
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
Scanning 7MHz frequencies...
177500: (time: 00:00)
184500: (time: 00:17)
191500: (time: 00:34)
198500: (time: 00:52)
205500: (time: 01:09)
212500: (time: 01:26)
219500: (time: 01:43)
226500: (time: 02:00)
Scanning 8MHz frequencies...
474000: (time: 02:18)
474167: (time: 02:35)
473833: (time: 02:52)
482000: (time: 03:09)
482167: (time: 03:27)
481833: (time: 03:44)
490000: (time: 04:01)
490167: (time: 04:18)
489833: (time: 04:36)
498000: (time: 04:53)
498167: (time: 05:10)
497833: (time: 05:27)
506000: (time: 05:44)
506167: (time: 06:02)
505833: (time: 06:19)
514000: (time: 06:36)
514167: (time: 06:53)
513833: (time: 07:11)
522000: (time: 07:28)
522167: (time: 07:45)
521833: (time: 08:02)
530000: (time: 08:19)
530167: (time: 08:37)
529833: (time: 08:54)
538000: (time: 09:11)
538167: (time: 09:28)
537833: (time: 09:46)
546000: (time: 10:03)
546167: (time: 10:20)
545833: (time: 10:37)
554000: (time: 10:55)
554167: (time: 11:12)
553833: (time: 11:29)
562000: (time: 11:46)
562167: (time: 12:03)
561833: (time: 12:21)
570000: (time: 12:38)
570167: (time: 12:55)
569833: (time: 13:12)
578000: (time: 13:30)
578167: (time: 13:47)
577833: (time: 14:04)
586000: (time: 14:21)
586167: (time: 14:38)
585833: (time: 14:56)
594000: (time: 15:13)
594167: (time: 15:30)
593833: (time: 15:47)
602000: (time: 16:05)
602167: (time: 16:22)
601833: (time: 16:39)
610000: (time: 16:56)
610167: (time: 17:14)
609833: (time: 17:31)
618000: (time: 17:48)
618167: (time: 18:05)
617833: (time: 18:22)
626000: (time: 18:40)
626167: (time: 18:57)
625833: (time: 19:14)
634000: (time: 19:31)
634167: (time: 19:49)
633833: (time: 20:06)
642000: (time: 20:23)
642167: (time: 20:40)
641833: (time: 20:58)
650000: (time: 21:15)
650167: (time: 21:32)
649833: (time: 21:49)
658000: (time: 22:06)
658167: (time: 22:24)
657833: (time: 22:41)
666000: (time: 22:58)
666167: (time: 23:15)
665833: (time: 23:33)
674000: (time: 23:50)
674167: (time: 24:07)
673833: (time: 24:24)
682000: (time: 24:41)
682167: (time: 24:59)
681833: (time: 25:16)
690000: (time: 25:33)
690167: (time: 25:50)
689833: (time: 26:08)
698000: (time: 26:25)
698167: (time: 26:42)
697833: (time: 26:59)
706000: (time: 27:17)
706167: (time: 27:34)
705833: (time: 27:51)
714000: (time: 28:08)
714167: (time: 28:25)
713833: (time: 28:43)
722000: (time: 29:00)
722167: (time: 29:17)
721833: (time: 29:34)
730000: (time: 29:52)
730167: (time: 30:09)
729833: (time: 30:26)
738000: (time: 30:43)
738167: (time: 31:00)
737833: (time: 31:18)
746000: (time: 31:35)
746167: (time: 31:52)
745833: (time: 32:09)
754000: (time: 32:27)
754167: (time: 32:44)
753833: (time: 33:01)
762000: (time: 33:18)
762167: (time: 33:36)
761833: (time: 33:53)
770000: (time: 34:10)
770167: (time: 34:27)
769833: (time: 34:44)
778000: (time: 35:02)
778167: (time: 35:19)
777833: (time: 35:36)
786000: (time: 35:53)
786167: (time: 36:11)
785833: (time: 36:28)
794000: (time: 36:45)
794167: (time: 37:02)
793833: (time: 37:20)
802000: (time: 37:37)
802167: (time: 37:54)
801833: (time: 38:11)
810000: (time: 38:28)
810167: (time: 38:46)
809833: (time: 39:03)
818000: (time: 39:20)
818167: (time: 39:37)
817833: (time: 39:55)
826000: (time: 40:12)
826167: (time: 40:29)
825833: (time: 40:46)
834000: (time: 41:03)
834167: (time: 41:21)
833833: (time: 41:38)
842000: (time: 41:55)
842167: (time: 42:12)
841833: (time: 42:30)
850000: (time: 42:47)
850167: (time: 43:04)
849833: (time: 43:21)
858000: (time: 43:39)
858167: (time: 43:56)
857833: (time: 44:13)

ERROR: Sorry - i couldn't get any working frequency/transponder
  Nothing to scan!!

That test was with the described patch applied to a 3.7.5 kernel. The 
xc2028 code for 3.8.0-rc5+ is identical to that in 3.7.5. I'll try it 
again without the patch.

> Devin
>
