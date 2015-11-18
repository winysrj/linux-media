Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:53641 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247AbbKRTI0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2015 14:08:26 -0500
Received: from [192.168.1.101] ([178.112.13.172]) by smtp.web.de (mrweb002)
 with ESMTPSA (Nemesis) id 0MHYLM-1Zvohg0tPY-003J9j for
 <linux-media@vger.kernel.org>; Wed, 18 Nov 2015 20:08:24 +0100
Subject: Re: [BUG] TechniSat SkyStar S2 - problem tuning DVB-S2 channels
To: linux-media@vger.kernel.org
References: <564C9355.1090203@web.de> <564CA4EB.60400@gmail.com>
From: Robert <wslegend@web.de>
Message-ID: <564CCCA1.6010808@web.de>
Date: Wed, 18 Nov 2015 20:08:17 +0100
MIME-Version: 1.0
In-Reply-To: <564CA4EB.60400@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jemma,

On 18.11.2015 17:18, Jemma Denson wrote:
> What program are you using to try and tune? Is it trying to tune in
> using DVB-S2? The "other" driver was done quite some while ago, and
> included some clunky code to fallback to S2 if DVB-S tuning failed as it
> was developed before the DVB API had support for supplying DVB-S2 as a
> delivery system and this was the only way of supporting S2 back then.
> This was removed in the in-tree driver as it isn't needed anymore, but
> this does mean that the tuning program needs to supply the correct
> delivery system.
> 
> Have you tried it with dvbv5-scan & dvbv5-zap?

Normally i'm using kaffeine, but i have tried dvbv5-scan now.
Unfortunately it segfaults. I have attached the full output including
the backtrace [1]


Greetings,
Robert


[1]
https://paste.linuxlounge.net/?c3886ef444f9aa37#2ah2g19a9CfJMA/pBDikwoWj7S4AG2slhacWjXy8jEo=




