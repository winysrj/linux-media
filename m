Return-path: <mchehab@pedra>
Received: from alia.ip-minds.de ([84.201.38.2]:42872 "EHLO alia.ip-minds.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab1CJAAO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2011 19:00:14 -0500
To: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: WinTV 1400 broken with recent =?UTF-8?Q?versions=3F?=
MIME-Version: 1.0
Date: Thu, 10 Mar 2011 01:00:18 +0100
From: <jean.bruenn@ip-minds.de>
Cc: <linux-media@vger.kernel.org>
In-Reply-To: <76A39CFB-2838-4AD7-B353-49971F9F7DFF@wilsonet.com>
References: <20110309175231.16446e92.jean.bruenn@ip-minds.de> <76A39CFB-2838-4AD7-B353-49971F9F7DFF@wilsonet.com>
Message-ID: <ba12e998349efa465be466a4d7f9d43f@localhost>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> This may already be fixed, just not in 2.6.37.x yet. Can you give
> 2.6.38-rc8 (or later) a try and/or the media_build bits?

Tried - Nope, same behaviour (same error messages in dmesg, no results by
scan)

>
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

I was unable to get that working; tried with 2.6.37.2 and 2.6.37.3 always
getting "invalid module format" and yeah, i tried with reboot, i tried
with a
fresh variant.. Also tried ./build.sh and make install and such stuff in
2.6.38-rc8, same.
