Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:47921 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab0KJEb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Nov 2010 23:31:29 -0500
Message-ID: <4CDA201C.7020009@infradead.org>
Date: Wed, 10 Nov 2010 02:31:24 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: linux-media@vger.kernel.org, jarod@wilsonet.com
Subject: Re: [PATCH 6/7] ir-core: make struct rc_dev the primary interface
References: <20101029190745.11982.75723.stgit@localhost.localdomain> <20101029190823.11982.88750.stgit@localhost.localdomain>
In-Reply-To: <20101029190823.11982.88750.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 29-10-2010 17:08, David Härdeman escreveu:
> This patch merges the ir_input_dev and ir_dev_props structs into a single
> struct called rc_dev. The drivers and various functions in rc-core used
> by the drivers are also changed to use rc_dev as the primary interface
> when dealing with rc-core.
> 
> This means that the input_dev is abstracted away from the drivers which
> is necessary if we ever want to support multiple input devs per rc device.
> 
> The new API is similar to what the input subsystem uses, i.e:
> rc_device_alloc()
> rc_device_free()
> rc_device_register()
> rc_device_unregister()
> 


David,

> +	struct rc_dev *rdev;
...
> +	struct rc_dev			*dev;		/* pointer to the parent rc_dev */

> +	struct rc_dev          *rc;


A quick comment: try to call this struct with the same name on all places,
avoiding to call it as just "dev". It makes harder to understand the code,
especially on complex devices that have several types of dev's. The better
is to always call it as "rc_dev".

Cheers,
Mauro
