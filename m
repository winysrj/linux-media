Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:11791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab0JRMoM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 08:44:12 -0400
Message-ID: <4CBC4118.6040009@redhat.com>
Date: Mon, 18 Oct 2010 10:44:08 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] faster DVB-S lock with cards using stb0899 demod
References: <BLU0-SMTP1574ECDF1FB4B418ACB34CED87D0@phx.gbl> <4CBC04E2.10701@web.de>
In-Reply-To: <4CBC04E2.10701@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 18-10-2010 06:27, André Weidemann escreveu:
> Hello Mauro,
> 
> On 19.09.2010 11:46, SE wrote:
>> hi list
>>
>> v4l-dvb still lacks fast and reliable dvb-s lock for stb08899 chipsets. This
>> problem was adressed by Alex Betis two years ago [1]+[2]resulting in a patch
>> [3] that made its way into s2-liplianin, not v4l-dvb.
>>
>> With minor adjustments by me this patch now offers reliable dvb-s/dvb-s2 lock
>> for v4l-dvb, most of them will lock in less than a second. Without the patch
>> many QPSK channels won't lock at all or within a 5-20 second delay.
> 
> Can you please comment on this patch and tell us if you are considering this patch for integration into the v4l git tree?

You should ask s2-liplianin and stb08899 maintainers about that, and not me. Ideally,
patches at s2-liplianin that fixes bug or improves support should be rebased to upstream
and send to us, but, currently, I didn't see any effort from the maintainers to do it.

Cheers,
Mauro.
