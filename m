Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50660 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab1G2Vkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 17:40:32 -0400
Received: by wwe5 with SMTP id 5so3957012wwe.1
        for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 14:40:31 -0700 (PDT)
References: <20110729025356.28cc99e8@redhat.com> <019F3E90-A128-4527-8698-1E2FE89341C9@wilsonet.com> <4E332550.2060806@redhat.com>
In-Reply-To: <4E332550.2060806@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <FCB94AF5-5287-4CBE-885B-5A03A6D4FC40@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH 1/2] [media] rc-main: Fix device de-registration logic
Date: Fri, 29 Jul 2011 17:39:46 -0400
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Jul 29, 2011, at 5:25 PM, Mauro Carvalho Chehab wrote:

> Em 29-07-2011 14:30, Jarod Wilson escreveu:
>> On Jul 29, 2011, at 1:53 AM, Mauro Carvalho Chehab wrote:
>> 
>>> rc unregister logic were deadly broken, preventing some drivers to
>>> be removed. Among the broken things, rc_dev_uevent() is being called
>>> during device_del(), causing a data filling on an area that it is
>>> not ready anymore.
>>> 
>>> Also, some drivers have a stop callback defined, that needs to be called
>>> before data removal, as it stops data polling.
>>> 
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>> 
>>> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
>>> index 51a23f4..666d4bb 100644
>>> --- a/drivers/media/rc/rc-main.c
>>> +++ b/drivers/media/rc/rc-main.c
>>> @@ -928,10 +928,6 @@ out:
>>> 
>>> static void rc_dev_release(struct device *device)
>>> {
>>> -	struct rc_dev *dev = to_rc_dev(device);
>>> -
>>> -	kfree(dev);
>>> -	module_put(THIS_MODULE);
>>> }
>> 
>> Since this function become a no-op, does it make sense to just remove it
>> and not set a .release function for static struct device_type rc_dev_type?
> 
> As you tested, this function needs to exist... well, other drivers sometimes
> do the same, by defining it as a no-op function.
> 
>> Other than that, after reading through the patch several times, along with
>> the resulting rc-main.c and some input code, everything seems to make
>> sense to me. Will do some quick sanity-testing with a few of my various
>> devices before I give an ack though, just to be sure. :)
> 
> Thanks! Yeah, a test with other devices is welcome, as we don't want fix for one
> and break for the others ;)

Done. Checked out mceusb, redrat3 and imon, all show no ill effects.


> The logic there looks simple, but it is, in fact, tricky, especially since
> drivers may have polling tasks running, and they need to be cancelled before 
> freeing the resources.

Indeed. Took a bit to wrap my head around it all, but I think I got it.


Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com



