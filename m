Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:31499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756905Ab1EZOtX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 10:49:23 -0400
Message-ID: <4DDE686C.6000900@redhat.com>
Date: Thu, 26 May 2011 10:49:16 -0400
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?ISO-8859-1?Q?David_?= =?ISO-8859-1?Q?H=E4rdeman?=
	<david@hardeman.nu>, Dmitry Torokhov <dtor@mail.ru>,
	"open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] rc: double unlock in rc_register_device()
References: <20110526085201.GF14591@shale.localdomain>
In-Reply-To: <20110526085201.GF14591@shale.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dan Carpenter wrote:
> If change_protocol() fails and we goto out_raw, then it calls unlock
> twice.

Gah, good catch, I gotta quit adding new bugs... ;)


> I noticed that the other time we called change_protocol() we
> held the &dev->lock, so I changed it to hold it here too.
>
> Signed-off-by: Dan Carpenter<error27@gmail.com>
> ---
> Compile tested only.


I've sanity-checked the code, and yeah, calling change_protocol() 
function pointers with the lock held should be perfectly fine here too. 
The change_protocol functions are device-driver-specific, and don't 
touch the core rc device lock.

Reviewed-by: Jarod Wilson <jarod@redhat.com>
Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com


