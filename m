Return-path: <linux-media-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.187]:15792 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZBHTA3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Feb 2009 14:00:29 -0500
Received: by rn-out-0910.google.com with SMTP id k40so1121975rnd.17
        for <linux-media@vger.kernel.org>; Sun, 08 Feb 2009 11:00:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <B7621984-DEB8-4F0C-B5EF-733CD30E7441@alice-dsl.net>
References: <B7621984-DEB8-4F0C-B5EF-733CD30E7441@alice-dsl.net>
Date: Sun, 8 Feb 2009 14:00:28 -0500
Message-ID: <412bdbff0902081100q4e625a59p42cba55d942010bc@mail.gmail.com>
Subject: Re: [PATCH] Add Elgato EyeTV Diversity to dibcom driver
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: =?ISO-8859-1?Q?Michael_M=FCller?= <mueller_michael@alice-dsl.net>
Cc: Patrick Boettcher <patrick.boettcher@desy.de>,
	pboettcher@dibcom.fr, linux-dvb@linuxtv.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 8, 2009 at 1:51 PM, Michael Müller
<mueller_michael@alice-dsl.net> wrote:
> This patch introduces support for DVB-T for the following dibcom based card:
>        Elgato EyeTV Diversity (USB-ID: 0fd9:0011)
>
> Support for the Elgato silver IR remote is added too (set parameter
> dvb_usb_dib0700_ir_proto=0)
>
> Signed-off-by: Michael Müller <mueller_michael@alice-dsl.net>
>
>
>
>
> Hi Patrick,
>
> several months ago I sent you a patch for the Elgato USB stick. At this time
> I was not happy with the problem of the repeated remote keys. Since this was
> fixed by Devin here it is again. The patch is against v4l-dvb from 7th Feb.
> 2009. So compared to the last time I only adjusted the index in the USB id
> table.
>
> As written in the patch text you need to set parameter
> dvb_usb_dib0700_ir_proto=0 (default=1). Is there a way to overwrite the
> default for a specific device as mine? Or does this make no sense since the
> needed protocol is not driven by the USB stick IR receiver but the remote
> control?
>
> BTW: In the meantime I needed to change my email adress.
>
> Devin,
>
> first I want tell you that after your changes the repeated IR keys are gone.
> Thanks.
>
> In December you wrote that you 'should work on getting the dib0700 driver
> integrated with ir_keymaps.c so that the it is consistent with other
> drivers.' Did you already started to work on this? Should I change my patch
> to use the ir_keymaps.c way? Which driver is a good example how to use it?
>
> Regards
>
> Michael

Hello Michael,

While I am indeed strongly in favor of integrating dib0700 with
ir_keymaps.c so it is consistent with the other drivers, I have been
tied up in another project and haven't had any cycles to do the work
required.

By all means, if you want to propose a patch, I would be happy to
offer feedback/comments.

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
