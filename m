Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34665 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698Ab1LWITy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Dec 2011 03:19:54 -0500
Message-ID: <4EF439A8.4000504@iki.fi>
Date: Fri, 23 Dec 2011 10:19:52 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?TWlyb3NsYXYgU2x1Z2XFiA==?= <thunder.mmm@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Add tuner_type to zl10353 config and use it for reporting signal
 directly from tuner.
References: <CAEN_-SAuS1UTfLcJUpVP-WYeLVVj4-ycF0NyaEi=iQ0AnVbZEQ@mail.gmail.com> <CAEN_-SDLLY8Ba--KTbqSGBNoNkWhh+_A-Y+gCy3B=c1_yEBV7g@mail.gmail.com> <4EF43856.6040408@iki.fi>
In-Reply-To: <4EF43856.6040408@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/23/2011 10:14 AM, Antti Palosaari wrote:
> On 12/23/2011 01:45 AM, Miroslav Slugeň wrote:
>> This patch is wrong, please use 8971 instead.
>
> Could you explain which is wrong? Your old code or that new override
> version I explained?
>
> fe->ops.read_signal_strength = fe->ops.tuner_ops.get_rf_strength;


aargh, surely you are speaking patchwork IDs... my mistake.


Antti


-- 
http://palosaari.fi/
