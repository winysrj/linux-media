Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:39978 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbZA3Mpx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2009 07:45:53 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: Carsten Meier <cm@trexity.de>
Subject: Re: Howto obtain sysfs-pathes for DVB devices?
Date: Fri, 30 Jan 2009 13:45:47 +0100
Cc: hermann pitton <hermann-pitton@arcor.de>,
	linux-media@vger.kernel.org
References: <20090128164617.569d5952@tuvok> <200901301251.05258.zzam@gentoo.org> <20090130132339.3e96df3d@tuvok>
In-Reply-To: <20090130132339.3e96df3d@tuvok>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301345.48529.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Freitag, 30. Januar 2009, Carsten Meier wrote:
> Am Fri, 30 Jan 2009 12:51:03 +0100
> >
> > One way of asking udev is this:
> > udevadm info -q path -n /dev/dvb/adapter0/frontend0
> >
> > Regards
> > Matthias
>
> Ok, then I think I'm gonna use it... :) It's much more simple than
> struggling through dbus-/hal-libs and the various unfinished c++
> bindings, although I normally don't like to start system-tools from c++.
> Or is there any c-api for it? I haven't found one.
>

There is a in development version of libudev contained since udev-127. But its 
API is not yet stable I think.

Regards
Matthias
