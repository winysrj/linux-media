Return-path: <mchehab@localhost>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57995 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab0IEQVh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Sep 2010 12:21:37 -0400
Received: by wyf22 with SMTP id 22so2074552wyf.19
        for <linux-media@vger.kernel.org>; Sun, 05 Sep 2010 09:21:36 -0700 (PDT)
Message-ID: <4C83C380.8080703@gmail.com>
Date: Sun, 05 Sep 2010 18:21:20 +0200
From: "Andrea.Amorosi76@gmail.com" <andrea.amorosi76@gmail.com>
MIME-Version: 1.0
To: Andrea Amorosi <andrea.amorosi76@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Kernel hangs after suspend to ram
References: <AANLkTinB=N3aYUc4L8zLsMcUgdBnbShVA=fKsAWxNb0y@mail.gmail.com> <AANLkTi=h2t6FLOsGckPO2bYW=438BXFF7xo9r4nhYQ+o@mail.gmail.com>
In-Reply-To: <AANLkTi=h2t6FLOsGckPO2bYW=438BXFF7xo9r4nhYQ+o@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

Can you help me,
please?
Andrea Amorosi

Il 01/09/2010 22:32, Andrea Amorosi ha scritto:
> Hi to all!
> I'm trying to use my Dikom DK-300 usb dvb-t device connected to an old
> laptop used as media player.
> The device works well but if I suspend the pc to ram (S3) when the
> Dikom usb stick is plugged in, the system hangs during the resume
> phase.
> So I've tried to create two scripts. The first one removes the driver
> before sleeping (the script is in the /etc/acpi/suspend.d directory)
> and the second one reloads it during the resume phase (this script is
> in /etc/acpi/resume.d directory).
> I've also inserted in the scripts some logs and it seems that the
> driver is correctly removed before the suspension, but then the pc
> hangs when resuming.
> Do you have some sugestion on how to resolve?
> Thank you,
> Andrea Amorosi
>
