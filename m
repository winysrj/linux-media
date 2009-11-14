Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46478 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbZKNOeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Nov 2009 09:34:09 -0500
Received: by bwz27 with SMTP id 27so4347342bwz.21
        for <linux-media@vger.kernel.org>; Sat, 14 Nov 2009 06:34:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AFEAB15.9010509@gmail.com>
References: <4AFE92ED.2060208@gmail.com> <4AFEAB15.9010509@gmail.com>
Date: Sat, 14 Nov 2009 09:34:14 -0500
Message-ID: <829197380911140634j49c05cd0s90aed57b9ae61436@mail.gmail.com>
Subject: Re: [PATCH] em28xx: fix for Dikom DK300 hybrid USB tuner (aka Kworld
	VS-DVB-T 323UR ) (digital mode)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Andrea.Amorosi76@gmail.com" <Andrea.Amorosi76@gmail.com>
Cc: "linux-media@vger.kernel.org >> Linux Media Mailing List"
	<linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 14, 2009 at 8:05 AM, Andrea.Amorosi76@gmail.com
<Andrea.Amorosi76@gmail.com> wrote:
> Continuing the testing for the analog part of the device, I've discovered
> that the main kernel driver (the one without the proposed patch)  works
> better,  even if not perfectly, as far as analog tv is concerned.
> In detail analog sound is present but is very low and noisy  (it seems to be
> listening to a very  distant radio station).
> So there is something in the patch that breaks the analog tv sound (which
> however is not very usable in the main driver being so noisy).
> Which one of the modified setting can interfer with the analog tv sound?
> Thank you,
> Andrea

Did you define an analog_gpio?  Or did you only define the digital
gpio?  The enabling of digital mode may be turning off the audio
encoder.

Devin
-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
