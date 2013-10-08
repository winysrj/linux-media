Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:51143 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab3JHQYG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Oct 2013 12:24:06 -0400
Received: by mail-ea0-f179.google.com with SMTP id b10so4029007eae.24
        for <linux-media@vger.kernel.org>; Tue, 08 Oct 2013 09:24:05 -0700 (PDT)
Message-ID: <525431B7.6050000@googlemail.com>
Date: Tue, 08 Oct 2013 18:24:23 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Jean-Francois Thibert <jfthibert@google.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add support for KWorld UB435-Q V2
References: <1380501923-23127-1-git-send-email-jfthibert@google.com>
In-Reply-To: <1380501923-23127-1-git-send-email-jfthibert@google.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 30.09.2013 02:45, schrieb Jean-Francois Thibert:
> This adds support for the UB435-Q V2. It seems that you might need to
> use the device once with the official driver to reprogram the device
> descriptors. Thanks to Jarod Wilson for the initial attempt at adding
> support for this device.
Could you please elaborate on this ?
What's the "official" driver and what changes after using it ?
Are these changes permanent ?

The commit message should be included in the patch and not be sent as a
separate message.
Can you fix the patch and resend it ?

Regards,
Frank Schäfer

> Jean-Francois Thibert (1):
>   Add support for KWorld UB435-Q V2
>
>  drivers/media/usb/em28xx/em28xx-cards.c |   14 +++++++++++++-
>  drivers/media/usb/em28xx/em28xx-dvb.c   |   27 +++++++++++++++++++++++++++
>  drivers/media/usb/em28xx/em28xx.h       |    1 +
>  3 files changed, 41 insertions(+), 1 deletions(-)
>

