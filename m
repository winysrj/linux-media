Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54963 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab2F2P6w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 11:58:52 -0400
Received: by dady13 with SMTP id y13so4552079dad.19
        for <linux-media@vger.kernel.org>; Fri, 29 Jun 2012 08:58:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20461.26585.508583.521723@morden.metzler>
References: <1340918440-17523-1-git-send-email-martin.blumenstingl@googlemail.com>
 <1340918440-17523-2-git-send-email-martin.blumenstingl@googlemail.com> <20461.26585.508583.521723@morden.metzler>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Fri, 29 Jun 2012 17:58:31 +0200
Message-ID: <CAFBinCApTRMdut01wPqT08ViOW=++57UHBY2ok=k=EfQSaEVCQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] drxk: Make the QAM demodulator command configurable.
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ralph,

> are you sure about this?
> From what I have been told, the 2 parameter command is in the
> firmware ROM and older loadable/patch firmwares.
> Newer firmwares provided the 4 parameter command.
The firmwares in the ROM are a good point.

I discussed with  Mauro Carvalho Chehab before I started writing my patch,
and he told me that the only (loadable) firmware that uses the old command
is the "drxk_a3.mc" one.
But you are right, there is some firmware (for DVB-C, afaik it's NOT for DVB-T)
stored in the ROM.

If  I find out that the ROM uses the "old" command then I'll probably try
making this smart:
old_qam_demod_cmd will be an int with the following possible values:
* -1: unknown - trial and error approach will be used
(afterwards this will be updated to either 0 or 1)
* 0: use the 2-parameter command
* 1: use the 4-parameter command

I'll also try to guess a smart default value:
-1 will be used if no firmware was given.
Otherwise 0 will be the default.
The remaining two drxk_config instances that are still using the old
firmware will be set to 1 (like in my first patch).

If everything goes right then I'll be able to test and update my patch tonight.

Regards,
Martin
