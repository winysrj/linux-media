Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54487 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065Ab0JHVST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Oct 2010 17:18:19 -0400
Received: by iwn6 with SMTP id 6so806235iwn.19
        for <linux-media@vger.kernel.org>; Fri, 08 Oct 2010 14:18:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101008151305.68f3897a@bike.lwn.net>
References: <20101008210418.2B1809D401C@zog.reactivated.net>
	<20101008151305.68f3897a@bike.lwn.net>
Date: Fri, 8 Oct 2010 22:18:18 +0100
Message-ID: <AANLkTi=G_k6CSy9wUTiXNK9DHPwk4FTqPWRReRC7DO24@mail.gmail.com>
Subject: Re: [PATCH 2/3] ov7670: disable QVGA mode
From: Daniel Drake <dsd@laptop.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 8 October 2010 22:13, Jonathan Corbet <corbet@lwn.net> wrote:
> A problem like that will be at the controller level, not the sensor
> level.  Given that this is an XO-1 report, I'd assume something
> requires tweaking in the cafe_ccic driver.  I wasn't aware of this; I
> know it worked once upon a time.

I reported it 3 months ago
http://dev.laptop.org/ticket/10231

Are you interested in working on this?
I'd have no idea where to start.

I'm not so convinced that it's a controller problem rather than a
sensor one, given that it says the sensor register values were
determined empirically rather than from docs.

Thanks,
Daniel
