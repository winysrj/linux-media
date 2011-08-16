Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35306 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab1HPKaM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 06:30:12 -0400
Received: by vws1 with SMTP id 1so4608966vws.19
        for <linux-media@vger.kernel.org>; Tue, 16 Aug 2011 03:30:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E48F5F6.1020700@iki.fi>
References: <4E486AA2.30905@iki.fi>
	<CAPEGoTBhSkud+QLACn3i=AFpx8wYDk1O=mSJHF8iPjGCxibEfA@mail.gmail.com>
	<4E48F5F6.1020700@iki.fi>
Date: Tue, 16 Aug 2011 12:30:11 +0200
Message-ID: <CAPEGoTCU3cpP=prjuud3Wkobszg8+iZFi7BOZzKaw2xJx03S4Q@mail.gmail.com>
Subject: Re: dvb-apps: update DVB-T intial tuning files for Finland (fi-*)
From: Hein Rigolo <rigolo@gmail.com>
To: Antti Palosaari <crope@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Christoph Pfister <christophpfister@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 15, 2011 at 12:33 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 08/15/2011 12:56 PM, Hein Rigolo wrote:
>> On Mon, Aug 15, 2011 at 2:38 AM, Antti Palosaari <crope@iki.fi> wrote:
>>> Updates all Finnish channels as today.
>>>
>>> Antti
>>
>> Do we still need to have separate initial tuning files per region in finland?
>>
>> For France it was decided that the auto-With167kHzOffsets file would
>> be enough to find all possible DVB-T transponders in France. It was
>> suggested to create a fr-All that would be symlinked to the
>> auto-With167kHzOffsets file, but that was not implemented yet (as far
>> as I can see from the dvb-apps repository)
>>
>> Can this approach also work for Finland?
>
> It was spoken ages for creation of EU-All, Taiwan-All, UK-All etc. but I
> don't remember which have been problem. For example many Windows
> channels scanner have such files. Finland uses standard EU channels,
> channels under 20 are VHF 7 MHz and channels over 20 are UHF 8 MHz. Just
> same used almost everywhere in EU.
>
Actually you already see the move the *-All happening in a lot of
countries. Looking at the latest dvb-t directory in the dvb-apps
repository i already see the following countries:

be-All
ch-All
cz-All
dk-All
hr-All
il-All
lt-All
lu-All
nl-All

Then there are single files for some countries without the All

ad-Andorra
at-Official
hk-HongKong

and then there are the country specific auto-* files
auto-Australia
auto-Italy
auto-Taiwan

For france it was decided that auto-With167kHzOffsets would be good
enough (but there is no fr-All that points to this file)

So the generic EU-All etc might not be there, but effectively they are
already somewhere in these other files.

So then we could just decide the make a generic file, and symlink the
country specific *-All files to this generic file where appropriate,
or have separate files for those countries that use a different
standard.

Hein
