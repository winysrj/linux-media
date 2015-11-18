Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:34771 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933311AbbKRQSy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2015 11:18:54 -0500
Received: by wmvv187 with SMTP id v187so286473594wmv.1
        for <linux-media@vger.kernel.org>; Wed, 18 Nov 2015 08:18:53 -0800 (PST)
Subject: Re: [BUG] TechniSat SkyStar S2 - problem tuning DVB-S2 channels
To: Robert <wslegend@web.de>, linux-media@vger.kernel.org
References: <564C9355.1090203@web.de>
From: Jemma Denson <jdenson@gmail.com>
Message-ID: <564CA4EB.60400@gmail.com>
Date: Wed, 18 Nov 2015 16:18:51 +0000
MIME-Version: 1.0
In-Reply-To: <564C9355.1090203@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On 18/11/15 15:03, Robert wrote:
> Hello,
>
> I am using a "TechniSat SkyStar S2" DVB-S2 card. Drivers for this card
> are included in the kernel tree since 4.2. Unfortunately, i can't tune
> to ANY DVB-S2 channels with this new in-tree driver. DVB-S channels are
> working fine. Id[1] of the commit which introduced support for this card.
>
> Before 4.2 arrived i have used this[2] patch with which DVB-S2 channels
> where tuneable without any problems. This patch works even with 4.3
> after i have converted the fe_ structs to enums.
>
> If you need anything to debug this behaviour, i will be at your disposal.
>
>

What program are you using to try and tune? Is it trying to tune in 
using DVB-S2? The "other" driver was done quite some while ago, and 
included some clunky code to fallback to S2 if DVB-S tuning failed as it 
was developed before the DVB API had support for supplying DVB-S2 as a 
delivery system and this was the only way of supporting S2 back then.
This was removed in the in-tree driver as it isn't needed anymore, but 
this does mean that the tuning program needs to supply the correct 
delivery system.

Have you tried it with dvbv5-scan & dvbv5-zap?

Regards,

Jemma
