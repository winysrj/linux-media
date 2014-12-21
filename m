Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:52461 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbaLUTXh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Dec 2014 14:23:37 -0500
Message-ID: <54971E29.2000702@gentoo.org>
Date: Sun, 21 Dec 2014 20:23:21 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: cx23885: Add si2165 support for HVR-5500
References: <5495963D.3080004@iki.fi>
In-Reply-To: <5495963D.3080004@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20.12.2014 16:31, Antti Palosaari wrote:
> Matthias and Mauro,
Hi Antti,
meanwhile HVR-4400 has been tested by multiple people. And it works
rather good for DVB-T.

> so you decided to add that patch, which makes rather big changes for
> existing HVR-4400 models, without any testing. I plugged HVR-4400
> version that has only DVB-S2 in my machine in order to start finding out
> one lockdep issue but what I see is bad HVR-4400.

I checked that all known HVR-4400 and HVR-5500 versions have a
Si2161/Si2165 chip.

I checked your subsystem id 0070:c12a. In windows inf file it is listed
as "Hauppauge WinTV Starburst (Model 121x00, DVB-S2, IR)".
But this subsystem id is also part of the HVR-4400 entry (as is HVR-5500).

So I rechecked the HVR4400 entry.
It points to these subsys ids (plus description from inf file):
* 0070:c108 "Hauppauge WinTV HVR-4400 (Model 121xxx, Hybrid DVB-T/S2, IR)"
* 0070:c138 "Hauppauge WinTV HVR-5500 (Model 121xxx, Hybrid DVB-T/C/S2, IR)"
* 0070:c1f8 "Hauppauge WinTV HVR-5500 (Model 121xxx, Hybrid DVB-T/C/S2, IR)"
* 0070:c12a "Hauppauge WinTV Starburst (Model 121x00, DVB-S2, IR)"

> 
> I would also criticize Mauro as he has committed that patch. It should
> be obvious for every experienced media developer that this kind of not
> trivial change needs some more careful review or testing.
> 
> That patch should be done differently, not blindly trying to attach chip
> drivers for non-existent chips. I think correct solution is to detect
> different HW models somehow, probing or reading from eeprom or so. Then
> make 2 profiles, one for boards having both satellite and
> terristrial/cable and one for boards having satellite only.
> 
As can be seen above it should be possible to decide by checking the
subsys id.
So having two board entries should be the best solution.
One for HVR-4400/HVR-5500 and the other for the Starburst.

Regards
Matthias


