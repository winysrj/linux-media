Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab0DIMnj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Apr 2010 08:43:39 -0400
Message-ID: <4BBF20EF.6000407@redhat.com>
Date: Fri, 09 Apr 2010 09:43:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
CC: Andreas Oberritter <obi@linuxtv.org>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] Add RC6 support to ir-core
References: <20100408230246.14453.97377.stgit@localhost.localdomain>    <20100408230440.14453.36936.stgit@localhost.localdomain>    <4BBEE27E.5000007@linuxtv.org> <8c0ad8ce32382165227407b11ee1f073.squirrel@www.hardeman.nu>
In-Reply-To: <8c0ad8ce32382165227407b11ee1f073.squirrel@www.hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Härdeman wrote:
> On Fri, April 9, 2010 10:17, Andreas Oberritter wrote:
>>> +/* from ir-rc6-decoder.c */
>>> +#ifdef CONFIG_IR_RC5_DECODER_MODULE
>> you probably intended to use CONFIG_IR_RC6_DECODER_MODULE instead.

Andreas, thanks for pointing it!

> Of course, thanks for noticing.
> 
> Mauro, do you want a new patch or will you fix it yourself? 

Fixed. Just sent the correction patches upstream. As, in this case, it
doesn't break bisect, I just added a one-line change patch.

> (and by the
> way, Mauro, how come the patches went straight to the v4l-dvb.git tree? I
> assume they'll be merged back to your ir.git tree at a later stage?)

I just merged it back at the ir.git tree.

Cheers,
Mauro
