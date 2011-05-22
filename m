Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57808 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab1EVBhL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 21:37:11 -0400
Received: by ewy4 with SMTP id 4so1495094ewy.19
        for <linux-media@vger.kernel.org>; Sat, 21 May 2011 18:37:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTin=Fs-ugm13yT89PtT4bds4WobszA@mail.gmail.com>
References: <BANLkTin=Fs-ugm13yT89PtT4bds4WobszA@mail.gmail.com>
Date: Sat, 21 May 2011 21:37:08 -0400
Message-ID: <BANLkTi=poXh2q+4N6Q9iMJxoW=9txLjt4w@mail.gmail.com>
Subject: Re: Connexant cx25821 help
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Roman Gaufman <hackeron@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, May 21, 2011 at 3:34 PM, Roman Gaufman <hackeron@gmail.com> wrote:
> I have a PCI-E capture card with two connexant cx25821 chips.
> 04:00.0 Multimedia video controller: Conexant Systems, Inc. Device 8210
> 05:00.0 Multimedia video controller: Conexant Systems, Inc. Device 8210
>
>
> There is a staging driver in latest linux kernels. Looks like it uses v4l2
> api.
> I tried to use precompiled module cx25821 provided with Ubuntu 10.10 beta
> (2.6.35-19-generic #28-Ubuntu SMP Sun Aug 29 06:36:51 UTC 2010 i686
> GNU/Linux).

Just because there is a driver for whatever chipset your board happens
to have, doesn't mean that your board is actually supported.  The
definition of a product is more than just the chips that are on it.

> # modprobe cx25821

You should *never* have to manually modprobe.  If you ran modprobe,
then that means the driver does not know about the PCI ID for your
board.

> The module looks like to be loaded successfully.
<snip>
> And now I can not see any /dev/video0-7 devices to get input from the card.
> I'l greatly appreciate if someone could tell me about additional actions to
> make this work.

The /dev/video devices will not be created if the driver did not
associate with the card.  Basically what you did is the equivalent of
modprobing any driver in the system regardless of whether or not it
has anything to do with the actual hardware you happen to have.

Somebody would likely have to do work to modify the driver to support
your board.  This would mean a driver developer who actually cared
enough to do the work would have to have one of the boards, which
doesn't appear to be the case at this point.

Hope that helps (or at least it makes clear that this board will not
just start to magically work just because you have a card which
contains the chips involved).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
