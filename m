Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:46423 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab0DIShs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Apr 2010 14:37:48 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Oliver Endriss <o.endriss@gmx.de>, linux-media@vger.kernel.org,
	stable@kernel.org
Subject: Re: [PATCH] V4L/DVB: budget-av: wait longer for frontend to power on
References: <1269200787-30681-1-git-send-email-bjorn@mork.no>
	<4BBE477E.80006@redhat.com> <201004091607.18364@orion.escape-edv.de>
	<4BBF37D9.2060206@redhat.com>
Date: Fri, 09 Apr 2010 20:37:16 +0200
In-Reply-To: <4BBF37D9.2060206@redhat.com> (Mauro Carvalho Chehab's message of
	"Fri, 09 Apr 2010 11:21:13 -0300")
Message-ID: <87k4sgtqub.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> Oliver Endriss wrote:
>
>> Mauro, please do not apply this patch!
>
> Don't worry, I won't apply this patch.
>> 
>> Afaik there is no tuner which takes 5 seconds to initialize. (And if
>> there was one, it would be a bad idea to add a 5s delay for all tuners!)
>
> Yes, that's my point: if is there such hardware, the fix should touch
> only on the hardware with that broken design.
>
> (btw, there is one tuner that takes almost 30 seconds to initialize:
> the firmware load for xc3028 on tm6000 rev A should go on slow speed, 
> otherwise, it fails loading - the i2c implementation on tm6000 were
> really badly designed)
>
>> The saa7146_i2c_writeout errors are likely caused by broken hardware.
>
> I think so.

You are so right both of you.  Please drop the patch.

I believe this problem was yet another symptom of my faulty SATA hard
drive.  The driver is working fine with the default 100 ms timeout after
replacing that drive.

Sorry about all the unnecessary work I created for you, and thanks for
taking the time to review this even though you suspected user/hardware
error. 


Bjørn
