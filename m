Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:49777 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274AbaLMLJK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 06:09:10 -0500
Message-ID: <548C1E53.10408@southpole.se>
Date: Sat, 13 Dec 2014 12:09:07 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] rtl28xxu: swap frontend order for devices with slave
 demodulators
References: <1418429925-16342-1-git-send-email-benjamin@southpole.se> <1418429925-16342-2-git-send-email-benjamin@southpole.se> <548BBA41.7000109@iki.fi>
In-Reply-To: <548BBA41.7000109@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/13/2014 05:02 AM, Antti Palosaari wrote:
> I am not sure even idea of that. You didn't add even commit 
> description, like all the other patches too :( You should really start 
> adding commit messages explaining why and how commit is.
>
> So the question is why that patch should be applied?

Lots of legacy applications doesn't set the frontend number and use 0 by 
default. For me to use w_scan I need this change. If that is reason good 
enough I can amend that to the commit message and resend?

>
> On the other-hand, how there is
> if (fe->id == 1 && onoff) {
> ... as I don't remember any patch changing it to 0. I look my tree FE 
> ID is 0. Do you have some unpublished hacks?

No hacks, it works for me that way.

>
> Antti
MvH
Benjamin Larsson


