Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59236 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbbFDMrt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Jun 2015 08:47:49 -0400
Message-ID: <557048EF.3040703@iki.fi>
Date: Thu, 04 Jun 2015 15:47:43 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>,
	Linux-Media <linux-media@vger.kernel.org>
CC: Olli Salonen <olli.salonen@iki.fi>,
	Peter Faulkner-Ball <faulkner-ball@xtra.co.nz>
Subject: Re: [PATCH][media] SI2168: Resolve unknown chip version errors with
 different HVR22x5 models
References: <CALzAhNW=Oei7_Nziozh3Mm+X_NNHvM5EdmPVPh9ajn5Aen9O2g@mail.gmail.com>
In-Reply-To: <CALzAhNW=Oei7_Nziozh3Mm+X_NNHvM5EdmPVPh9ajn5Aen9O2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/04/2015 03:38 PM, Steven Toth wrote:
> We're seeing a mix of SI2168 demodulators appearing on HVR2205 and
> HVR2215 cards, the chips are stamped with different build dates,
> verified on my cards.
>
> The si2168 driver detects some cards fine, others not at all. I can
> reproduce the working and non-working case. The fix, if we detect a
> newer card (D40) load the B firmware.
>
> This fix works well for me and properly enables DVB-T tuning behavior
> using tzap.
>
> Thanks to Peter Faulkner-Ball for describing his workaround.

hymm, I am not sure that patch at all. It is Olli who has been 
responsible adding support for multiple chip revisions, so I will leave 
that for Olli. I have only 2 Si2168 devices and both are B40 version.

Anyhow, for me it looks like firmware major version is always increased 
when new major revision of chip is made. Due to that I expected 5.0 
after B version 5.0.
A 1.0
A 2.0
A 3.0
B 4.0
C 5.0 ?
D 6.0 ?


And how we could explain situation Olli has device that had been working 
earlier, but now it does not? Could you Olli look back you old git tree 
and test if it still works? One possible reason could be also PCIe 
interface I2C adapter bug. Or timing issue.


regards
Antti


-- 
http://palosaari.fi/
