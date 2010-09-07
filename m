Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40118 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab0IGUsF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Sep 2010 16:48:05 -0400
Received: by wyf22 with SMTP id 22so4679417wyf.19
        for <linux-media@vger.kernel.org>; Tue, 07 Sep 2010 13:48:04 -0700 (PDT)
Message-ID: <4C86A4FB.8020902@gmail.com>
Date: Tue, 07 Sep 2010 22:47:55 +0200
From: "Andrea.Amorosi76@gmail.com" <andrea.amorosi76@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: DIKOM DK300: Kernel hangs after suspend to ram
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi to all!
I'm trying to use my Dikom DK-300 usb dvb-t device connected to an old 
laptop used as media player.
The device works well but if I suspend the pc to ram (S3) when the Dikom 
usb stick is plugged in, the system hangs during the resume phase.
So I've tried to create two scripts. The first one removes the driver
before sleeping (the script is in the /etc/acpi/suspend.d directory)
and the second one reloads it during the resume phase (this script is
in /etc/acpi/resume.d directory).
I've also inserted in the scripts some logs and it seems that the
driver is correctly removed before the suspension, but then the pc
hangs when resuming.
Do you have some suggestion on how to resolve?
I suspect that something in the GPIO setting is not corrected, but I 
don't know very well how to check that (now I've access to a windows xp 
virtualbox machine and a real windows vista system which maybe I can use 
to test/debug the correctness of the patch I postes some time ago).
Thank you,
Andrea Amorosi

