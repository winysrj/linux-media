Return-path: <mchehab@pedra>
Received: from fmmailgate02.web.de ([217.72.192.227]:40386 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab0JRI1U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 04:27:20 -0400
Message-ID: <4CBC04E2.10701@web.de>
Date: Mon, 18 Oct 2010 10:27:14 +0200
From: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: mchehab@redhat.com
Subject: Re: [PATCH] faster DVB-S lock with cards using stb0899 demod
References: <BLU0-SMTP1574ECDF1FB4B418ACB34CED87D0@phx.gbl>
In-Reply-To: <BLU0-SMTP1574ECDF1FB4B418ACB34CED87D0@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Mauro,

On 19.09.2010 11:46, SE wrote:
> hi list
>
> v4l-dvb still lacks fast and reliable dvb-s lock for stb08899 chipsets. This
> problem was adressed by Alex Betis two years ago [1]+[2]resulting in a patch
> [3] that made its way into s2-liplianin, not v4l-dvb.
>
> With minor adjustments by me this patch now offers reliable dvb-s/dvb-s2 lock
> for v4l-dvb, most of them will lock in less than a second. Without the patch
> many QPSK channels won't lock at all or within a 5-20 second delay.

Can you please comment on this patch and tell us if you are considering 
this patch for integration into the v4l git tree?

Regards
  André
