Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:48186 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756991Ab0DIIbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Apr 2010 04:31:35 -0400
Message-ID: <8c0ad8ce32382165227407b11ee1f073.squirrel@www.hardeman.nu>
In-Reply-To: <4BBEE27E.5000007@linuxtv.org>
References: <20100408230246.14453.97377.stgit@localhost.localdomain>
    <20100408230440.14453.36936.stgit@localhost.localdomain>
    <4BBEE27E.5000007@linuxtv.org>
Date: Fri, 9 Apr 2010 10:31:34 +0200 (CEST)
Subject: Re: [PATCH 4/4] Add RC6 support to ir-core
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: "Andreas Oberritter" <obi@linuxtv.org>
Cc: mchehab@redhat.com, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, April 9, 2010 10:17, Andreas Oberritter wrote:
>> +/* from ir-rc6-decoder.c */
>> +#ifdef CONFIG_IR_RC5_DECODER_MODULE
>
> you probably intended to use CONFIG_IR_RC6_DECODER_MODULE instead.

Of course, thanks for noticing.

Mauro, do you want a new patch or will you fix it yourself? (and by the
way, Mauro, how come the patches went straight to the v4l-dvb.git tree? I
assume they'll be merged back to your ir.git tree at a later stage?)

-- 
David Härdeman

