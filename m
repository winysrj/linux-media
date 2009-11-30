Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbZK3UnU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 15:43:20 -0500
Message-ID: <4B142E2C.1020108@redhat.com>
Date: Mon, 30 Nov 2009 18:42:20 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "OrazioPirataDelloSpazio (Lorenzo)" <ziducaixao@autistici.org>
CC: linux-media@vger.kernel.org
Subject: Re: DIY Satellite Web Radio
References: <4B14195D.6000205@autistici.org>
In-Reply-To: <4B14195D.6000205@autistici.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 30-11-2009 17:13, OrazioPirataDelloSpazio (Lorenzo) escreveu:
> Hi all,
> I'm not a DVB expert but I'm wondering if this idea is feasible:
> For an "amateur" web radio, for what I know, it is really hard to
> being listened in cars, like people do with commercial satellite radio
> [1] . Basically this is unaffortable for private user and this is
> probably the most relevant factor that penalize web radios againt
> terrestrial one.
> 
> My question is: is there any way to use the current, cheap, satellite
> internet connections to stream some data above all the coverage of a geo
> satellite? and make the receiver handy (so without any dishes) ?

Receiving sat signals without dishes? From some trials we had on a telco
I used to work, You would need to use a network of low-orbit satellites,
carefully choosing the better frequencies and it will provide you
low bandwidth.

This will likely cost a lot of money, if you find someone providing a
service like that. One trial for such network were the Iridum
project. AFAIK, the original company bankrupted due to the very high costs of
launching and managing about a hundred satellite network.

I'm not tracking such things nowadays, but I won't doubt that you would
find someone providing this kind of services. I think the telephones that
are onboard of some flight companies use a satellite service like that.

> Probably by introducing some _very_ redundant code inside the stream
> that we upload through the modem and that the satellite will stream from
> the sky, we can get some S/N db. The patch to do at the receiver is just
> software or maybe hardware?

You'll likely need to design an special hardware for such usage.

Cheers,
Mauro.
