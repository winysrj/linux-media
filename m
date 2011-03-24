Return-path: <mchehab@pedra>
Received: from smtp.work.de ([212.12.45.188]:42108 "EHLO smtp2.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab1CXTj5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 15:39:57 -0400
Message-ID: <4D8B9E0B.5070901@jusst.de>
Date: Thu, 24 Mar 2011 20:39:55 +0100
From: Julian Scheel <julian@jusst.de>
MIME-Version: 1.0
To: Steffen Barszus <steffenbpunkt@googlemail.com>
CC: "H. Ellenberger" <tuxoholic@hotmail.de>,
	linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: S2-3200 switching-timeouts on 2.6.38
References: <BLU0-SMTP178757907CEF2BB7BC4D728D8B70@phx.gbl>	<4D8B77E5.5030602@jusst.de> <AANLkTinbUxqwH0Cgi5Rx7TNx33W7ckFavYD9gCv4OC_H@mail.gmail.com>
In-Reply-To: <AANLkTinbUxqwH0Cgi5Rx7TNx33W7ckFavYD9gCv4OC_H@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am 24.03.2011 19:32, schrieb Steffen Barszus:
> It has been done some work (and effort), to prove its having positive
> effect. you should allways
> have more then 1000 stations at any time on that SAT, if you see that maximum
> number of stations is somewhere at 1600. everything around 400 is
> broken hardware or driver.

Agreed, but this is why I asked about the difference between the channel 
search with stb6100 patch only and both patches applied.
Nobody says that 400 channels are expected behaviour.
But the difference of less than 20 channels between both patches could 
easily be caused by temporal availability of services. This is all I 
said and all I suggested to proof.

Even a simple diff of both searches would be helpful. Just to check 
which channels are missing.

I am not in the position to accept or reject this driver, just wanted to 
be helpful in finding out if it's really needed.

> Please dont consider his post as single experience of a single user. The general
> perception was more like "Wow i can finally use that card and don't
> throw it away."
>   from 10+ Users which i know of. So no matter if its considered done
> right or not.
> The tuning patch is out of question of improving the usability of the
> affected cards.
>
> The request has been, to prove that the changes at the stb6100 is not
> enough to actually
> fix the problem. This prove has been done now . The changes on the
> stb6100 is not enough,
> the changes at the stb0899 still has quite positive effect.
>
> So taking into account that the patch improves situation and doesn't
> have negative side
> effects for others, it might be wise to consider inclusion of the
> patch, even if it might not
> be the perfect solution from technical/theoretical perspective.
>
> I dont want to complain until the patch is in, its just: We have a
> problem, we have a solution.
> Lets use it and make this hardware useful for the people and lets do
> it right when time permits.
>
> There is still a handful of other patches for the same hardware
> floating around to improve other parts of that driver.
>
> I mean this hardware is known to work "less then perfect" since years, really.
>
> So please do something about it. Accept the helping hands.
>
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

