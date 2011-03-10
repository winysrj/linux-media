Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47786 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1CJQ1p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 11:27:45 -0500
Received: by qyg14 with SMTP id 14so1590671qyg.19
        for <linux-media@vger.kernel.org>; Thu, 10 Mar 2011 08:27:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110310170221.2bc8c2b8@borg.bxl.tuxicoman.be>
References: <201102280102.17852.malte.gell@gmx.de>
	<4D6AEC35.8000202@iki.fi>
	<20110310170221.2bc8c2b8@borg.bxl.tuxicoman.be>
Date: Thu, 10 Mar 2011 17:27:44 +0100
Message-ID: <AANLkTin_EOL1SmOJnqSUhVEVAzZs85Z=xV1fJu0KUBj+@mail.gmail.com>
Subject: Re: Well supported USB DVB-C device?
From: Markus Rechberger <mrechberger@gmail.com>
To: Guy Martin <gmsoft@tuxicoman.be>
Cc: Antti Palosaari <crope@iki.fi>, Malte Gell <malte.gell@gmx.de>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Mar 10, 2011 at 5:02 PM, Guy Martin <gmsoft@tuxicoman.be> wrote:
> On Mon, 28 Feb 2011 02:28:37 +0200
> Antti Palosaari <crope@iki.fi> wrote:
>
>>
>> I am not sure which is status of TT CT-3650, it could be other one
>> which is working.
>>
>
> The CT-3650 works well. I belive everything works (CI, IR) but DVB-T is
> not yet implemented on that one.
>

without AC Adapter Sundtek MediaTV Pro (DVB-C, DVB-T, AnalogTV,
FM-Radio, Composite, S-Video) / Digital Home (DVB-C, DVB-T only),
supported from Linux 2.6.15 - (any newer System). Full standby after
15 seconds inactivity. Also supported across many different
Architectures.
Driver installation should not take longer than 10 seconds on just
about any system.
Some multimedia distributions already ship direct support for it.

BR,
Markus
