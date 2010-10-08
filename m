Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:13362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756835Ab0JHLwt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Oct 2010 07:52:49 -0400
Message-ID: <4CAF0602.6050002@redhat.com>
Date: Fri, 08 Oct 2010 08:52:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Felipe Sanches <juca@members.fsf.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH] Audio standards on tm6000
References: <4CAD5A78.3070803@redhat.com> <20101008150301.2e3ceaff@glory.local>
In-Reply-To: <20101008150301.2e3ceaff@glory.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 08-10-2010 16:03, Dmitri Belimov escreveu:
> Hi Mauro
> 
> Not so good. Audio with this patch has bad white noise sometimes and
> bad quality. I try found better configuration for SECAM-DK.

Ok. Well, feel free to modify it. I think that this approach may be better,
especially if we need to add later some sort of code to detect and change
audio standard for some standards that have more than one audio standard
associated (we needed do to it on other drivers, in order to work in Russia
and other Countries that use different variants of the audio standard).

The association between video and audio standard is not complete. For example,
it misses NTSC-Kr and NTSC-Jp.

Cheers,
Mauro.

