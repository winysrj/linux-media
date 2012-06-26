Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab2FZVa3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 17:30:29 -0400
Message-ID: <4FEA29EA.7050305@redhat.com>
Date: Tue, 26 Jun 2012 18:30:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Antti Palosaari <crope@iki.fi>, Kay Sievers <kay@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 2/4] em28xx: defer probe() if userspace mode is disabled
References: <4FE9169D.5020300@redhat.com> <1340739262-13747-1-git-send-email-mchehab@redhat.com> <1340739262-13747-3-git-send-email-mchehab@redhat.com> <20120626204344.GD3885@kroah.com>
In-Reply-To: <20120626204344.GD3885@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-06-2012 17:43, Greg KH escreveu:
> On Tue, Jun 26, 2012 at 04:34:20PM -0300, Mauro Carvalho Chehab wrote:
>> +	/*
>> +	 * If the device requires firmware, probe() may need to be
>> +	 * postponed, as udev may not be ready yet to honour firmware
>> +	 * load requests.
>> +	 */
>> +	if (em28xx_boards[id->driver_info].needs_firmware &&
>> +	    is_usermodehelp_disabled()) {
>> +		printk_once(KERN_DEBUG DRIVER_NAME
>> +		            ": probe deferred for board %d.\n",
>> +		            (unsigned)id->driver_info);
>> +		return -EPROBE_DEFER;
> 
> You should printk once per device, right?  Not just for one time per
> module load.

Yes, a per-device printk would be better. In a matter of fact, the first
logs when the kernel boots are:

[    2.884645] em28xx: init = 0, userspace_is_disabled = 0, needs firmware = 1
[    2.884647] em28xx: probe deferred for board 16.
[    2.884650] usb 1-6:1.0: Driver em28xx requests probe deferral

as usb core is already telling that probe was referred, we can simply remove
it here.

> 
> Also, what about using dev_dbg()?  Is there a _once version that works
> for that?

There is a dev_WARN_ONCE(). Not sure if that would be a better replacement.
Probably not.

The entire em28xx driver needs to be replaced to use dev_dbg() instead of
implementing their own printk logic. This is one of the things that it is
on my todo list (with very low priority, when compared with other things).

Regards,
Mauro
