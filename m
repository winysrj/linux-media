Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.infomaniak.ch ([84.16.68.89]:57316 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbZFWIOf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 04:14:35 -0400
Message-ID: <4A408EE0.7070001@deckpoint.ch>
Date: Tue, 23 Jun 2009 10:14:24 +0200
From: Thomas Kernen <tkernen@deckpoint.ch>
MIME-Version: 1.0
To: Andy Zivkovic <zivkovic.andy@gmail.com>,
	linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: Seeking recommendation for DVB-S PCI card with on-card CI
References: <4A3E4562.1050602@deckpoint.ch> <924cdc9c0906222008g6e9f2a8dl79c0664acfc02934@mail.gmail.com>
In-Reply-To: <924cdc9c0906222008g6e9f2a8dl79c0664acfc02934@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Zivkovic wrote:
>> Are these the same boards and/or different revisions? Are they supported by
>> the Mantis driver including the CI? This part I wasn't able to confirm from
>> my search.
> 
> Thomas,
> 
> The maintis driver currently doesn't support CI. Unfortunately I
> bought a Twinhan SP300 (1034) before I knew this, so I now have a
> DVB-S card that is effectively useless to me, but I'm hopeful someone
> will fix the driver one day (although I bought the card months ago and
> I'm close to cancelling my sat subscription since the set top box I
> have is crap, so I don't watch it enough to justify the monthly fees).
> 
> In mid May, Manu, who I think is a (the?) mantis developer, posted on
> this list saying he hadn't had time to work on mantis CI for the 2
> months prior to that. I haven't noticed anything new since then, so I
> don't know where it's at.
> 

Andy,

Thanks for the feedback, that was what I feared (CI not supported). 
Better to know ahead of time that after ordering such a card

Manu,

Any chance you would be able to comment on the planned roadmap for the 
CI support on the Azurewave/Twinham 1034 based cards?

All,

Are there any known working PCI based solutions that have the CI slot on 
the card itself? I'm attempting to find something that can be self 
contained within a single PCI slot.

Regards,
Thomas
