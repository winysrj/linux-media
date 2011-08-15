Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34318 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab1HOKd3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 06:33:29 -0400
Message-ID: <4E48F5F6.1020700@iki.fi>
Date: Mon, 15 Aug 2011 13:33:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hein Rigolo <rigolo@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: dvb-apps: update DVB-T intial tuning files for Finland (fi-*)
References: <4E486AA2.30905@iki.fi> <CAPEGoTBhSkud+QLACn3i=AFpx8wYDk1O=mSJHF8iPjGCxibEfA@mail.gmail.com>
In-Reply-To: <CAPEGoTBhSkud+QLACn3i=AFpx8wYDk1O=mSJHF8iPjGCxibEfA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/15/2011 12:56 PM, Hein Rigolo wrote:
> On Mon, Aug 15, 2011 at 2:38 AM, Antti Palosaari <crope@iki.fi> wrote:
>> Updates all Finnish channels as today.
>>
>> Antti
> 
> Do we still need to have separate initial tuning files per region in finland?
> 
> For France it was decided that the auto-With167kHzOffsets file would
> be enough to find all possible DVB-T transponders in France. It was
> suggested to create a fr-All that would be symlinked to the
> auto-With167kHzOffsets file, but that was not implemented yet (as far
> as I can see from the dvb-apps repository)
> 
> Can this approach also work for Finland?

It was spoken ages for creation of EU-All, Taiwan-All, UK-All etc. but I
don't remember which have been problem. For example many Windows
channels scanner have such files. Finland uses standard EU channels,
channels under 20 are VHF 7 MHz and channels over 20 are UHF 8 MHz. Just
same used almost everywhere in EU.

Antti


-- 
http://palosaari.fi/
