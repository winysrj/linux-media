Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758157Ab2ANWaU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 17:30:20 -0500
Message-ID: <4F1201E9.3090402@redhat.com>
Date: Sat, 14 Jan 2012 20:30:01 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH RFCv2] add DTMB support for DVB API
References: <4F119FC4.3090103@iki.fi> <4F11A0B3.9000102@iki.fi>
In-Reply-To: <4F11A0B3.9000102@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-01-2012 13:35, Antti Palosaari escreveu:
> On 01/14/2012 05:31 PM, Antti Palosaari wrote:
>> +typedef enum fe_interleaving {
>> + INTERLEAVING_NONE,
>> + INTERLEAVING_240,
>> + INTERLEAVING_720,
>> +} fe_interleaving_t;
> 
> Checkpatch didn't like that, but I left it as all the others are similar. I am happy to fix it too if there is idea what it should be.
> 
> WARNING: do not add new typedefs
> #165: FILE: include/linux/dvb/frontend.h:225:
> +typedef enum fe_interleaving {


Just use:

enum fe_interleaving {
	...
};

having a typedef here won't help at all, as the DVBv5 API uses "u32" for
the types. So, a typecast will happen anyway every time this is used.

Regards,
Mauro.
