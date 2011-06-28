Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46339 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759389Ab1F1QtD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 12:49:03 -0400
Received: by vxb39 with SMTP id 39so289327vxb.19
        for <linux-media@vger.kernel.org>; Tue, 28 Jun 2011 09:49:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E08FDD8.6090300@helmutauer.de>
References: <4E08FDD8.6090300@helmutauer.de>
Date: Tue, 28 Jun 2011 18:49:01 +0200
Message-ID: <BANLkTi=8TOy87YYxXb=HosHTPw_jEzBBLQ@mail.gmail.com>
Subject: Re: FM RDS receiver
From: Markus Rechberger <mrechberger@gmail.com>
To: Helmut Auer <vdr@helmutauer.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Jun 28, 2011 at 12:02 AM, Helmut Auer <vdr@helmutauer.de> wrote:
> Hello List,
>
> Can you recommend any FM receiver card or usb stick currently available in
> Germany with RDS support ?

We do have some FM Receiver/Transmitters which support RDS, however they
are still only available upon request at this time.
Audio is represented by ALSA (snd-usb-audio), radio can be controlled
via v4l1/v4l2 from userspace.

Alternatively Sundtek MediaTV Pro also supports RDS and is available
on the market
right now (decoders can be requested), audio is represented as OSS,
although Alsa shouldn't be too difficult using
the new userspace Alsa interface.

Markus
