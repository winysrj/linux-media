Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:52031 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab2FGXJE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2012 19:09:04 -0400
Received: by ghrr11 with SMTP id r11so845582ghr.19
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2012 16:09:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH5vBdLJD1nvxK4eE5uP6cB-PwMQ+9CCUV0GQb0YBa1ZLxKxZg@mail.gmail.com>
References: <CAH5vBdLJD1nvxK4eE5uP6cB-PwMQ+9CCUV0GQb0YBa1ZLxKxZg@mail.gmail.com>
Date: Thu, 7 Jun 2012 16:09:02 -0700
Message-ID: <CAA7C2qi8_O4gNsBL5Oh_t9bAGit0u8ujz73KKSvHqUGACm+qOQ@mail.gmail.com>
Subject: Re: what are the media tuners / can we make them not default selected?
From: VDR User <user.vdr@gmail.com>
To: cheng renquan <crquan@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 7, 2012 at 2:53 PM, cheng renquan <crquan@gmail.com> wrote:
> till recently I found that also chosen those media tuner modules,
>
> $ grep MEDIA_TUNER /boot/config
> CONFIG_MEDIA_TUNER=m
> # CONFIG_MEDIA_TUNER_CUSTOMISE is not set
> CONFIG_MEDIA_TUNER_SIMPLE=m
> CONFIG_MEDIA_TUNER_TDA8290=m
> CONFIG_MEDIA_TUNER_TDA827X=m
> CONFIG_MEDIA_TUNER_TDA18271=m
> CONFIG_MEDIA_TUNER_TDA9887=m
> CONFIG_MEDIA_TUNER_TEA5761=m
> CONFIG_MEDIA_TUNER_TEA5767=m
> CONFIG_MEDIA_TUNER_MT20XX=m
> CONFIG_MEDIA_TUNER_XC2028=m
> CONFIG_MEDIA_TUNER_XC5000=m
> CONFIG_MEDIA_TUNER_XC4000=m
> CONFIG_MEDIA_TUNER_MC44S803=m
>
> as I understand, MEDIA_TUNER is for some tv adapters but I don't have
> such hardware,
> to disable them I need to enable MEDIA_TUNER_CUSTOMISE, then
> a menu "Customize TV tuners" becomes visible then I need to enter that
> menu and disable all the tuners one-by-one;
> this looks not convenient,

I hate that too so you're not alone. I've just gotten into the habit
of having to manually disabling everything I don't need as opposed to
only needing to enable what I do need. :\
