Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab0GESZO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jul 2010 14:25:14 -0400
Message-ID: <4C322383.2030100@redhat.com>
Date: Mon, 05 Jul 2010 15:25:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarkko Nikula <jhnikula@gmail.com>
CC: eduardo.valentin@nokia.com,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] si4713: Fix oops when si4713_platform_data is marked
 as __initdata
References: <1274029466-17456-1-git-send-email-jhnikula@gmail.com>	<20100518125527.GB4265@besouro.research.nokia.com>	<20100518162445.5399d077.jhnikula@gmail.com>	<4C3203B2.9050401@redhat.com> <20100705194808.cd12018a.jhnikula@gmail.com>
In-Reply-To: <20100705194808.cd12018a.jhnikula@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-07-2010 13:48, Jarkko Nikula escreveu:
> On Mon, 05 Jul 2010 13:09:22 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
>> Hi Eduardo,
>>
>> This patch is still on my queue. It is not clear to me what "proably fine" means...
>> Please ack or nack on it for me to move ahead ;)
>>
> Ah, sorry, I should have nacked this myself

Thanks for the nack !

> after I sent the regulator
> framework conversion patch [1] which removes the set_power callback and
> thus null check need for it.

Ok, it is on my pending list. I'll analyze it later likely today.

Cheers,
Mauro.
