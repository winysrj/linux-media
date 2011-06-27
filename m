Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36013 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1F0Rzu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2011 13:55:50 -0400
Received: by eyx24 with SMTP id 24so1650364eyx.19
        for <linux-media@vger.kernel.org>; Mon, 27 Jun 2011 10:55:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E08A463.2050101@gmail.com>
References: <4E08A463.2050101@gmail.com>
Date: Mon, 27 Jun 2011 13:55:49 -0400
Message-ID: <BANLkTinn+KZGG2eOog328nGnpp4QO3cCfQ@mail.gmail.com>
Subject: Re: EM28xx based device support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andrea De Marsi <andrea.demarsi@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jun 27, 2011 at 11:40 AM, Andrea De Marsi
<andrea.demarsi@gmail.com> wrote:
> I now need to upgrade the linux kernel to a newer version (2.6.32 or newer);
> I followed the same path that was working with 2.6.24 (which is basically
> have the device recognized as an empia device) and in fact some images are
> visible but they are not stable; it seems as the new driver version was not
> capble of managing the NTSC format (in fact I noticed there is no more .norm
> field in the initialization structure).
> Do you have any advice?

A screenshot of what you are seeing would be useful (as well as the
dmesg output showing driver load as well as after your attempt to
capture)

Also, given your device I would assume that ".has_tuner" would
probably be zero and the tda9887_conf should not be populated at all.
And does the device really have two inputs?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
