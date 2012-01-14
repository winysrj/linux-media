Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49964 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab2ANTba convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 14:31:30 -0500
Received: by bkuw12 with SMTP id w12so720021bku.19
        for <linux-media@vger.kernel.org>; Sat, 14 Jan 2012 11:31:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALzAhNWBY2xB0WFQ-C4=oN8WuH8hbfu1Xq=W4k8a9oj3t9070Q@mail.gmail.com>
References: <CAEN_-SDUfyu34YSV6Lr4yADkNmr6=+TALN0xvrCODFPeRedkFA@mail.gmail.com>
	<CALzAhNWBY2xB0WFQ-C4=oN8WuH8hbfu1Xq=W4k8a9oj3t9070Q@mail.gmail.com>
Date: Sat, 14 Jan 2012 20:31:27 +0100
Message-ID: <CAEN_-SCnV0V=xo4WyvkMjQKaXFTuvnFS+D1Je7sJDp8-z=fxHg@mail.gmail.com>
Subject: Re: cx25840: improve audio for cx2388x drivers
From: =?ISO-8859-2?Q?Miroslav_Sluge=F2?= <thunder.mmm@gmail.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I tested Leadtek DVR3200

http://linuxtv.org/wiki/index.php/Leadtek_WinFast_PxDVR3200_H

XC4000 and XC3028 versions

I know that there is not yet full support for those cards, but i have
few patches which are waiting to be commited, after for both tuners
should work:

DVB-t (already)
Analog TV with sound (not working)
Analog Composite (not working)
Analog S-Video (not working)
Analog Component (not working)
Analog FM radio (not even implemented)

For now i am not able to fix MPEG2 which i don't understand and i
can't test IR remote which i don't use.

Why are you asking? :)

M.

Dne 14. ledna 2012 20:23 Steven Toth <stoth@kernellabs.com> napsal(a):
> Miroslav, what cards did you test with?
>
> 2012/1/14 Miroslav Slugeò <thunder.mmm@gmail.com>:
>> Searching for testers, this patch is big one, it was more then week of
>> work and testing, so i appriciate any comments and recommendations.
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
