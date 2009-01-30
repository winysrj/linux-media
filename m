Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:46020 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbZA3CGt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 21:06:49 -0500
Subject: Re: Howto obtain sysfs-pathes for DVB devices?
From: hermann pitton <hermann-pitton@arcor.de>
To: Carsten Meier <cm@trexity.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20090128164617.569d5952@tuvok>
References: <20090128164617.569d5952@tuvok>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 03:07:07 +0100
Message-Id: <1233281227.2688.3.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Mittwoch, den 28.01.2009, 16:46 +0100 schrieb Carsten Meier:
> Hello again,
> 
> now I've managed to obtain syfs-pathes for v4l2-devices. But what about
> dvb? I haven't found something like bus_info in the dvb-api-docs. (I'm
> new to it) Any hints for this?
> 
> Thanks,
> Carsten

I'm also still new on it ...

Maybe anything useful here?

cat /sys/class/dvb/dvb0.frontend0/uevent
MAJOR=212
MINOR=0
PHYSDEVPATH=/devices/pci0000:00/0000:00:08.0/0000:01:07.0
PHYSDEVBUS=pci
PHYSDEVDRIVER=saa7134

Cheers,
Hermann


