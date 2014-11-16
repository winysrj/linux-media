Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58641 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbaKPPJL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Nov 2014 10:09:11 -0500
Message-ID: <5468BE0D.7020609@iki.fi>
Date: Sun, 16 Nov 2014 17:09:01 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/8] rtl2832: implement PIP mode
References: <1415766190-24482-1-git-send-email-crope@iki.fi>	<1415766190-24482-3-git-send-email-crope@iki.fi>	<20141114173440.427324a8@recife.lan>	<54669210.1070101@iki.fi> <20141116082518.2144d9af@recife.lan> <54688C45.1080507@southpole.se>
In-Reply-To: <54688C45.1080507@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/16/2014 01:36 PM, Benjamin Larsson wrote:
> On 11/16/2014 11:25 AM, Mauro Carvalho Chehab wrote:
>>
>> [...]
>> What demod(s) are exposed to userspace? both or just demod#1?
>>
>> If both are exposed, how userspace knows that demod#0 should not be
>> used?
>>
>> Regards,
>> Mauro
>>
>
> Currently both demods are exposed to userspace. While it is nice to have
> both I suggest that if a NM8847x demod is activated only expose that
> demod. That would remove the hack in master and would make it possible
> to faster move the NM8847x demods out of staging. The main reason for
> this hardware is the DVB-C and DVB-T2 support. Lets focus on getting
> that in an easy obtainable way.

Yeah, both demods are exposed on single adapter, but two frontends.
frontend0 == DVB-T demod RTL2832
frontend1 == DVB-T/T2/C demod MN88472

frontend0 is pretty useless if frontend1 is loaded...

regards
Antti

-- 
http://palosaari.fi/
