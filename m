Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63950 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab1LPJgR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Dec 2011 04:36:17 -0500
Received: by vbbfc26 with SMTP id fc26so2281820vbb.19
        for <linux-media@vger.kernel.org>; Fri, 16 Dec 2011 01:36:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1112161014580.6572@axis700.grange>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1112160909470.6572@axis700.grange>
	<CAHG8p1AXghgSQNHUQi5V56ROAfS9tOsMRbAMqNogNG0=m7zzkQ@mail.gmail.com>
	<Pine.LNX.4.64.1112161014580.6572@axis700.grange>
Date: Fri, 16 Dec 2011 17:36:16 +0800
Message-ID: <CAHG8p1BLVgO1_vN+Wsk1R6awG+uAht1Z9w542naOO53XqVThOQ@mail.gmail.com>
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org, saaguirre@ti.com,
	mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> How about this implementation? I know it's not for soc, but I post it
>> to give my idea.
>> Bridge knows the layout, so it doesn't need to query the subdevice.
>
> Where from? AFAIU, we are talking here about subdevice inputs, right? In
> this case about various inputs of the TV decoder. How shall the bridge
> driver know about that?

I have asked this question before. Laurent reply me:

> >> ENUMINPUT as defined by V4L2 enumerates input connectors available on
> >> the board. Which inputs the board designer hooked up is something that
> >> only the top-level V4L driver will know. Subdevices do not have that
> >> information, so enuminputs is not applicable there.
> >>
> >> Of course, subdevices do have input pins and output pins, but these are
> >> assumed to be fixed. With the s_routing ops the top level driver selects
> >> which input and output pins are active. Enumeration of those inputs and
> >> outputs wouldn't gain you anything as far as I can tell since the
> >> subdevice simply does not know which inputs/outputs are actually hooked
> >> up. It's the top level driver that has that information (usually passed
> >> in through board/card info structures).

Regards,
Scott
