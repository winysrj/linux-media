Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:49838 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966450AbaLMLM0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 06:12:26 -0500
Message-ID: <548C1F19.1060809@southpole.se>
Date: Sat, 13 Dec 2014 12:12:25 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/4] mn88472: implemented ber reporting
References: <1418429925-16342-1-git-send-email-benjamin@southpole.se> <1418429925-16342-4-git-send-email-benjamin@southpole.se> <548BBD4D.3060001@iki.fi>
In-Reply-To: <548BBD4D.3060001@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/13/2014 05:15 AM, Antti Palosaari wrote:
> On 12/13/2014 02:18 AM, Benjamin Larsson wrote:
>> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
>
> Reviewed-by: Antti Palosaari <crope@iki.fi>
>
>
> Even I could accept that, as a staging driver, I see there some issues:
>
> * missing commit message (ok, it is trivial and patch subject says)
>
> * it is legacy DVBv3 API BER reporting, whilst driver is DVBv5 mostly 
> due to DVB-T2... So DVBv5 statistics are preferred.
>
> * dynamic debugs has unneded __func__,  see 
> Documentation/dynamic-debug-howto.txt
>
> * there should be spaces used around binary and ternary calculation 
> operators, see Documentation/CodingStyle for more info how it should be.
>
>
> Could you read overall these two docs before make new patches:
> Documentation/CodingStyle
> Documentation/dynamic-debug-howto.txt
>
> also use scripts/checkpatch.pl to verify patch, like that
> git diff | ./scripts/checkpatch.pl -
>
> regards
> Antti

I will read those. Can you recommend a driver as template for DVBv5 
statistics ?

MvH
Benjamin Larsson
