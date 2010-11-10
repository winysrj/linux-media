Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:41501 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab0KJJa6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 04:30:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 10 Nov 2010 10:30:57 +0100
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: <linux-media@vger.kernel.org>, <jarod@wilsonet.com>
Subject: Re: [PATCH 6/7] ir-core: make struct =?UTF-8?Q?rc=5Fdev=20the=20primary?=
 =?UTF-8?Q?=20interface?=
In-Reply-To: <4CDA201C.7020009@infradead.org>
References: <20101029190745.11982.75723.stgit@localhost.localdomain> <20101029190823.11982.88750.stgit@localhost.localdomain> <4CDA201C.7020009@infradead.org>
Message-ID: <46602391f22d6fcce432680599c3355e@hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 10 Nov 2010 02:31:24 -0200, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Em 29-10-2010 17:08, David Härdeman escreveu:
>> This patch merges the ir_input_dev and ir_dev_props structs into a
single
>> struct called rc_dev. The drivers and various functions in rc-core used
>> by the drivers are also changed to use rc_dev as the primary interface
>> when dealing with rc-core.
>> 
>> This means that the input_dev is abstracted away from the drivers which
>> is necessary if we ever want to support multiple input devs per rc
>> device.
>> 
>> The new API is similar to what the input subsystem uses, i.e:
>> rc_device_alloc()
>> rc_device_free()
>> rc_device_register()
>> rc_device_unregister()
>> 
> 
> 
> David,
> 
>> +	struct rc_dev *rdev;
> ...
>> +	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
> 
>> +	struct rc_dev          *rc;
> 
> 
> A quick comment: try to call this struct with the same name on all
places,
> avoiding to call it as just "dev". It makes harder to understand the
code,
> especially on complex devices that have several types of dev's. The
better
> is to always call it as "rc_dev".

Fair enough. I can fix that in a separate patch, or in a respin of my
original patch. But first I need to know what I should base a new patch
on...I'm confused by now


-- 
David Härdeman
