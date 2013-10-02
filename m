Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47017 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab3JBXQu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Oct 2013 19:16:50 -0400
Message-ID: <524CA960.6080602@iki.fi>
Date: Thu, 03 Oct 2013 02:16:48 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Luis Alves <ljalvs@gmail.com>
CC: Michael Krufky <mkrufky@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>,
	mchehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/2] cx24117: Changed the way common data struct was being
 passed to the demod.
References: <1380751751-4842-1-git-send-email-ljalvs@gmail.com>	<524CA043.8080205@iki.fi> <CAGj5WxCGaBtJkAzram4LzFbe8pyn2_GKStUCSFisO4LYW5v+Qw@mail.gmail.com>
In-Reply-To: <CAGj5WxCGaBtJkAzram4LzFbe8pyn2_GKStUCSFisO4LYW5v+Qw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03.10.2013 01:54, Luis Alves wrote:
> I Antti,
>
> I think it's safe to use because the hybrid_tuner_request_state will
> make sure that the i2c_adapter_id is the same for both demods.

I also looked that tuner-i2c.h hybrid_tuner_request_state() and if I am 
not misunderstanding the criteria to return state is i2c adapter id and 
i2c slave address. Yea, it seems to be correct even there is quad card 
used as slave address must be different in that case!

regards
Antti

-- 
http://palosaari.fi/
