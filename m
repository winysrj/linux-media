Return-path: <mchehab@pedra>
Received: from bar.sig21.net ([80.81.252.164]:46978 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab0IJPGq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 11:06:46 -0400
Date: Fri, 10 Sep 2010 16:41:21 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: "Andrea.Amorosi76@gmail.com" <andrea.amorosi76@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: DIKOM DK300: Kernel hangs after suspend to ram
Message-ID: <20100910144121.GA32339@linuxtv.org>
References: <4C86A4FB.8020902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C86A4FB.8020902@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Tue, Sep 07, 2010 at 10:47:55PM +0200, Andrea.Amorosi76@gmail.com wrote:
> I'm trying to use my Dikom DK-300 usb dvb-t device connected to an
> old laptop used as media player.
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
> Do you have some suggestion on how to resolve?
> I suspect that something in the GPIO setting is not corrected, but I
> don't know very well how to check that (now I've access to a windows
> xp virtualbox machine and a real windows vista system which maybe I
> can use to test/debug the correctness of the patch I postes some
> time ago).

Can't help you with the driver, but for general suspend/resume debug:
Did you try no_console_suspend to see if there are any errors?
See Documentation/kernel-parameters.txt for more info.
There are also some debugging hints in Documentation/power/s2ram.txt
and basic-pm-debugging.txt.

HTH
Johannes
