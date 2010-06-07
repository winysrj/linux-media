Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:54750 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab0FGS5d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 14:57:33 -0400
Date: Mon, 7 Jun 2010 20:48:36 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/4] ir-core: centralize sysfs raw decoder
 enabling/disabling
Message-ID: <20100607184836.GB19390@hardeman.nu>
References: <20100424210843.11570.82007.stgit@localhost.localdomain>
 <20100424211406.11570.96241.stgit@localhost.localdomain>
 <4BDF28C0.4060102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BDF28C0.4060102@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 03, 2010 at 04:49:20PM -0300, Mauro Carvalho Chehab wrote:
> Hi David,

Hi, sorry for dropping off the radar...life has been hetic...daughter in 
hospital (she's fine now).

> David Härdeman wrote:
> > With the current logic, each raw decoder needs to add a copy of the exact
> > same sysfs code. This is both unnecessary and also means that (re)loading
> > an IR driver after raw decoder modules have been loaded won't work as
> > expected.
> > 
> > This patch moves that logic into ir-raw-event and adds a single sysfs
> > file per device.
> > 
> > Reading that file returns something like:
> > 
> > 	"rc5 [rc6] nec jvc [sony]"
> > 
> > (with enabled protocols in [] brackets)
> > 
> > Writing either "+protocol" or "-protocol" to that file will
> > enable or disable the according protocol decoder.
> > 
> > An additional benefit is that the disabling of a decoder will be
> > remembered across module removal/insertion so a previously
> > disabled decoder won't suddenly be activated again. The default
> > setting is to enable all decoders.
> > 
> > This is also necessary for the next patch which moves even more decoder
> > state into the central raw decoding structs.
> 
> I liked the idea of your redesign, but I didn't like the removal of
> a per-decoder sysfs entry. As already discussed, there are cases where
> we'll need a per-decoder sysfs entry (lirc_dev is probably one of those
> cases - also Jarod's imon driver is currently implementing a modprobe
> parameter that needs to be moved to the driver).

per-decoder or per-decoder-per-receiver sysfs entries? If you want the 
latter, you'll need much more code than what is currently there to not 
break random module load order (which doesn't work with the current 
code).  Additionally, *if* imon and lirc_dev really need something like 
that, those modules should carry the burden.
 
> So, while we can implement some core support at the raw event core, we should
> keep the decoder attributes internally inside the driver.

Why?

> So, each decoder
> may have his own code like:
> 
> static struct attribute *decoder_attributes[] = {
>        &dev_attr_enabled.attr,
>        &dev_attr_bar1.attr,
>        &dev_attr_bar2.attr,
>        &dev_attr_bar3.attr,
>        NULL
> };
> 
> static struct attribute_group decoder_attribute_group = {
>        .name   = "foo_decoder",
>        .attrs  = decoder_attributes,
> };
> 
> As the attr_enabled is common to all, maybe we can have a default enable
> code at the .h or inside the core.

Smells like lots of duplicated code with no gain for the current set of 
decoders.


-- 
David Härdeman
