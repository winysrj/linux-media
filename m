Return-path: <mchehab@localhost>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40281 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab0IAUcI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Sep 2010 16:32:08 -0400
Received: by qwh6 with SMTP id 6so6754395qwh.19
        for <linux-media@vger.kernel.org>; Wed, 01 Sep 2010 13:32:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinB=N3aYUc4L8zLsMcUgdBnbShVA=fKsAWxNb0y@mail.gmail.com>
References: <AANLkTinB=N3aYUc4L8zLsMcUgdBnbShVA=fKsAWxNb0y@mail.gmail.com>
Date: Wed, 1 Sep 2010 22:32:06 +0200
Message-ID: <AANLkTi=h2t6FLOsGckPO2bYW=438BXFF7xo9r4nhYQ+o@mail.gmail.com>
Subject: Re: Kernel hangs after suspend to ram
From: Andrea Amorosi <andrea.amorosi76@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

Hi to all!
I'm trying to use my Dikom DK-300 usb dvb-t device connected to an old
laptop used as media player.
The device works well but if I suspend the pc to ram (S3) when the
Dikom usb stick is plugged in, the system hangs during the resume
phase.
So I've tried to create two scripts. The first one removes the driver
before sleeping (the script is in the /etc/acpi/suspend.d directory)
and the second one reloads it during the resume phase (this script is
in /etc/acpi/resume.d directory).
I've also inserted in the scripts some logs and it seems that the
driver is correctly removed before the suspension, but then the pc
hangs when resuming.
Do you have some suggestion on how to resolve?
Thank you,
Andrea Amorosi
