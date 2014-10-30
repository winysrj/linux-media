Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:58985 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760094AbaJ3ONL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 10:13:11 -0400
Received: by mail-qc0-f172.google.com with SMTP id i17so4180838qcy.17
        for <linux-media@vger.kernel.org>; Thu, 30 Oct 2014 07:13:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141030113725.08b3aa40@recife.lan>
References: <cover.1414668341.git.mchehab@osg.samsung.com>
	<678fa12fb8e75c6dc1e781a02e3ddbbba7e1a904.1414668341.git.mchehab@osg.samsung.com>
	<CAGoCfizkcdU1fgfLjFHwnH34HgpJBcznO+3RrqOMHpLUYKCNPg@mail.gmail.com>
	<20141030113725.08b3aa40@recife.lan>
Date: Thu, 30 Oct 2014 10:13:09 -0400
Message-ID: <CAGoCfiwU0VVbjtzuv6Y9jvAPiHJJjC4=1Amp2AGweLuEa9vEHA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] [media] sound: Update au0828 quirks table
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Clemens Ladisch <clemens@ladisch.de>,
	Daniel Mack <zonque@gmail.com>,
	Eduard Gilmutdinov <edgilmutdinov@gmail.com>,
	Vlad Catoi <vladcatoi@gmail.com>, alsa-devel@alsa-project.org,
	stable@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 30, 2014 at 9:37 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Yeah, if nobody is using such devices, then we should get rid of them,
> but I prefer to have this on a separate patch, in order to give
> people the opportunity to complain.

Yes, I would definitely suggest a separate patch.  There's no reason
it should be mixed in with your general cleanup of the ALSA quirks.

> So, if I'm understanding well, you're suggesting to add a patch
> removing those 5 entries (and the corresponding quirks on alsa),
> right?
>
>         { USB_DEVICE(0x2040, 0x7201),
>                 .driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL },
>         { USB_DEVICE(0x2040, 0x7211),
>                 .driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL },
>         { USB_DEVICE(0x2040, 0x7281),
>                 .driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL },
>         { USB_DEVICE(0x05e1, 0x0480),
>                 .driver_info = AU0828_BOARD_HAUPPAUGE_WOODBURY },
>         { USB_DEVICE(0x2040, 0x8200),
>                 .driver_info = AU0828_BOARD_HAUPPAUGE_WOODBURY },
>         { USB_DEVICE(0x2040, 0x7260),

Exactly.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
