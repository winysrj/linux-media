Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37957 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab2HLDGu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Aug 2012 23:06:50 -0400
Received: by obbuo13 with SMTP id uo13so4693707obb.19
        for <linux-media@vger.kernel.org>; Sat, 11 Aug 2012 20:06:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502711BE.4020701@redhat.com>
References: <20120731222216.GA36603@triton8.kn-bremen.de>
	<502711BE.4020701@redhat.com>
Date: Sat, 11 Aug 2012 23:06:49 -0400
Message-ID: <CAGoCfiyBZNkFkvhCqsbwxVaANZcp+1df-0eAmzrpzfavD6A+dQ@mail.gmail.com>
Subject: Re: [PATCH, RFC] Fix DVB ioctls failing if frontend open/closed too fast
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Juergen Lock <nox@jelal.kn-bremen.de>, hselasky@c2i.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 11, 2012 at 10:15 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Devin/Antti,
>
> As Juergen mentioned your help on this patch, do you mind helping reviewing
> and testing it?

I guided Juergen through the creation of the patch via #linuxtv a
couple of weeks ago.  While I'm generally confident that it should
work (and it does address his basic issue), I hadn't had the time to
stare at the code long enough to see what other side effects it might
produce.

I'm tied up in other projects right now and am not confident I will
have cycles to look at this closer.  Antti, if you want to give it
some cycles, this would be a good fix to get upstream (and you've
already been looking at dvb_frontend.c for quite a while, so I believe
you would be able to spot a problem if one exists).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
