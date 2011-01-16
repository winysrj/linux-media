Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:7610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab1APOjD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 09:39:03 -0500
Message-ID: <4D331F1B.2090605@redhat.com>
Date: Sun, 16 Jan 2011 14:38:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Antonio Ospite <ospite@studenti.unina.it>,
	linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.38] gspca for_2.6.38
References: <20110113115953.4636c392@tele>	<20110113123804.d391b10e.ospite@studenti.unina.it> <20110113173021.1f8a7b8b@tele>
In-Reply-To: <20110113173021.1f8a7b8b@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 13-01-2011 14:30, Jean-Francois Moine escreveu:
> On Thu, 13 Jan 2011 12:38:04 +0100
> Antonio Ospite <ospite@studenti.unina.it> wrote:
> 
>>> Jean-François Moine (9):  
>> [...]
>>>       gspca - ov534: Use the new video control mechanism  
>>
>> In this commit, is there a reason why you didn't rename also
>> sd_setagc() into setagc() like for the other functions?
>>
>> I am going to test the changes and report back if there's anything
>> more, I like the cleanup tho.
> 
> Hi Antonio,
> 
> With the new video control mechanism, the '.set_control' function is
> called only when capture is active. Otherwise, the '.set' function is
> called in any case, and here, it activates/inactivates the auto white
> balance control... Oh, I forgot to disable the awb when the agc is
> disabled!
> 
> Thank you for reporting any problem. BTW, the webcam 06f8:3002 which
> had been removed some time ago is being tested. I will add it to this
> subdriver as soon as it works correctly.

I'm applying the remaining 8 patches from this series, as they seem to be ok.

Please send me a new pull request when you fix the issues with the ov534 new
video control mechanism.

Thanks,
Mauro
