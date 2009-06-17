Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:43210 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZFQIS1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 04:18:27 -0400
Received: by gxk10 with SMTP id 10so265961gxk.13
        for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 01:18:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40139DF9703@dlee06.ent.ti.com>
References: <1244580953-24188-1-git-send-email-m-karicheri2@ti.com>
	 <aec7e5c30906142157t313e7c95v3d1ab19f80745cf5@mail.gmail.com>
	 <A69FA2915331DC488A831521EAE36FE40139DF92A6@dlee06.ent.ti.com>
	 <aec7e5c30906152102r27aa2894q857be2ffb30d1d45@mail.gmail.com>
	 <A69FA2915331DC488A831521EAE36FE40139DF9703@dlee06.ent.ti.com>
Date: Wed, 17 Jun 2009 17:18:29 +0900
Message-ID: <aec7e5c30906170118t737ce2b0j4424174d5cd12893@mail.gmail.com>
Subject: Re: [PATCH RFC] adding support for setting bus parameters in sub
	device
From: Magnus Damm <magnus.damm@gmail.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 16, 2009 at 11:33 PM, Karicheri,
Muralidharan<m-karicheri2@ti.com> wrote:
>
> <snip>
>>>
>>> [MK]In that case can't the driver just ignore the field polarity? I
>>assume that drivers implement the parameter that has support in hardware.
>>So it is not an issue.
>>
>>No, because the same driver runs on hardware that also has the field
>>signal. So we need to be able to give information about which signals
>>that the board actually implement. We already do this with the
>>soc_camera framework and it is working just fine.
>
>
> Hardware with field signal used (driver use polarity from platform data and set it in the hardware)
> Hardware with field signal not used (In this case, even though the driver sets it in the hardware, it is not really used in the hardware design and hence is a don't care. right?
>
> So I don't see why it matters.

Maybe I'm misunderstanding what you are trying to do. But how can the
camera sensor driver check if the field signal is present or not? The
camera sensor driver may need information if a pin is present or not
for some decision? Perhaps for hardware configuration?

A good example IMO is the tw9910 driver and the mpout signal. Right
now the mpout configuration is part of the platform data, but maybe it
would make more sense to allow the driver to check if field is used on
the platform and if so configure the pin accordingly.

/ magnus
