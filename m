Return-path: <mchehab@pedra>
Received: from 5571f1ba.dsl.concepts.nl ([85.113.241.186]:33955 "EHLO
	his10.thuis.hoogenraad.info" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755368Ab1FJNWt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 09:22:49 -0400
Message-ID: <4DF21AA7.1010505@hoogenraad.net>
Date: Fri, 10 Jun 2011 15:22:47 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org
Subject: Re: Media_build does not compile due to errors in cx18-driver.h,
 cx18-driver.c and dvbdev.c /rc-main.c
References: <4DF1FF06.4050502@hoogenraad.net>	<3e84c07f-83ff-4f83-9f8f-f52631259f05@email.android.com> <BANLkTinE1vRVJ+j+7JiPHZqXHJ8WTFX+cg@mail.gmail.com>
In-Reply-To: <BANLkTinE1vRVJ+j+7JiPHZqXHJ8WTFX+cg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Andy:

Something along the line of id already defined.
I just corrected the code by removing the duplicate lines that are in 
the sources of the tar.

The other 3 files have a bad escape sequence in a line saying that this 
is the backports. One backslash not removed in a script, I guess.

Devin:

The version does not matter for the cx18 problem: any compiler complains 
on duplicate lines.

Anyway: 2.6.32-32-generic-pae #62-Ubuntu SMP Wed Apr 20 22:10:33 UTC 
2011 i686 GNU/Linux

Devin Heitmueller wrote:
> On Fri, Jun 10, 2011 at 8:34 AM, Andy Walls<awalls@md.metrocast.net>  wrote:
>> What are the error messages?
>>
>> Tejun Heo made quite a number of workqueue changes, and the cx18 driver got dragged forward with them.  So did ivtv for that matter.
>>
>> Just disable the cx18 driver if you don't need it for an older kernel.
>>
>> Regards,
>> Andy
>
> Another highly relevant piece of information to know is what kernel
> Jan is running on.  It is probably from before the workqueue changes.
>
> Devin
>


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
