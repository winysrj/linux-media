Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41396 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaJISMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Oct 2014 14:12:47 -0400
Received: by mail-pd0-f173.google.com with SMTP id g10so193042pdj.32
        for <linux-media@vger.kernel.org>; Thu, 09 Oct 2014 11:12:47 -0700 (PDT)
Message-ID: <5436BAD4.80207@gmail.com>
Date: Fri, 10 Oct 2014 01:41:56 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/4] v4l-utils:libdvbv5,dvb: add basic support for ISDB-S
References: <1412770181-5420-1-git-send-email-tskd08@gmail.com> <20141008132207.2afc6ff8.m.chehab@samsung.com>
In-Reply-To: <20141008132207.2afc6ff8.m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Mauro,
thanks for the review.

I'll update the patch soon.
And I wrote some comments and questions as a reply to
your each review mail.

On 2014年10月09日 01:22, Mauro Carvalho Chehab wrote:

> Yeah, it will likely require a table just like the one we've added
> for EN 300 468 specific charset with the euro sign.
> 
> There are some patches for charset decoding like this one:
> 
> http://marc.info/?l=mplayer-dev-eng&m=125642040004816

I already looked over other examples in some Japan local patches
to the applications like mplayer,gstreamer, mythtv...,
( https://github.com/0p1pp1?tab=repositories
  https://github.com/takaakis62/mythtv_isdb )
so I'm going to reuse those code.

regards,
akihiro
