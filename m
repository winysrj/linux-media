Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab1LVT43 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 14:56:29 -0500
Message-ID: <4EF38B5B.8020408@redhat.com>
Date: Thu, 22 Dec 2011 17:56:11 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Subject: Re: which is correct name DTMB or CTTB?
References: <4EF1ACA3.8080808@iki.fi> <4EF35EB5.5010700@iki.fi>
In-Reply-To: <4EF35EB5.5010700@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22-12-2011 14:45, Antti Palosaari wrote:
> On 12/21/2011 11:53 AM, Antti Palosaari wrote:
>> I am adding DTMB/CTTB support for the Linux Kernel DVB API. Do anyone
>> have clear idea which correct name?
>>
>> Background of that discussion can be found from the following patch:
>> http://patchwork.linuxtv.org/patch/8827/
> 
> There is already defined delivery system SYS_DMBTH. It have been from the time S2API was introduced coming from the patch: 6b73eeafbc856c0cef7166242f0e55403407f355
> 
> include/linux/dvb/frontend.h
> 
> Should I change that name? Or introduce new names using define? Or just leave it as it is. No single driver is using that because all existing DTMB/CTTB/DMB-TH drivers are abusing DVB-T...

> 
> I still think it is rather safe to change better one, there is likely no user space apps using that yet...

Feel free to change it, as nobody is using it yet.

In a matter of fact, I wrote today one patch using it, but I'll rebase my patch to
the name you define.

> 
> regards
> Antti

