Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.211.175]:46186 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbZIJDno convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2009 23:43:44 -0400
Received: by ywh5 with SMTP id 5so6678945ywh.4
        for <linux-media@vger.kernel.org>; Wed, 09 Sep 2009 20:43:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5df807700909082037n3d5ed809id2966632ce5e8a97@mail.gmail.com>
References: <5df807700909082037n3d5ed809id2966632ce5e8a97@mail.gmail.com>
Date: Thu, 10 Sep 2009 13:43:46 +1000
Message-ID: <5df807700909092043u6afec694i38633ea5e73599fc@mail.gmail.com>
Subject: Re: saa7134 doesn't work after warm-reboot
From: David Whyte <david.whyte@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 9, 2009 at 1:37 PM, David Whyte <david.whyte@gmail.com> wrote:

> My brother lives in an area that suffers very short power-outages if
> there is a storm or whatever and I have noticed that after such an
> event, he loses the ability to record TV from both tuners and
> generally only one will work.  I am never sure if it is always the
> same tuner that as busted since I don't know which is dvb0 or dvb1 at
> any point in time.
>
> To correct this, I remote into the server and issue a 'halt', get him
> to unplug it from the wall then press the power button on the front of
> the machine, re-plug it into the wall and boot up the server.  Then
> both tuners are working fine.
>

Further info, the power outage was for about 10 seconds in the latest
incident.  Also, there is no need to unplug the PC power from the wall
and press the power button etc to recover, you just need to leave the
machine powered down for a short while.

Sounds a lot like the issues I have read about where the firmware
remains in the tuner card but is corrupt or something.  The only way
is to clear the firmware and re-upload it, generally by powering down
for sometime but I am hoping that you can do this by unloading then
loading the modules.

Is this possible?  Anyone know which modules in this instance?

Regards,
Whytey
