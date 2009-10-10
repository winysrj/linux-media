Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f203.google.com ([209.85.212.203]:64903 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574AbZJJB2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Oct 2009 21:28:34 -0400
Received: by vws41 with SMTP id 41so4048975vws.4
        for <linux-media@vger.kernel.org>; Fri, 09 Oct 2009 18:27:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0C6DEB14-B32A-4A20-B569-16B2A028CE25@wilsonet.com>
References: <15cfa2a50910071839j58026d10we2ccbaeb26527abc@mail.gmail.com>
	 <0C6DEB14-B32A-4A20-B569-16B2A028CE25@wilsonet.com>
Date: Fri, 9 Oct 2009 21:27:58 -0400
Message-ID: <15cfa2a50910091827l449f0fb0t2974219b6ea76608@mail.gmail.com>
Subject: Re: KWorld UB435-Q Support
From: Robert Cicconetti <grythumn@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 7, 2009 at 10:08 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> On Oct 7, 2009, at 9:39 PM, Robert Cicconetti wrote:
>> Okay... I built the tip of the archive linked above. It works with my
>> UB435-Q fairly well, built against 2.6.28-15-generic #52-Ubuntu SMP
>> x86_64. I've been able to stream QAM256 content for several hours
>> reliably. Mythfrontend works somewhat... it'll tune the initial
>> channel, but fails afterward. I suspect it is timing out while waiting
>> for the RF tracking filter calibration... it adds about 6 seconds to
>> every tuning operation.
>>
>> [  812.465930] tda18271: performing RF tracking filter calibration
>> [  818.572446] tda18271: RF tracking filter calibration complete
>> [  818.953946] tda18271: performing RF tracking filter calibration
>> [  825.093211] tda18271: RF tracking filter calibration complete
>>
>> Any suggestions? Further data needed?
>
> Nothing off the top of my head, no. But I've got a UB435-Q of my own now,
> sitting on my desk waiting for me to poke at it... Not sure when I'll have
> time to actually poke at it though. :\

A little further poking yields that RF_CAL_OK in EP1 is 0, which is
why it keeps recalibrating.

I've commented out the part of the code that recalibrates if RF_CAL_OK
is 0; EP1 always seems to be c6... and now mythfrontend is happy. :)

This is not a long term solution, but as ugly hacks go it was pretty
straight forward. :)

-Bob
