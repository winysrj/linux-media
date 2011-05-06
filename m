Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:33505 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab1EFKGp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 May 2011 06:06:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 06 May 2011 12:06:43 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/10] rc-core: my current patchqueue
In-Reply-To: <4DC16D2D.2080205@gmail.com>
References: <20110428151311.8272.17290.stgit@felix.hardeman.nu> <1304021602.3288.5.camel@localhost> <fb1dfe1e7035bbcf648a4bf908a7d1a4@hardeman.nu> <4DC16D2D.2080205@gmail.com>
Message-ID: <8ce83abfc2ccb0cb54318931a60a7a56@hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 04 May 2011 12:13:49 -0300, Mauro Carvalho Chehab
<maurochehab@gmail.com> wrote:
> Em 29-04-2011 05:08, David Härdeman escreveu:
>> diff --git a/drivers/media/rc/keymaps/rc-videomate-s350.c
>> b/drivers/media/rc/keymaps/rc-videomate-s350.c
>> index 26ca260..2f0ec1f 100644
>> --- a/drivers/media/rc/keymaps/rc-videomate-s350.c
>> +++ b/drivers/media/rc/keymaps/rc-videomate-s350.c
>> @@ -13,57 +13,56 @@
>>  #include <media/rc-map.h>
>>  
>>  static struct rc_map_table videomate_s350[] = {
>> -	{ 0x00, KEY_TV},
...
>> +	{ RC_TYPE_UNKNOWN, RC_SCANCODE_UNKNOWN(0x00), KEY_TV},
>>  };

> However, changes like the above makes the keymaps confusing and breaks
the
> v4l-utils sync scripts without a good reason.

First of all, I've missed that there are v4l-utils sync scripts.

Second of all, I think you can ignore this patch for now. It's actually a
much better idea to keep the rc_map and rc_map_table structs the way they
are (thereby reducing the patch size) and introduce new structs to be used
in rc_dev for maintaining the actual live keytable (and store the
protocol for each scancode in the new struct instead).

That way drivers/media/rc/keymaps/ won't see so much churn.

-- 
David Härdeman
