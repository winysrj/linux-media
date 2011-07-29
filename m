Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab1G2VZi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 17:25:38 -0400
Message-ID: <4E332550.2060806@redhat.com>
Date: Fri, 29 Jul 2011 18:25:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] [media] rc-main: Fix device de-registration logic
References: <20110729025356.28cc99e8@redhat.com> <019F3E90-A128-4527-8698-1E2FE89341C9@wilsonet.com>
In-Reply-To: <019F3E90-A128-4527-8698-1E2FE89341C9@wilsonet.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 29-07-2011 14:30, Jarod Wilson escreveu:
> On Jul 29, 2011, at 1:53 AM, Mauro Carvalho Chehab wrote:
> 
>> rc unregister logic were deadly broken, preventing some drivers to
>> be removed. Among the broken things, rc_dev_uevent() is being called
>> during device_del(), causing a data filling on an area that it is
>> not ready anymore.
>>
>> Also, some drivers have a stop callback defined, that needs to be called
>> before data removal, as it stops data polling.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
>> index 51a23f4..666d4bb 100644
>> --- a/drivers/media/rc/rc-main.c
>> +++ b/drivers/media/rc/rc-main.c
>> @@ -928,10 +928,6 @@ out:
>>
>> static void rc_dev_release(struct device *device)
>> {
>> -	struct rc_dev *dev = to_rc_dev(device);
>> -
>> -	kfree(dev);
>> -	module_put(THIS_MODULE);
>> }
> 
> Since this function become a no-op, does it make sense to just remove it
> and not set a .release function for static struct device_type rc_dev_type?

As you tested, this function needs to exist... well, other drivers sometimes
do the same, by defining it as a no-op function.

> Other than that, after reading through the patch several times, along with
> the resulting rc-main.c and some input code, everything seems to make
> sense to me. Will do some quick sanity-testing with a few of my various
> devices before I give an ack though, just to be sure. :)

Thanks! Yeah, a test with other devices is welcome, as we don't want fix for one
and break for the others ;)

The logic there looks simple, but it is, in fact, tricky, especially since
drivers may have polling tasks running, and they need to be cancelled before 
freeing the resources.

Cheers,
Mauro

> 

