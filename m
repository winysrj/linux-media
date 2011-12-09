Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36887 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab1LIWdP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2011 17:33:15 -0500
Received: by yenm11 with SMTP id m11so2499023yen.19
        for <linux-media@vger.kernel.org>; Fri, 09 Dec 2011 14:33:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE287A9.3000502@redhat.com>
References: <1323454852-7426-1-git-send-email-mchehab@redhat.com>
	<4EE252E5.2050204@iki.fi>
	<4EE25A3C.9040404@redhat.com>
	<4EE25CB4.3000501@iki.fi>
	<4EE287A9.3000502@redhat.com>
Date: Fri, 9 Dec 2011 17:33:14 -0500
Message-ID: <CAGoCfiyE8JhX5fT_SYjb6_X5Mkjx1Vx34_pKYaTjXu+muWxxwg@mail.gmail.com>
Subject: Re: [PATCH] [media] drxk: Switch the delivery system on FE_SET_PROPERTY
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 9, 2011 at 5:11 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>> Could someone explain reason for that?
>
>
> I dunno, but I think this needs to be fixed, at least when the frontend
> is opened with O_NONBLOCK.

Are you doing the drx-k firmware load on dvb_init()?  That could
easily take 4 seconds.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
