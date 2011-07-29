Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57678 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab1G2RbN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 13:31:13 -0400
Received: by qwk3 with SMTP id 3so1943254qwk.19
        for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 10:31:12 -0700 (PDT)
References: <20110729025356.28cc99e8@redhat.com>
In-Reply-To: <20110729025356.28cc99e8@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <019F3E90-A128-4527-8698-1E2FE89341C9@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH 1/2] [media] rc-main: Fix device de-registration logic
Date: Fri, 29 Jul 2011 13:30:56 -0400
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Jul 29, 2011, at 1:53 AM, Mauro Carvalho Chehab wrote:

> rc unregister logic were deadly broken, preventing some drivers to
> be removed. Among the broken things, rc_dev_uevent() is being called
> during device_del(), causing a data filling on an area that it is
> not ready anymore.
> 
> Also, some drivers have a stop callback defined, that needs to be called
> before data removal, as it stops data polling.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 51a23f4..666d4bb 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -928,10 +928,6 @@ out:
> 
> static void rc_dev_release(struct device *device)
> {
> -	struct rc_dev *dev = to_rc_dev(device);
> -
> -	kfree(dev);
> -	module_put(THIS_MODULE);
> }

Since this function become a no-op, does it make sense to just remove it
and not set a .release function for static struct device_type rc_dev_type?

Other than that, after reading through the patch several times, along with
the resulting rc-main.c and some input code, everything seems to make
sense to me. Will do some quick sanity-testing with a few of my various
devices before I give an ack though, just to be sure. :)

-- 
Jarod Wilson
jarod@wilsonet.com



