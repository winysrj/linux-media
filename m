Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48410 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030889AbaLMNfU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 08:35:20 -0500
Message-ID: <548C4096.5030401@iki.fi>
Date: Sat, 13 Dec 2014 15:35:18 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] rtl28xxu: swap frontend order for devices with slave
 demodulators
References: <1418429925-16342-1-git-send-email-benjamin@southpole.se> <1418429925-16342-2-git-send-email-benjamin@southpole.se> <548BBA41.7000109@iki.fi> <548C1E53.10408@southpole.se>
In-Reply-To: <548C1E53.10408@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/13/2014 01:09 PM, Benjamin Larsson wrote:
> On 12/13/2014 05:02 AM, Antti Palosaari wrote:
>> I am not sure even idea of that. You didn't add even commit
>> description, like all the other patches too :( You should really start
>> adding commit messages explaining why and how commit is.
>>
>> So the question is why that patch should be applied?
>
> Lots of legacy applications doesn't set the frontend number and use 0 by
> default. For me to use w_scan I need this change. If that is reason good
> enough I can amend that to the commit message and resend?
>
>>
>> On the other-hand, how there is
>> if (fe->id == 1 && onoff) {
>> ... as I don't remember any patch changing it to 0. I look my tree FE
>> ID is 0. Do you have some unpublished hacks?
>
> No hacks, it works for me that way.

Do you understand that code at all?

Now it is:
FE0 == (fe->id == 0) == RTL2832
FE1 == (fe->id == 1) == MN88472

you changed it to:
FE0 == (fe->id == 0) == MN88472
FE1 == (fe->id == 1) == RTL2832

Then there is:

/* bypass slave demod TS through master demod */
if (fe->id == 1 && onoff) {
	ret = rtl2832_enable_external_ts_if(adap->fe[1]);
	if (ret)
		goto err;
}

After your change that code branch is taken when RTL2832 demod is 
activated / used. Shouldn't TS bypass enabled just opposite, when 
MN88472 is used....


Antti

-- 
http://palosaari.fi/
