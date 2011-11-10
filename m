Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:32950 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab1KJM4W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 07:56:22 -0500
Message-ID: <4EBBC9F1.4060103@linuxtv.org>
Date: Thu, 10 Nov 2011 13:56:17 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1vbnQ=?= <remi@remlab.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: DVBv5 frontend library
References: <4EBACE27.8000907@redhat.com> <b0eac44a264432f586edf13983ea6829@chewa.net> <4EBBBDF1.2050601@redhat.com>
In-Reply-To: <4EBBBDF1.2050601@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10.11.2011 13:05, Mauro Carvalho Chehab wrote:
> Em 10-11-2011 05:08, Rémi Denis-Courmont escreveu:
>> For frequency, we also need a unit, since it depends on the
>> delivery system.
> 
> The spec says:
> 	DTV_FREQUENCY
> 
> 	Central frequency of the channel, in HZ.
> 
> So, the unit should be Hz. If is there any place where something different is
> used, we should fix it to match what's specified there.

For DVB-S, the unit is and has always been kHz. The spec is wrong.

>> 5) Unless/Until the library implements scanning and some kind of channel
>> or transponder abstraction (e.g. unique ID per transponder), it is dubious
>> that it can really abstract new delivery systems. I mean, the tuning
>> parameters need to come from somewhere, so the application will have to
>> know about the delivery systems.
> 
> Sure. This is the next item on my TODO list ;)

Make sure to generate globally unique IDs. Even though onid + tsid + sid
*should* identify a DVB service, in reality they don't. There are many
duplicates, especially with - but not limited to - reception of multiple
satellites.

Regards,
Andreas
