Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:56816 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbbESMLN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 08:11:13 -0400
Date: Tue, 19 May 2015 14:11:04 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jemma Denson <jdenson@gmail.com>
Subject: Re: [PATCH 1/3] cx24120: don't initialize a var that won't be used
Message-ID: <20150519141104.075816d6@dibcom294.coe.adi.dibcom.com>
In-Reply-To: <8bf9e159ce96223ad404207d94e8e3742f2474de.1432034614.git.mchehab@osg.samsung.com>
References: <8bf9e159ce96223ad404207d94e8e3742f2474de.1432034614.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, 

On Tue, 19 May 2015 08:23:36 -0300 Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:

> As reported by smatch:
> drivers/media/dvb-frontends/cx24120.c: In function 'cx24120_message_send':
> drivers/media/dvb-frontends/cx24120.c:368:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
>   int ret, ficus;
>       ^
> 
> The values written by cx24120 are never checked. So, remove the
> check here too. That's said, the best would be to do the reverse,
> but globally: to properly handle the error codes.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Woudl you mind me integrating your patches on my tree which I then
will ask you to pull?

--
Patrick.
