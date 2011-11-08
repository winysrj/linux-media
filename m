Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab1KHJM6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Nov 2011 04:12:58 -0500
Message-ID: <4EB8F295.7010908@redhat.com>
Date: Tue, 08 Nov 2011 07:12:53 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Stefan Ringel <stefan.ringel@arcor.de>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Fix tm6010 audio
References: <4E8C5675.8070604@arcor.de> <20111017155537.6c55aec8@glory.local> <4E9C65CD.2070409@arcor.de> <20111108104500.2f0fc14f@glory.local>
In-Reply-To: <20111108104500.2f0fc14f@glory.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-11-2011 22:45, Dmitri Belimov escreveu:
> Hi
> 
...
> 
> I can watch TV but radio not work. After start Gnomeradio I see 
> VIDIOCGAUDIO incorrect
> VIDIOCSAUDIO incorrect
> VIDIOCSFREQ incorrect
> 
> Try found what happens with radio.

Those ioctl's are gone since kernel 2.6.39, as they are part of the V4L1 API.
You need to update your radio applications to the ones that implement V4L2
calls. The xawtv's radio application works with V4L2 API. AFAIKT, there are also 
some versions of gnomeradio implementing V4L2.

Regards,
Mauro
