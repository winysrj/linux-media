Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:54304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139Ab1GHNJQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2011 09:09:16 -0400
Message-ID: <4E170176.8090506@redhat.com>
Date: Fri, 08 Jul 2011 10:09:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?TWFyY28gRGllZ28gQXVyw6lsaW8gTWVzcXVpdGE=?=
	<marcodiegomesquita@gmail.com>
CC: Hans de Goede <hdegoede@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Pach under review.
References: <CAE_m23n+Hj3xkC5UrUow64mLGaKAOKmR8yPDAATnZ=kWpqWaKw@mail.gmail.com>
In-Reply-To: <CAE_m23n+Hj3xkC5UrUow64mLGaKAOKmR8yPDAATnZ=kWpqWaKw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Em 07-07-2011 23:12, Marco Diego Aurélio Mesquita escreveu:
> Hi!
> 
> I would like to have my patch[1] ready for linux 3.0. It's a simple
> one-liner to solve an easy to fix problem. Is there anything I can do
> o accelerate the review process?
> 
> Please, CC me your answers as I'm not subscribed to the list.
> 
> Tanks!
> 
> [1] https://patchwork.kernel.org/patch/849142/


Hi Marco,

Hans is currently in vacations, so, we'll likely need to wait for his return.
I prefer to not rush merging it, because I don't have the pac207 datasheets,
and it is a good idea to have more tests on it. What webcams had you tested
needing such fix?

Thanks,
Mauro
