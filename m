Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43183 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab1G2UaY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 16:30:24 -0400
Received: by wyg8 with SMTP id 8so431857wyg.19
        for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 13:30:22 -0700 (PDT)
References: <20110729025356.28cc99e8@redhat.com> <019F3E90-A128-4527-8698-1E2FE89341C9@wilsonet.com>
In-Reply-To: <019F3E90-A128-4527-8698-1E2FE89341C9@wilsonet.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <B1E87CBC-4F0B-4407-80AB-6FE91E9EBABF@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH 1/2] [media] rc-main: Fix device de-registration logic
Date: Fri, 29 Jul 2011 16:30:01 -0400
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Jul 29, 2011, at 1:30 PM, Jarod Wilson wrote:

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

Nope, that leads to this:

[  765.095926] ------------[ cut here ]------------
[  765.098076] WARNING: at /home/jarod/src/linux-ir/drivers/base/core.c:143 device_release+0x73/0x7f()
[  765.100215] Hardware name: empty
[  765.102343] Device 'rc0' does not have a release() function, it is broken and must be fixed.

Which may or not be bogus. But I've got a hanging modprobe -r em28xx-dvb
with this change in place. Now to test with it rolled back...


-- 
Jarod Wilson
jarod@wilsonet.com



