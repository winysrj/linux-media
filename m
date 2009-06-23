Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp19.orange.fr ([80.12.242.1]:7447 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbZFWMAW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 08:00:22 -0400
Received: from smtp19.orange.fr (mwinf1928 [172.22.129.128])
	by mwinf1905.orange.fr (SMTP Server) with ESMTP id EA2D21C01E15
	for <linux-media@vger.kernel.org>; Tue, 23 Jun 2009 13:02:31 +0200 (CEST)
Message-ID: <4A40B61F.7080405@orange.fr>
Date: Tue, 23 Jun 2009 13:01:51 +0200
From: claude <claude.vezzi@orange.fr>
MIME-Version: 1.0
To: Terry Wu <terrywu2009@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: PxDVR3200 H LinuxTV v4l-dvb patch : Pull GPIO-20 low for DVB-T
References: <6ab2c27e0906222039y5b931f46vf7692d6e46248b68@mail.gmail.com>
In-Reply-To: <6ab2c27e0906222039y5b931f46vf7692d6e46248b68@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terry Wu a écrit :
> Hi,
>
>     I add the following codes in the cx23885_initialize() of cx25840-core.c:
> 	/* Drive GPIO2 (GPIO 19~23) direction and values for DVB-T */
> 	cx25840_and_or(client, 0x160, 0x1d, 0x00);
> 	cx25840_write(client, 0x164, 0x00);
>
>     Before that, the tuning status is 0x1e, but <0> service found.
>     Now, I can watch DVB-T (Taiwan, 6MHz bandwidth).
>
>     And if you are living in Australia, you should update the
> tuner-xc2028.c too:
>     http://tw1965.myweb.hinet.net/Linux/v4l-dvb/20090611-TDA18271HDC2/tuner-xc2028.c
>
> Best Regards,
> Terry
>   
I have updaded the cx23885_initialize() function of the  cx25840-core.c 
file with your codes.

But with the new built kernel i have the same error both with scan and 
kaffeine.

Best regards

Claude



