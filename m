Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab0ECTt3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 May 2010 15:49:29 -0400
Message-ID: <4BDF28C0.4060102@redhat.com>
Date: Mon, 03 May 2010 16:49:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/4] ir-core: centralize sysfs raw decoder enabling/disabling
References: <20100424210843.11570.82007.stgit@localhost.localdomain> <20100424211406.11570.96241.stgit@localhost.localdomain>
In-Reply-To: <20100424211406.11570.96241.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

David Härdeman wrote:
> With the current logic, each raw decoder needs to add a copy of the exact
> same sysfs code. This is both unnecessary and also means that (re)loading
> an IR driver after raw decoder modules have been loaded won't work as
> expected.
> 
> This patch moves that logic into ir-raw-event and adds a single sysfs
> file per device.
> 
> Reading that file returns something like:
> 
> 	"rc5 [rc6] nec jvc [sony]"
> 
> (with enabled protocols in [] brackets)
> 
> Writing either "+protocol" or "-protocol" to that file will
> enable or disable the according protocol decoder.
> 
> An additional benefit is that the disabling of a decoder will be
> remembered across module removal/insertion so a previously
> disabled decoder won't suddenly be activated again. The default
> setting is to enable all decoders.
> 
> This is also necessary for the next patch which moves even more decoder
> state into the central raw decoding structs.

I liked the idea of your redesign, but I didn't like the removal of
a per-decoder sysfs entry. As already discussed, there are cases where
we'll need a per-decoder sysfs entry (lirc_dev is probably one of those
cases - also Jarod's imon driver is currently implementing a modprobe
parameter that needs to be moved to the driver).

So, while we can implement some core support at the raw event core, we should
keep the decoder attributes internally inside the driver. So, each decoder
may have his own code like:

static struct attribute *decoder_attributes[] = {
       &dev_attr_enabled.attr,
       &dev_attr_bar1.attr,
       &dev_attr_bar2.attr,
       &dev_attr_bar3.attr,
       NULL
};

static struct attribute_group decoder_attribute_group = {
       .name   = "foo_decoder",
       .attrs  = decoder_attributes,
};

As the attr_enabled is common to all, maybe we can have a default enable
code at the .h or inside the core.
 
Cheers,
Mauro
