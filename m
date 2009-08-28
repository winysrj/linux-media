Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:36434 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbZH1OWD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2009 10:22:03 -0400
MIME-Version: 1.0
In-Reply-To: <4A97ADCD.6060200@googlemail.com>
References: <20090827045710.2d8a7010@pedra.chehab.org>
	 <20090827183636.GG26702@sci.fi>
	 <20090827185853.0aa2de76@pedra.chehab.org>
	 <829197380908271506i251b47caoe8c08d483e78e938@mail.gmail.com>
	 <20090828004628.06f34d12@pedra.chehab.org>
	 <20090828041459.67c1499a@pedra.chehab.org>
	 <4A97ADCD.6060200@googlemail.com>
Date: Fri, 28 Aug 2009 15:22:03 +0100
Message-ID: <3d374d00908280722l52a9e855t676d965baf208f3d@mail.gmail.com>
Subject: Re: [RFC] Infrared Keycode standardization
From: Alistair Buxton <a.j.buxton@gmail.com>
To: Peter Brouwer <pb.maillists@googlemail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	=?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <syrjala@sci.fi>,
	Linux Input <linux-input@vger.kernel.org>,
	Patrick Boettcher <patrick.boettcher@desy.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/8/28 Peter Brouwer <pb.maillists@googlemail.com>:
>
> Would like to add one more dimension to the discussion.
>
> The situation of having multiple DVB type boards in one system.
>
> Using one remote would be enough to control the system. So we should have a
> mechanism/kernel config option, to enable/disable an IR device on a board.
> For multiple boards of the same type, enable the first and disable any
> subsequently detected boards.

Don't forget that completely different boards can have identical
remotes. For example the RTL2831 driver has an almost identical copy
of dvb-usb IR code in it. See here for in depth explanation and patch
that makes it use dvb-usb instead:
http://patchwork.kernel.org/patch/38794/

Now I'm not really familiar with frontends and tuners so it may be
that the RTL driver should be reimplemented within dvb-usb instead,
but if it can't be it would be nice if that IR code could be shared
without pulling in all the rest of dvb-usb modules too. I'm told that
the excessive code duplication is the reason this driver isn't in
mainline yet - I've been using it with no problems for over two years
now.

-- 
Alistair Buxton
a.j.buxton@gmail.com
