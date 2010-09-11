Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35437 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab0IKUIG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Sep 2010 16:08:06 -0400
Received: by wyf22 with SMTP id 22so4426774wyf.19
        for <linux-media@vger.kernel.org>; Sat, 11 Sep 2010 13:08:04 -0700 (PDT)
Message-ID: <4C8BE197.9090805@gmail.com>
Date: Sat, 11 Sep 2010 22:07:51 +0200
From: "Andrea.Amorosi76@gmail.com" <andrea.amorosi76@gmail.com>
MIME-Version: 1.0
To: Johannes Stezenbach <js@linuxtv.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: DIKOM DK300: Kernel hangs after suspend to ram
References: <4C86A4FB.8020902@gmail.com> <20100910144121.GA32339@linuxtv.org>
In-Reply-To: <20100910144121.GA32339@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi!
I've tried to add the no_console_suspend=1 to the grub boot line using 
the command editor at startup, but switching to the first console and 
trying to suspend, the console went away as it does if the above option 
is not present so I was unable to read anything when the kernel crashed 
at resume.
Is there something wrong?
Andrea Amorosi

Il 10/09/2010 16:41, Johannes Stezenbach ha scritto:
> On Tue, Sep 07, 2010 at 10:47:55PM +0200, Andrea.Amorosi76@gmail.com wrote:
>> I'm trying to use my Dikom DK-300 usb dvb-t device connected to an
>> old laptop used as media player.
>> The device works well but if I suspend the pc to ram (S3) when the
>> Dikom usb stick is plugged in, the system hangs during the resume
>> phase.
>> So I've tried to create two scripts. The first one removes the driver
>> before sleeping (the script is in the /etc/acpi/suspend.d directory)
>> and the second one reloads it during the resume phase (this script is
>> in /etc/acpi/resume.d directory).
>> I've also inserted in the scripts some logs and it seems that the
>> driver is correctly removed before the suspension, but then the pc
>> hangs when resuming.
>> Do you have some suggestion on how to resolve?
>> I suspect that something in the GPIO setting is not corrected, but I
>> don't know very well how to check that (now I've access to a windows
>> xp virtualbox machine and a real windows vista system which maybe I
>> can use to test/debug the correctness of the patch I postes some
>> time ago).
>
> Can't help you with the driver, but for general suspend/resume debug:
> Did you try no_console_suspend to see if there are any errors?
> See Documentation/kernel-parameters.txt for more info.
> There are also some debugging hints in Documentation/power/s2ram.txt
> and basic-pm-debugging.txt.
>
> HTH
> Johannes
>
