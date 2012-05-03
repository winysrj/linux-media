Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48389 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754842Ab2ECOso (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 10:48:44 -0400
Received: by vcqp1 with SMTP id p1so1311479vcq.19
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 07:48:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FA293AA.5000601@iki.fi>
References: <4FA293AA.5000601@iki.fi>
Date: Thu, 3 May 2012 10:48:43 -0400
Message-ID: <CAGoCfiw9h8ZqAnrdpg3J8rtnna=JiXj6JYL-gU58xS2HmMuT_w@mail.gmail.com>
Subject: Re: common DVB USB issues we has currently
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <Antti.Palosaari@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

On Thu, May 3, 2012 at 10:18 AM, Antti Palosaari
> 1)
> Current static structure is too limited as devices are more dynamics
> nowadays. Driver should be able to probe/read from eeprom device
> configuration.
>
> Fixing all of those means rather much work - I think new version of DVB USB
> is needed.
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg44996.html

What does this link above have to do with problem #1?  Did you perhaps
cut/paste the wrong link?

> 2)
> Suspend/resume is not supported and crashes Kernel. I have no idea what is
> wrong here and what is needed. But as it has been long term known problem I
> suspect it is not trivial.
>
> http://www.spinics.net/lists/linux-media/msg10293.html

I doubt this is a dvb-usb problem, but rather something specific to
the realtek parts (suspend/resume does work with other devices that
rely on dvb-usb).

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
