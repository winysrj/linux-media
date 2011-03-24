Return-path: <mchehab@pedra>
Received: from smtp.work.de ([212.12.45.188]:37087 "EHLO smtp2.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab1CXQ5M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 12:57:12 -0400
Message-ID: <4D8B77E5.5030602@jusst.de>
Date: Thu, 24 Mar 2011 17:57:09 +0100
From: Julian Scheel <julian@jusst.de>
MIME-Version: 1.0
To: "H. Ellenberger" <tuxoholic@hotmail.de>
CC: linux-media@vger.kernel.org
Subject: Re: S2-3200 switching-timeouts on 2.6.38
References: <BLU0-SMTP178757907CEF2BB7BC4D728D8B70@phx.gbl>
In-Reply-To: <BLU0-SMTP178757907CEF2BB7BC4D728D8B70@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Am 23.03.2011 19:19, schrieb H. Ellenberger:
> @Manu: Your argumentation is inconsistent and lacks any proof.
>
> Running a full scan of Astra 19.2 E with Kaffeine together with cards model
> Skystar HD and Twinhan/Azurewave VP-1041 results in a channel list of approx
> 400 stations only. When I apply my patch then almost all stations are found:
>
> patch in tuner: 400 stations found, not usable,

With KNC TV-Station DVB-S2 (which is stb0899 as well) I can't confirm 
this issue. Channel search finds > 1000 channels at any time.

> patch in tuner + demod: 1127 stations found, better but less than without
> tuner patch.
> patch in demod only: 1145 stations found, slightly more than with tuner patch.

Have you done both searches at (almost) same time? On astra network 
there are quite some channels, which are only available and announced at 
certain time, which can make a noticable difference in the amount of 
channels found.

-Julian
