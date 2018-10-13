Return-path: <linux-media-owner@vger.kernel.org>
Received: from infra.metatux.net ([78.46.58.246]:41986 "EHLO infra.metatux.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbeJMSV7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 13 Oct 2018 14:21:59 -0400
Subject: Re: [PATCH RESEND] Revert "media: dvbsky: use just one mutex for
 serializing device R/W ops"
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Oliver Freyermuth <o.freyermuth@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?UTF-8?Q?Stefan_Br=c3=bcns?= <stefan.bruens@rwth-aachen.de>
References: <d0042374-b508-7cb2-cb93-5f4a1951ec95@googlemail.com>
 <b39aa816886da2b57ecdfad85f06b4940bcb5d02.1538749539.git.mchehab+samsung@kernel.org>
 <4333a303-c06b-e641-20de-7b51058e0287@googlemail.com>
 <20181005123037.64b9f24c@coco.lan>
From: Lars Buerding <lindvb@metatux.net>
Message-ID: <b9d94f05-ef75-2647-1362-46caf61b3d12@metatux.net>
Date: Sat, 13 Oct 2018 12:37:08 +0200
MIME-Version: 1.0
In-Reply-To: <20181005123037.64b9f24c@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05.10.2018 17:30, Mauro Carvalho Chehab wrote:

> Em Fri, 5 Oct 2018 16:34:28 +0200
> Oliver Freyermuth <o.freyermuth@googlemail.com> escreveu:
> 
>> Dear Mauro,
>>
>> thanks! Just to clarify, the issue I described in https://bugzilla.kernel.org/show_bug.cgi?id=199323
>> was on an Intel x86_64 system, with an onboard USB Controller handled by the standard xhci driver,
>> so this does not affect RPi alone. 
> 
> That's weird... I tested such patch here before applying (and it was
> tested by someone else, as far as I know), and it worked fine.
> 
> Perhaps the x86 bug is related to some recent changes at the USB
> subsystem. Dunno.
> 
> Anyway, patch revert applied upstream.

Thanks Mauro,

just to second this is good:
* my TechnoTrend CT2-4400 / 0b48:3014 stopped to work with v4.18 / x86_64
  (Tuner is still working / lock on all channels, but the stick didnt return a transport stream, easy to validate using usbtop)
* applying this revert patch to v4.19-rc7 fixed it


Best,
Lars
