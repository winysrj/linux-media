Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39584 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758829AbbCDOYa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 09:24:30 -0500
Date: Wed, 4 Mar 2015 11:24:22 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Steven Toth <stoth@kernellabs.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Subject: Re: HVR2205 / HVR2255 support
Message-ID: <20150304112422.7c9a6dc1@recife.lan>
In-Reply-To: <CALzAhNXOAJR6tV6PGL4-zqeE-Kx0BYgOxZpEfRvN6fmv9_wMKA@mail.gmail.com>
References: <CALzAhNXOAJR6tV6PGL4-zqeE-Kx0BYgOxZpEfRvN6fmv9_wMKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 4 Mar 2015 08:43:24 -0500
Steven Toth <stoth@kernellabs.com> escreveu:

> Mauro, what's the plan to pull the LGDT3306A branch into tip? The
> SAA7164/HVR2255 driver need this for demod support.

Merged yesterday. Today, I added one fix from Olli to extend the 
si2157 minimal frequency to match the ATSC tuner range (needed by 
HVR-955Q - not sure if HVR2255 also uses si2157 as tuner).

Regards,
Mauro

> 
> Hey folks, an update on this.
> 
> So I have the green-light to release my HVR2205 and HVR2255 board
> related patches. I started merging them into tip earlier this week.
> The HVR2205 is operational for DVB-T, although I have not tested
> analog tv as yet.
> 
> The HVR2255 is the next on the list, I expect this to be trivial once
> the HVR2205 work is complete.
> 
> Annoyingly, I'm traveling on business for the next 10 days or so. I
> can't complete the work until I return - but I expect to complete this
> entire exercise by 21st of this month.... So hold on a little longer
> and keep watching this mailing list for further updates.
> 
> Thanks,
> 
> - Steve
> 
