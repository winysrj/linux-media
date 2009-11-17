Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.191]:6429 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZKQOoP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 09:44:15 -0500
Received: by gv-out-0910.google.com with SMTP id r4so13894gve.37
        for <linux-media@vger.kernel.org>; Tue, 17 Nov 2009 06:44:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <C5BCB298-B166-4F9D-998C-EE58C5AF8B78@wilsonet.com>
References: <15cfa2a50910071839j58026d10we2ccbaeb26527abc@mail.gmail.com>
	 <0C6DEB14-B32A-4A20-B569-16B2A028CE25@wilsonet.com>
	 <15cfa2a50910091827l449f0fb0t2974219b6ea76608@mail.gmail.com>
	 <4B00D91B.1000906@wilsonet.com> <4B00DB5B.10109@wilsonet.com>
	 <409C0215-68B1-4F90-A8E0-EBAF4F02AC1A@wilsonet.com>
	 <4B023AC9.8080403@linuxtv.org>
	 <15cfa2a50911162203w1ad1584bhfdbe0213421abd6a@mail.gmail.com>
	 <C5BCB298-B166-4F9D-998C-EE58C5AF8B78@wilsonet.com>
Date: Tue, 17 Nov 2009 09:44:19 -0500
Message-ID: <15cfa2a50911170644h15680f08hc2ae695ac4deb5ae@mail.gmail.com>
Subject: Re: KWorld UB435-Q Support
From: Robert Cicconetti <grythumn@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>, linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 17, 2009 at 9:15 AM, Jarod Wilson <jarod@wilsonet.com> wrote:
>> It happened at every tuning operation, and made mythfrontend unhappy
>> (unable to tune after the first channel). I disabled the check for
>> RF_CAL_OK which triggered the recalibration, and mythfrontend worked.
>
> Yeah, tuning is much quicker here if I skip that check as well, but its definitely not the proper fix.
>
>> The stick has been plugged in for a few months, so presumably would've
>> caught on fire by now if it was going to. It would be nice if the
>> tuning delay went away, though.. it still takes ~6 seconds to switch
>> frequencies.
>
> Wait, it still takes that long with the check gone? I didn't poke for very long with the check disabled, mostly focusing on trying to figure out why things are going haywire.

Okay.. couple of unscientific tests later show I was wrong above:
First tuning, ~5-6 seconds to lock.
Later tunings, ~3 seconds to lock.

This is with my hack to remove the recalibrations.

-Bob
