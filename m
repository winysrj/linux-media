Return-path: <linux-media-owner@vger.kernel.org>
Received: from anakin.london.02.net ([87.194.255.134]:50887 "EHLO
	anakin.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161197Ab3DEMZE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Apr 2013 08:25:04 -0400
From: Adam Sampson <ats@offog.org>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: linux-media@vger.kernel.org
Subject: Re: Hauppauge Nova-S-Plus DVB-S works for one channel, but cannot tune in others
References: <1463242.ms8FUp7FVg@xrated>
Date: Fri, 05 Apr 2013 13:25:01 +0100
In-Reply-To: <1463242.ms8FUp7FVg@xrated> (Hans-Peter Jansen's message of "Fri,
	05 Apr 2013 13:46 +0200")
Message-ID: <y2ar4ipcggy.fsf@cartman.at.offog.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans-Peter Jansen <hpj@urpla.net> writes:

> In one of my systems, I've used a 
> Hauppauge Nova-S-Plus DVB-S card successfully, but after a system upgrade to 
> openSUSE 12.2, it cannot tune in all but one channel.
[...]
> initial transponder 12551500 V 22000000 5
>>>> tune to: 12551:v:0:22000
> DVB-S IF freq is 1951500
> WARNING: >>> tuning failed!!!

I suspect you might be running into this problem:
  https://bugzilla.kernel.org/show_bug.cgi?id=9476

The bug title is misleading -- the problem is actually that the card
doesn't get configured properly to send the 22kHz tone for high-band
transponders, like the one in your error above.

Applying this patch makes my Nova-S-Plus work with recent kernels:
  https://bugzilla.kernel.org/attachment.cgi?id=21905&action=edit

Thanks,

-- 
Adam Sampson <ats@offog.org>                         <http://offog.org/>
