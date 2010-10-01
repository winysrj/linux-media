Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab0JARFc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Oct 2010 13:05:32 -0400
Message-ID: <4CA614CF.6060808@redhat.com>
Date: Fri, 01 Oct 2010 14:05:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@anciens.enib.fr>
CC: Eric.Valette@free.fr, Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l/dvb: add support for AVerMedia AVerTV Red HD+ (A850T)
References: <1285795123-11046-1-git-send-email-yann.morin.1998@anciens.enib.fr> <4CA5CED7.2090203@Free.fr> <4CA5F5DE.7070209@redhat.com> <201010011705.55459.yann.morin.1998@anciens.enib.fr>
In-Reply-To: <201010011705.55459.yann.morin.1998@anciens.enib.fr>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 01-10-2010 12:05, Yann E. MORIN escreveu:
> Hell all!
> 
> On Friday 01 October 2010 165318 Mauro Carvalho Chehab wrote:
>> If you're talking about http://linuxtv.org/repo/, I just updated it.
> 
> Just nit-picking here, but the instructions still have some typoes:
> 
> git remote add linuxtv git://linuxtv.org/media-tree.git
> -> the name of the tree uses a '_'            ^
> 
> git pull . remotes/staging/v2.6.37
> -> should be (at least the above does not work for me):
> git pull . remotes/linuxtv/staging/v2.6.37

fixed, thanks.
> 
> Regards,
> Yann E. MORIN.
> 

