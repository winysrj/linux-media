Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44755 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760626Ab2FUXMW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 19:12:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Oleksij Rempel <bug-track@fisher-privat.net>
Cc: linux-uvc-devel@lists.sourceforge.net, linux-media@vger.kernel.org
Subject: Re: [linux-uvc-devel] [RFC] Media controller entity information ioctl [was "Re: [patch] suggestion for media framework"]
Date: Fri, 22 Jun 2012 01:12:33 +0200
Message-ID: <8600912.NnP0Jj1IK2@avalon>
In-Reply-To: <4FE355B2.50906@fisher-privat.net>
References: <4FCB9C12.1@fisher-privat.net> <1915602.ON5YbSOUmP@avalon> <4FE355B2.50906@fisher-privat.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thursday 21 June 2012 19:11:14 Oleksij Rempel wrote:
> On 08.06.2012 04:46, Laurent Pinchart wrote:
> > On Monday 04 June 2012 10:11:33 Robert Krakora wrote:
> >> When you say "static" you mean items that are "well known" by the system
> >> by reading a registry at initialization?
> > 
> > By static I mean items that are initialized at driver initialization time
> > and not modified afterwards. I don't think we should support
> > adding/removing items at runtime, at least in the first version.
> > 
> >> When a new device exposes functionality that necessitates the creation of
> >> a new "static" item then how does the registry get updated to reflect
> >> this or am I misunderstanding?
> > 
> > Item types should be defined in a kernel header and documented. If a
> > driver needs a new item types, the driver developer should add the new
> > type to the header and document it.
> 
> Hi Laurent,
> 
> what is your progress on this issue?

None unfortunately. I won't have time to work on this before July at the 
earliest.

> I was able to make video stream on my webcam work more stable by setting
> "snd_usb_audio ignore_ctl_error=1". I think it is one of cases where
> media framework should help.

-- 
Regards,

Laurent Pinchart

