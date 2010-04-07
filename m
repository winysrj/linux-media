Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:55995 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754249Ab0DGWQR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Apr 2010 18:16:17 -0400
Subject: Re: RFC: exposing controls in sysfs
From: hermann pitton <hermann-pitton@arcor.de>
To: Lars Hanisch <dvb@cinnamon-sage.de>
Cc: Mike Isely <isely@isely.net>, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media@vger.kernel.org
In-Reply-To: <4BBCD3F9.1070207@cinnamon-sage.de>
References: <201004052347.10845.hverkuil@xs4all.nl>
	 <alpine.DEB.1.10.1004060848540.27169@cnc.isely.net>
	 <4BBCD3F9.1070207@cinnamon-sage.de>
Content-Type: text/plain
Date: Thu, 08 Apr 2010 00:15:28 +0200
Message-Id: <1270678528.6429.35.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Mittwoch, den 07.04.2010, 20:50 +0200 schrieb Lars Hanisch:
> Am 06.04.2010 16:33, schrieb Mike Isely:
[snip]
> >>
> >> Mike, do you know of anyone actively using that additional information?
> >
> > Yes.
> >
> > The VDR project at one time implemented a plugin to directly interface
> > to the pvrusb2 driver in this manner.  I do not know if it is still
> > being used since I don't maintain that plugin.
> 
>   Just FYI:
>   The PVR USB2 device is now handled by the pvrinput-plugin, which uses only ioctls. The "old" pvrusb2-plugin is obsolete.
> 
>   http://projects.vdr-developer.org/projects/show/plg-pvrinput
> 
> Regards,
> Lars.

[snip]

thanks Lars.

Mike is really caring and went out for even any most obscure tuner bit
to help to improve such stuff in the past, when we have been without any
data sheets.

To open second, maybe third and even forth ways for apps to use a
device, likely going out of sync soon, does only load maintenance work
without real gain.

We should stay sharp to discover something others don't want to let us
know about. All other ideas about markets are illusions. Or?

So, debugfs sounds much better than sysfs for my taste.

Any app and any driver, going out of sync on the latter, will remind us
that backward compat _must always be guaranteed_  ...

Or did change anything on that and is sysfs excluded from that rule?

Cheers,
Hermann




