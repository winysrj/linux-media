Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39916 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab0EYWkd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 May 2010 18:40:33 -0400
Received: by vws9 with SMTP id 9so3819668vws.19
        for <linux-media@vger.kernel.org>; Tue, 25 May 2010 15:40:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BFC4858.8060403@helmutauer.de>
References: <4BFC4858.8060403@helmutauer.de>
Date: Tue, 25 May 2010 15:40:31 -0700
Message-ID: <AANLkTikaSnLsi4D7krqR1tSBd0adkHHlmzoiqdc38Znx@mail.gmail.com>
Subject: Re: v4l-dvb does not compile with kernel 2.6.34
From: VDR User <user.vdr@gmail.com>
To: Helmut Auer <vdr@helmutauer.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 25, 2010 at 2:59 PM, Helmut Auer <vdr@helmutauer.de> wrote:
> Hello
>
> I just wanted to compile v4l-dvb for my Gen2VDR Ditribution with kernel 2.6.34, but it fails
> because many modules are missing:
>
> #include <linux/slab.h>
>
> and are getting errors like:
>
> /tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c: In function
> 'free_firmware':
> /tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c:252: error: implicit
> declaration of function 'kfree'
> /tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c: In function
> 'load_all_firmwares':
> /tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c:314: error: implicit
> declaration of function
>
> Am I missing something or is v4l-dvb broken ?

It's broken but at least you know the reason and how to manually fix it.
