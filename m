Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab0F1Q4d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jun 2010 12:56:33 -0400
Message-ID: <4C28D430.9010305@redhat.com>
Date: Mon, 28 Jun 2010 13:56:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: jarod@wilsonet.com, jarod@redhat.com, linux-media@vger.kernel.org,
	linux-input@vger.kernel.org
Subject: Re: [PATCH 1/2] ir-core: centralize sysfs raw decoder enabling/disabling
References: <20100613202718.6044.29599.stgit@localhost.localdomain> <20100613202930.6044.97940.stgit@localhost.localdomain>
In-Reply-To: <20100613202930.6044.97940.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 13-06-2010 17:29, David Härdeman escreveu:
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
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>

> +	if (!strncasecmp(tmp, "unknown", 7)) {
> +		tmp += 7;
> +		mask = IR_TYPE_UNKNOWN;
> +	} else if (!strncasecmp(tmp, "rc5", 3)) {
> +		tmp += 3;
> +		mask = IR_TYPE_RC5;
> +	} else if (!strncasecmp(tmp, "nec", 3)) {
> +		tmp += 3;
> +		mask = IR_TYPE_NEC;
> +	} else if (!strncasecmp(tmp, "rc6", 3)) {
> +		tmp += 3;
> +		mask = IR_TYPE_RC6;
> +	} else if (!strncasecmp(tmp, "jvc", 3)) {
> +		tmp += 3;
> +		mask = IR_TYPE_JVC;
> +	} else if (!strncasecmp(tmp, "sony", 4)) {
> +		tmp += 4;
> +		mask = IR_TYPE_SONY;
> +	} else {
>  		IR_dprintk(1, "Unknown protocol\n");
>  		return -EINVAL;
>  	}

Those "magic" sizes at the strcasecmp are ugly. Also, you didn't send
a patch for the ir-keytable userspace tool (part of v4l-utils.git tree).

Also, this allows some undocumented (and problematic) ways to set protocols. 
For example, if someone writes: something like "rc5necjvcsony"
(on this exact order and without spaces), it will accept it as just "sony",
without complaining.

As I found some time during the weekend to add support for the new /protocols way at
the userspace tool, I'll be applying this patch as-is, plus a few patches after it 
fixing the problems I found and adding some additional features that will be needed,
in order to make userspace stuff easier, like supporting multiple protocols specs
without needing to close/open the sysfs node for each protocol.

Btw, we should start writing some docs about the sysfs interface at the media
specs (at Documentation/DocBoook).

Cheers,
Mauro
