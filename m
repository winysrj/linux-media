Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420Ab0EHWnY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 May 2010 18:43:24 -0400
Message-ID: <4BE5E89C.2090405@redhat.com>
Date: Sat, 08 May 2010 19:41:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: LMML <linux-media@vger.kernel.org>, awalls@md.metrocast.net,
	moinejf@free.fr, g.liakhovetski@gmx.de, pboettcher@dibcom.fr,
	awalls@radix.net, crope@iki.fi, davidtlwong@gmail.com,
	liplianin@tut.by, isely@isely.net, tobias.lorenz@gmx.net,
	hdegoede@redhat.com, abraham.manu@gmail.com,
	u.kleine-koenig@pengutronix.de, stoth@kernellabs.com,
	henrik@kurelid.se
Subject: Re: Status of the patches under review (85 patches) and some misc
 notes about the devel procedures
References: <20100507093916.2e2ef8e3@pedra> <201005080234.05889.herton@mandriva.com.br>
In-Reply-To: <201005080234.05889.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> Em Sex 07 Mai 2010, às 09:39:16, Mauro Carvalho Chehab escreveu:
>> 		== Patch(broken) - waiting for Herton Ronaldo Krzesinski <herton@mandriva.com.br> new submission == 
>>
>> Apr, 5 2010: saa7134: add support for Avermedia M733A                               http://patchwork.kernel.org/patch/90692
> 
> Hi, I submitted now a new fixed version of the patch to mailing list, under
> title "[PATCH v2] saa7134: add support for Avermedia M733A"

OK, thanks!

>> Mar,19 2010: saa7134: add support for one more remote control for Avermedia M135A   http://patchwork.kernel.org/patch/86989
> 
> This was the addition of RM-K6 remote control to M135A too, I think we can drop
> this, since adding this to the kernel is deprecated now in favour of assigning
> keymaps in userspace (keytable tool from v4l-utils), right?

For now, I prefer to add the keytab there, since there are some scripts that syncs v4l-util
keytables with the kernel ones. If you prefer, you may the put RM-K6 table together
with the other M135A keytable. I intend to group the non-conflicting keytables soon,
and it makes kense to group both the original and the RM-K6 into the same table, in order to 
provide an easier hot-plug support for this device.

-- 

Cheers,
Mauro
