Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:39781 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab0I3Umn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 16:42:43 -0400
Message-ID: <4CA4F640.7030206@iki.fi>
Date: Thu, 30 Sep 2010 23:42:40 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@anciens.enib.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l/dvb: add support for AVerMedia AVerTV Red HD+ (A850T)
References: <1285795123-11046-1-git-send-email-yann.morin.1998@anciens.enib.fr> <1285795123-11046-2-git-send-email-yann.morin.1998@anciens.enib.fr> <4CA45AFC.2080807@iki.fi> <201009301956.50154.yann.morin.1998@anciens.enib.fr>
In-Reply-To: <201009301956.50154.yann.morin.1998@anciens.enib.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 09/30/2010 08:56 PM, Yann E. MORIN wrote:
> OK. The number of supported devices is already 9 in all sections, so I guess
> I'll have to add a new entry in the af9015_properties array, before I can
> add a new device, right?

Actually you are using too old code as base. You should take latest GIT 
media tree and 2.6.37 branch. IIRC max is currently 12 devices per entry.

> And what is the intrinsic difference between adding a new device section,
> compared to adding a new PID to an existing device (just curious) ?

Not much more than a little bit different device name. Technically you 
can add all IDs to one device, but I feel better to add new entry per 
device. If device name is same but only ID is different it typically 
means different hw revision and in that case I would like to put those 
same for same entry. In that case device is also a little bit different 
- at least case colour.

Antti
-- 
http://palosaari.fi/
