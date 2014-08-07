Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:53588 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbaHGOOq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Aug 2014 10:14:46 -0400
Received: by mail-qg0-f48.google.com with SMTP id i50so4345782qgf.21
        for <linux-media@vger.kernel.org>; Thu, 07 Aug 2014 07:14:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140807110442.353469bc.m.chehab@samsung.com>
References: <1407419190-10031-1-git-send-email-m.chehab@samsung.com>
	<CAGoCfix4h+Fh7PsPnhbn1wWh4-nsdMe-hjJ2B_Wrba8+0G59vg@mail.gmail.com>
	<20140807110442.353469bc.m.chehab@samsung.com>
Date: Thu, 7 Aug 2014 10:14:45 -0400
Message-ID: <CAGoCfizexXY6QzMZ_7LxBFsf2h7P8SSBVQ4JwcwaYB4=E+3Wzw@mail.gmail.com>
Subject: Re: [PATCH] au0828-input: Be sure that IR is enabled at polling
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Well, au8522_rc_set is defined as:
>
>         #define au8522_rc_set(ir, reg, bit) au8522_rc_andor(ir, (reg), (bit), (bit))

Ah, ok.  It's just a really poorly named macro.  Nevermind then.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
