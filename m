Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36119 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab1IMGFJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 02:05:09 -0400
Received: by fxe4 with SMTP id 4so282492fxe.19
        for <linux-media@vger.kernel.org>; Mon, 12 Sep 2011 23:05:07 -0700 (PDT)
Date: Tue, 13 Sep 2011 08:04:51 +0200
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org, Doychin Dokov <root@net1.cc>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
	Hans Petter Selasky <hselasky@c2i.net>,
	Dominik Kuhlen <dkuhlen@gmx.net>,
	"Michael H. Schimek" <mschimek@gmx.at>,
	Mauro Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Add support for PCTV452E.
Message-ID: <20110913080451.55b721b2@grobi>
In-Reply-To: <201106151844.35343.liplianin@me.by>
References: <201105242151.22826.hselasky@c2i.net>
	<4DF52148.4060704@net1.cc>
	<4DF531BE.8090005@net1.cc>
	<201106151844.35343.liplianin@me.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 15 Jun 2011 18:44:35 +0300
"Igor M. Liplianin" <liplianin@me.by> wrote:

> From my point of view we can count the beginning was here:
> 
> http://www.spinics.net/lists/linux-dvb/msg26431.html
> 
> The later history is difficult to restore, but possible.
>

After some searching it looks like this is the first occurrence of the
driver:
http://www.linuxtv.org/pipermail/linux-dvb/2007-October/021403.html

Further it looks like Dominik Kuhlen is not responding at that mail (as
he has been on copy on one of the last mails. 

So looks like we cant get the signed-off-by from him. 

Does that mean the patch can't be applied and needs to be rewritten
from scratch even if the author put the code under GPL2 back then ? Is
there any rule for this ?

See comment of  Oliver Freyermuth - the driver seems to work (after
altering it to make it work with current kernel), also got some postive
feedback for it for kernel 2.6.38 and current 3.2 media_tree. 

Does someone have a definitive answer on how to go ahead ? What else is
missing ?

Thanks :) 

Steffen

