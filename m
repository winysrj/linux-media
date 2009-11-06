Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:46661 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbZKFRGF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Nov 2009 12:06:05 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	openezx-devel@lists.openezx.org, Bart Visscher <bartv@thisnet.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] ezx: Add camera support for A780 and A910 EZX phones
References: <1257266734-28673-1-git-send-email-ospite@studenti.unina.it>
	<1257266734-28673-2-git-send-email-ospite@studenti.unina.it>
	<f17812d70911032238i3ae6fa19g24720662b9079f24@mail.gmail.com>
	<Pine.LNX.4.64.0911040907400.4837@axis700.grange>
	<20091104123536.9b95d161.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0911061720570.4389@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Fri, 06 Nov 2009 18:05:57 +0100
In-Reply-To: <Pine.LNX.4.64.0911061720570.4389@axis700.grange> (Guennadi Liakhovetski's message of "Fri\, 6 Nov 2009 17\:40\:14 +0100 \(CET\)")
Message-ID: <87y6mjlh1m.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Good that you mentioned this. In fact, I think, that .init should go. So 
> far it is used in pcm990-baseboard.c to initialise pins. You're doing 
> essentially the same - requesting and configuring GPIOs. And it has been 
> agreed, that there is so far no real case, where a static 
> GPIO-configuration wouldn't work. So, I would suggest you remove .init, 
> configure GPIOs statically. And then submit a patch to remove .init 
> completely from struct pxacamera_platform_data. Robert, do you agree?

Yes, fully agree, I think too that GPIO should be static.

Cheers.

--
Robert
