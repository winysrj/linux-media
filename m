Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:58724 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbZJCWxI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Oct 2009 18:53:08 -0400
Subject: Re: [2.6.31] ir-kbd-i2c oops.
From: Hermann Pitton <hermann-pitton@arcor.de>
To: =?UTF-8?Q?Pawe=C5=82?= Sikora <pluto@agmk.net>
Cc: Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>
In-Reply-To: <200910032109.01674.pluto@agmk.net>
References: <200909160300.28382.pluto@agmk.net>
	 <200910031730.45021.pluto@agmk.net>
	 <20091003201527.110b69e3@hyperion.delvare>
	 <200910032109.01674.pluto@agmk.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Oct 2009 00:52:18 +0200
Message-Id: <1254610338.11623.46.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Samstag, den 03.10.2009, 21:09 +0200 schrieb Paweł Sikora:
> On Saturday 03 October 2009 20:15:27 Jean Delvare wrote:
> 
> > > moreover, with this patch i'm observing a flood in dmesg:
> > >
> > > [  938.313245] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12
> > > down=1 [  938.419914] i2c IR (Pinnacle PCTV): unknown key: key=0x12
> > > raw=0x12 down=0 [  939.273249] i2c IR (Pinnacle PCTV): unknown key:
> > > key=0x24 raw=0x24 down=1 [  939.379955] i2c IR (Pinnacle PCTV): unknown
> > > key: key=0x24 raw=0x24 down=0
> > 
> > Different issue, and I don't know much about IR support, but these keys
> > aren't listed in ir_codes_pinnacle_color. Maybe you have a different
> > variant of this remote control with more keys and we need to add their
> > definitions.
> 
> i have such one: http://imgbin.org/index.php?page=image&id=812

hm, maybe it is some fake Pinnacle stuff, at least that remote is very
different from the supported ones with gray only or colored keys and
looks very poor.

I would have to boot into vista to check if it could be one of the new
missing remotes. That the original Pinnacle logo with the P with the red
ball and the yellow light point is not on it looks at least suspicious.

> > Which keys are triggering these messages?
> 
> this is the funny thing because i'm not pressing any keys at all.
> the remote control is unused currently becasue i'm using only
> pinnacle svideo input for watching sat-tv with tvtime.

Else, anyway, we have a disabled Pinnacle remote already on the 300i
conflicting with other stuff, we have also devices with the same PCI
subsystem as 310i with and without LNA and now some new remote.

The old undocumented LNA support was broken in favor to have new
undocumented LNA support for some undocumented/unidentified Hauppauge
HVR1110 devices.

Obviously they have been mad enough also not only not to change the
subsystem, but did let even the receiver chip on the same 0x47 address.

I had all my comments already previously.

Hauppauge bought Pinnacle some time back for such products, but we are
far away from to get eeprom and checksum information to sort that mess.

Since I have been told, nobody has access to such information yet, folks
must make their decisions. Seems recent saa7134 Pinnacle stuff is not
the first choice.

Cheers,
Hermann






