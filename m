Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708Ab2ENL2h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 07:28:37 -0400
Message-ID: <4FB0EC60.8050604@redhat.com>
Date: Mon, 14 May 2012 08:28:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
CC: =?ISO-8859-1?Q?Andr=E9_Roth?= <neolynx@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/6] libdvbv5 shared lib
References: <1336912143-25890-1-git-send-email-neolynx@gmail.com> <4FAFC2CA.7010306@googlemail.com>
In-Reply-To: <4FAFC2CA.7010306@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 13-05-2012 11:18, Gregor Jasny escreveu:
> Hello,
> 
> I noticed the dvb library is partially licensed as GPL2 and partially
> LGPL2.1+. Do you consider a re-licensing to LGPL2.1?

It is actually released as GPLv2 only. There's one file with LGPL2.1 only there:
the DVB frontend API file (include/linux/dvb/frontend.h, c/c there as dvb-frontend.h).

Currently, I've no plans to change it to LGPL2.1.

> 
> For better maintainability in distributions I'd also suggest to hide
> non-public symbols like it's done for libv4l*.

I'll put it on my TODO list. I won't have any time to work on that during the last
3 weeks, due to the merge window, so, if André or someone else can help with patches,
those will be very welcome ;)

Regards,
Mauro
> 
> Thanks,
> Gregor

