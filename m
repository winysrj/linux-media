Return-path: <linux-media-owner@vger.kernel.org>
Received: from web35803.mail.mud.yahoo.com ([66.163.179.172]:46021 "HELO
	web35803.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751350Ab0CIRZg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Mar 2010 12:25:36 -0500
Message-ID: <652988.40643.qm@web35803.mail.mud.yahoo.com>
References: <15cfa2a50910071839j58026d10we2ccbaeb26527abc@mail.gmail.com>  <15cfa2a50910091827l449f0fb0t2974219b6ea76608@mail.gmail.com>  <4B00D91B.1000906@wilsonet.com> <4B00DB5B.10109@wilsonet.com>  <409C0215-68B1-4F90-A8E0-EBAF4F02AC1A@wilsonet.com>  <4B023AC9.8080403@linuxtv.org>  <15cfa2a50911162203w1ad1584bhfdbe0213421abd6a@mail.gmail.com>  <C5BCB298-B166-4F9D-998C-EE58C5AF8B78@wilsonet.com>  <829197380911170637h6a7918fcl461c01d70ab20599@mail.gmail.com>  <FF5F7993-6EC1-4C8E-9730-F85D1DC473D6@wilsonet.com> <be3a4a1003051909l6ea96eb3kb06c04f212f43bcf@mail.gmail.com>
Date: Tue, 9 Mar 2010 09:25:35 -0800 (PST)
From: Amy Overmyer <aovermy@yahoo.com>
Subject: Re: KWorld UB435-Q Support
To: linux-media@vger.kernel.org
In-Reply-To: <be3a4a1003051909l6ea96eb3kb06c04f212f43bcf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 17, 2009 at 11:59 PM, Jarod Wilson <jarod@wilsonet.com> wrote:

snip

>>Or a few months later. About two weeks ago, I finally poked at these
>>sticks some more, after getting a bit of info from another user, and
>>we've finally got an actual fix for this problem -- .deny_i2c_rptr = 1
>>just needed to be set in the lgdt3305_config struct, as the device's
>>tuner isn't actually behind an i2c gate. With that change, the stick
>>behaves quite well w/o any alterations to the tda18271 code. Patches
>>are here:
>>
>>http://wilsonet.com/jarod/junk/kworld-a340-20100218/
>>
>>They're in Mike's hands now, since they rely so heavily on the lgdt3305 driver.

I compiled up this change on my setup and the Kworld is working wonderfully for me now. I was able to do a full ATSC us center freq scan pretty quickly and then added it to mythtv and its working well there, too. It's doing OTA capture.

Thanks, Jarod.


      
