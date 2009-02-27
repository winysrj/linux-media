Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:15337 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbZB0SfA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 13:35:00 -0500
Received: by yw-out-2324.google.com with SMTP id 5so906462ywh.1
        for <linux-media@vger.kernel.org>; Fri, 27 Feb 2009 10:34:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e816454e0902271027k295aa341r384752829687b7e8@mail.gmail.com>
References: <499E381D.4070607@linuxtv.org>
	 <387ee2020902192125w47916ebr7c633f7a6c092120@mail.gmail.com>
	 <499EC549.7090909@linuxtv.org>
	 <387ee2020902200707n185ec344m823a33a8fdce72e3@mail.gmail.com>
	 <e816454e0902270833i73cd59f0t1129ab7011b0024c@mail.gmail.com>
	 <387ee2020902270845u7700b4feuc2c8d6898947e641@mail.gmail.com>
	 <49A81DCE.6060201@linuxtv.org>
	 <387ee2020902270918y1f06a54evf4d14f15765e886b@mail.gmail.com>
	 <49A820B9.7000004@linuxtv.org>
	 <e816454e0902271027k295aa341r384752829687b7e8@mail.gmail.com>
Date: Fri, 27 Feb 2009 13:34:57 -0500
Message-ID: <412bdbff0902271034qd762d8pc2254ed14e930b72@mail.gmail.com>
Subject: Re: [linux-dvb] Fwd: HVR2250 Status - Where am I?
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb <linux-dvb@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 27, 2009 at 1:27 PM, Andrew Barbaccia
> Sorry, maybe I phrased my request as a solution which is not what I
> intended. I was unaware of your agreements with NXP. I see you added how
> much money has been donated to your post. That's more than enough of a
> status indicator for me.
> Possibly could you roughly estimate how much more work is required and
> present it in the same manner?
> I want to you know that I do support this project and have just contributed
> - both as a thank you for your prior work and willingness to help the
> community in addition to the HVR-2250 support.

Andrew,

I cannot speak to the saa7164, but to give you an order of magnitude,
I spent over a month working on the saa7136 support, working every
night and weekend for 4-6 hours.  The analog support I did for the
au0828/au8522 took about 100 hours.

So, while not necessarily an apples-to-apples comparison, these
drivers tend to take tens or sometimes hundreds of hours of
development.  They are definitely a non-trivial amount of work to do.

Bear in mind that the saa7164 is a much more complicated chip than the saa7136.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
