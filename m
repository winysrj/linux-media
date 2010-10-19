Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:2438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757935Ab0JSLNw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 07:13:52 -0400
Message-ID: <4CBD7D68.5090409@redhat.com>
Date: Tue, 19 Oct 2010 09:13:44 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.36] gspca for_2.6.36
References: <20101010132447.0c7f9a22@tele>	<20101015094148.95fd205b.ospite@studenti.unina.it> <20101019112032.d8487d72.ospite@studenti.unina.it>
In-Reply-To: <20101019112032.d8487d72.ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-10-2010 07:20, Antonio Ospite escreveu:
> On Fri, 15 Oct 2010 09:41:48 +0200
> Antonio Ospite <ospite@studenti.unina.it> wrote:
> 
>> On Sun, 10 Oct 2010 13:24:47 +0200
>> Jean-Francois Moine <moinejf@free.fr> wrote:
>>
>>> The following changes since commit
>>> d65728875a85ac7c8b7d6eb8d51425bacc188980:
>>>
>>>   V4L/DVB: v4l: radio: si470x: fix unneeded free_irq() call (2010-09-30 07:35:12 -0300)
>>>
>>> are available in the git repository at:
>>>   git://linuxtv.org/jfrancois/gspca.git for_2.6.36
>>>
>>> Jean-François Moine (1):
>>>       gspca - main: Fix a regression with the PS3 Eye webcam
>>>
>>
>> Hi, this is not in 2.6.36-rc8, any chance we can make it for 2.6.36?
> 
> Ping.
> 
The patch is in the today's linux-next tree. I added it together with another patch
for 2.6.36 (they are on a separate brancho on my local tree). If everything wents well, 
it is likely that we'll have time to add it for 2.6.36.

Cheers,
Mauro
