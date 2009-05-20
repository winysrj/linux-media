Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57531 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbZETClL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 22:41:11 -0400
Date: Tue, 19 May 2009 23:41:06 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	LinuxML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [09051_49] Siano: smscore - upgrade firmware loading
 engine
Message-ID: <20090519234106.41a6d362@pedra.chehab.org>
In-Reply-To: <15860.11754.qm@web110806.mail.gq1.yahoo.com>
References: <15860.11754.qm@web110806.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 May 2009 11:01:22 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> escreveu:

> 
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> > 
> > 
> > 
> > This patch should not be merged in its current form.
> > 
> > Linux kernel driver development shall be against the
> > current -rc
> > kernel, and there is no need to reinvent the
> > "REQUEST_FIRMWARE"
> > mechanism.
> > 
> > Furthermore, the changeset introduces more bits of this
> > "SMS_HOSTLIB_SUBSYS" -- this requires a binary library
> > present on the
> > host system.  This completely violates the "no
> > multiple APIs in
> > kernel" and "no proprietary APIs in kernel" guidelines.
> > 
> > Uri, what are your plans for this?
> > 
> > Regards,
> > 
> > Mike
> > 
> 
> Mike,
> 
> Per discussion with other members of the community, backport are welcome at LinuxTV mercurial (true they are not pass through when up-streaming to the kernel git, but that is per current kernel version anyway ...). 

It is ok to add backport support, but the above seems a little dirty: or you
check for a kernel version or for a #define'd symbol. You can add some #defines
and let v4l/scripts/make_config.pl to evaluate it depending on some kernel .h
file.

> Regarding the REQUEST_FIRMWARE - with most older kernels, and with some new (I even have such 2.6.27 case), that is the only option available, Please check Motorola (opensource.motorola.com) and Google Android for external examples. Second issue is that when you are using interface like SPI, the hotplug mechanism is degenerated or simply voided. So we can either decide we support only x86 based machines, but if I'm not wrong, I can see lots of TI OMAP (and other ARM) activity lately, so, we may decide to support REQUEST_FIRMWARE...  

I'm not sure how this is is done on external trees, but we shouldn't do it in
kernel. With embedded devices in mind, kernel already supports a way where the firmware
binary is linked inside the driver and the request_firmware() call is converted
on just a register load. So (except due to backport issues), this is not needed.

> 
> Regarding SMS_HOSTLIB_SUBSYS, since it's not defined its... undefined...
> The patch replace '#if 0' with '#ifdef SMS_HOSTLIB_SUBSYS' (which is... undefined), so actually no "harm" done, but it make the life of Siano's engineers, and various other who use patches and merges, easier when looking at the code (IMHO strings are better than magic numbers). I simply don't see what's wrong with that.

While keeping backports are ok, I agree with Michael about this: any support
for an external API should be removed.

If the issue here is to allow your engineers to sync your internal code with
Linux driver, I suggest you to have those if's on your internal tree, and use a
script like v4l/scripts/gentree.pl [1] to remove those symbols before submitting us
any patch.

Btw, why do you need a proprietary API? If it is due to the lack of some DVB
features, let's add it into DVBv5.

[1] gentree.pl is the script I use here to sync our out-of-tree v4l-dvb
mercurial tree with -git. It basically evaluates kernel versions
and removes or inserts code based on some compatibility defines we have. For example:

my %defs = (
        'I2C_CLASS_TV_ANALOG' => 1,
        'NEED_SOUND_DRIVER_H' => 0,
);

Will make it to include any code with:

#ifdef I2C_CLASS_TV_ANALOG
	<some code to be included>
#endif

and remove any code inside:

#ifdef NEED_SOUND_DRIVER_H
	<some code to be excluded>
#endif

You can even have nested if's inside the code.



Cheers,
Mauro
