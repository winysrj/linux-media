Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110806.mail.gq1.yahoo.com ([67.195.13.229]:29317 "HELO
	web110806.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751482AbZESSB1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 14:01:27 -0400
Message-ID: <15860.11754.qm@web110806.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 11:01:22 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: Re: [PATCH] [09051_49] Siano: smscore - upgrade firmware loading  engine
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: LinuxML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> This patch should not be merged in its current form.
> 
> Linux kernel driver development shall be against the
> current -rc
> kernel, and there is no need to reinvent the
> "REQUEST_FIRMWARE"
> mechanism.
> 
> Furthermore, the changeset introduces more bits of this
> "SMS_HOSTLIB_SUBSYS" -- this requires a binary library
> present on the
> host system.  This completely violates the "no
> multiple APIs in
> kernel" and "no proprietary APIs in kernel" guidelines.
> 
> Uri, what are your plans for this?
> 
> Regards,
> 
> Mike
> 

Mike,

Per discussion with other members of the community, backport are welcome at LinuxTV mercurial (true they are not pass through when up-streaming to the kernel git, but that is per current kernel version anyway ...). 

Regarding the REQUEST_FIRMWARE - with most older kernels, and with some new (I even have such 2.6.27 case), that is the only option available, Please check Motorola (opensource.motorola.com) and Google Android for external examples. Second issue is that when you are using interface like SPI, the hotplug mechanism is degenerated or simply voided. So we can either decide we support only x86 based machines, but if I'm not wrong, I can see lots of TI OMAP (and other ARM) activity lately, so, we may decide to support REQUEST_FIRMWARE...  

Regarding SMS_HOSTLIB_SUBSYS, since it's not defined its... undefined...
The patch replace '#if 0' with '#ifdef SMS_HOSTLIB_SUBSYS' (which is... undefined), so actually no "harm" done, but it make the life of Siano's engineers, and various other who use patches and merges, easier when looking at the code (IMHO strings are better than magic numbers). I simply don't see what's wrong with that.




      
