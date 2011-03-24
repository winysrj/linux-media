Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62618 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933328Ab1CXSc1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 14:32:27 -0400
Received: by vxi39 with SMTP id 39so227836vxi.19
        for <linux-media@vger.kernel.org>; Thu, 24 Mar 2011 11:32:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D8B77E5.5030602@jusst.de>
References: <BLU0-SMTP178757907CEF2BB7BC4D728D8B70@phx.gbl>
	<4D8B77E5.5030602@jusst.de>
Date: Thu, 24 Mar 2011 19:32:26 +0100
Message-ID: <AANLkTinbUxqwH0Cgi5Rx7TNx33W7ckFavYD9gCv4OC_H@mail.gmail.com>
Subject: Re: S2-3200 switching-timeouts on 2.6.38
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: Julian Scheel <julian@jusst.de>
Cc: "H. Ellenberger" <tuxoholic@hotmail.de>,
	linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/3/24 Julian Scheel <julian@jusst.de>:
> Hi,
>
> Am 23.03.2011 19:19, schrieb H. Ellenberger:
>>
>> @Manu: Your argumentation is inconsistent and lacks any proof.
>>
>> Running a full scan of Astra 19.2 E with Kaffeine together with cards
>> model
>> Skystar HD and Twinhan/Azurewave VP-1041 results in a channel list of
>> approx
>> 400 stations only. When I apply my patch then almost all stations are
>> found:
>>
>> patch in tuner: 400 stations found, not usable,
>
> With KNC TV-Station DVB-S2 (which is stb0899 as well) I can't confirm this
> issue. Channel search finds > 1000 channels at any time.
>
>> patch in tuner + demod: 1127 stations found, better but less than without
>> tuner patch.
>> patch in demod only: 1145 stations found, slightly more than with tuner
>> patch.
>
> Have you done both searches at (almost) same time? On astra network there
> are quite some channels, which are only available and announced at certain
> time, which can make a noticable difference in the amount of channels found.

It has been done some work (and effort), to prove its having positive
effect. you should allways
have more then 1000 stations at any time on that SAT, if you see that maximum
number of stations is somewhere at 1600. everything around 400 is
broken hardware or driver.

Please dont consider his post as single experience of a single user. The general
perception was more like "Wow i can finally use that card and don't
throw it away."
 from 10+ Users which i know of. So no matter if its considered done
right or not.
The tuning patch is out of question of improving the usability of the
affected cards.

The request has been, to prove that the changes at the stb6100 is not
enough to actually
fix the problem. This prove has been done now . The changes on the
stb6100 is not enough,
the changes at the stb0899 still has quite positive effect.

So taking into account that the patch improves situation and doesn't
have negative side
effects for others, it might be wise to consider inclusion of the
patch, even if it might not
be the perfect solution from technical/theoretical perspective.

I dont want to complain until the patch is in, its just: We have a
problem, we have a solution.
Lets use it and make this hardware useful for the people and lets do
it right when time permits.

There is still a handful of other patches for the same hardware
floating around to improve other parts of that driver.

I mean this hardware is known to work "less then perfect" since years, really.

So please do something about it. Accept the helping hands.

Thanks
