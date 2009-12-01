Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:38852 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbZLATFV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 14:05:21 -0500
Received: by fxm5 with SMTP id 5so5276996fxm.28
        for <linux-media@vger.kernel.org>; Tue, 01 Dec 2009 11:05:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B142E2C.1020108@redhat.com>
References: <4B14195D.6000205@autistici.org> <4B142E2C.1020108@redhat.com>
Date: Tue, 1 Dec 2009 23:05:27 +0400
Message-ID: <1a297b360912011105s707ce090m4af01bb6232d4814@mail.gmail.com>
Subject: Re: DIY Satellite Web Radio
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "OrazioPirataDelloSpazio (Lorenzo)" <ziducaixao@autistici.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 1, 2009 at 12:42 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 30-11-2009 17:13, OrazioPirataDelloSpazio (Lorenzo) escreveu:
>> Hi all,
>> I'm not a DVB expert but I'm wondering if this idea is feasible:
>> For an "amateur" web radio, for what I know, it is really hard to
>> being listened in cars, like people do with commercial satellite radio
>> [1] . Basically this is unaffortable for private user and this is
>> probably the most relevant factor that penalize web radios againt
>> terrestrial one.
>>
>> My question is: is there any way to use the current, cheap, satellite
>> internet connections to stream some data above all the coverage of a geo
>> satellite? and make the receiver handy (so without any dishes) ?
>
> Receiving sat signals without dishes? From some trials we had on a telco
> I used to work, You would need to use a network of low-orbit satellites,
> carefully choosing the better frequencies and it will provide you
> low bandwidth.
>
> This will likely cost a lot of money, if you find someone providing a
> service like that. One trial for such network were the Iridum
> project. AFAIK, the original company bankrupted due to the very high costs of
> launching and managing about a hundred satellite network.

Low orbital satellites aren't geo-stationary. Technically speaking, a
broadcaster would use only geo-stationary satellites for broadcast
services. The basic reason: A broadcaster simply would have rented out
a transponder on an existing satellite from a satellite operator, or
still: if the broadcaster is a major player, they would have a few
satellites of their own to provide coverage over multiple regions, but
still: they are indeed geo-stationary satellites (you will need a very
large number of satellites to provide services in a low orbital
position, similar to the Iridium network, which is not practically
feasible for a broadcaster. Even the Iridium network had a hard time
taking off!)

Regards,
Manu
