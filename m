Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55306 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab2ANPfR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 10:35:17 -0500
Message-ID: <4F11A0B3.9000102@iki.fi>
Date: Sat, 14 Jan 2012 17:35:15 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Patrick Boettcher <pboettcher@kernellabs.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH RFCv2] add DTMB support for DVB API
References: <4F119FC4.3090103@iki.fi>
In-Reply-To: <4F119FC4.3090103@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/14/2012 05:31 PM, Antti Palosaari wrote:
> +typedef enum fe_interleaving {
> + INTERLEAVING_NONE,
> + INTERLEAVING_240,
> + INTERLEAVING_720,
> +} fe_interleaving_t;

Checkpatch didn't like that, but I left it as all the others are 
similar. I am happy to fix it too if there is idea what it should be.

WARNING: do not add new typedefs
#165: FILE: include/linux/dvb/frontend.h:225:
+typedef enum fe_interleaving {


Antti

-- 
http://palosaari.fi/
