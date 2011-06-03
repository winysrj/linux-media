Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:6080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab1FCMMY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jun 2011 08:12:24 -0400
Message-ID: <4DE8CF9C.4040004@redhat.com>
Date: Fri, 03 Jun 2011 09:12:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, thunder.m@email.cz,
	"istvan_v@mailbox.hu" <istvan_v@mailbox.hu>, bahathir@gmail.com
Subject: Re: [linux-dvb] XC4000 patches for kernel 2.6.37.2
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local>	<BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>	<4DE7A131.7010208@redhat.com> <20110603114103.451f1375@glory.local>
In-Reply-To: <20110603114103.451f1375@glory.local>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 02-06-2011 22:41, Dmitri Belimov escreveu:
> On Thu, 02 Jun 2011 11:41:53 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> One of our TV card has this tuner. It works in analog mode. I try get right firmware
> cleanup and test.
> 
> Can I use 
> git://linuxtv.org/mchehab/experimental.git branch xc4000
> for do it?

Sure. Feel free to use it. I'll be adding there the xc4000-related patches
until they're ok for review.

Thanks,
Mauro
