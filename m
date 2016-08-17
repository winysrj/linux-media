Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:36130 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753842AbcHQGoC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 02:44:02 -0400
Subject: Re: Linux support for current StarTech analog video capture device
 (SAA711xx)
To: Steve Preston <stevepr@netstevepr.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <2d1d06c05dae478b9bc2484e9d1da36c@MBX06A-IAD3.mex08.mlsrvr.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <93f180f6-7a1b-8ea9-37dc-c4eb1a243998@xs4all.nl>
Date: Wed, 17 Aug 2016 08:43:56 +0200
MIME-Version: 1.0
In-Reply-To: <2d1d06c05dae478b9bc2484e9d1da36c@MBX06A-IAD3.mex08.mlsrvr.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/16/2016 11:29 PM, Steve Preston wrote:
> I realize this is a long shot but I was directed to this mailing list as one possibility  . 
>  
> I work with a group of amateur astronomers who use analog video cameras to record occultations ( www.occulations.org ).  Several observers have been using the StarTech SVID2USB2 class of analog capture devices (USB dongle) under Windows.  The StarTech devices are one of the few such devices which are readily available today. These StarTech devices seemed to be based on the empia 28xx + SAA71xx chipset devices which have some support in the linux kernel.  Unfortunately, we are having trouble with the StarTech devices in Linux.  Does anyone on this list know of anyone in the linxtv.org (or related) community that might be willing to help us modify a current driver to enable the StarTech device(s)?  Or, do you know of anyone who currently works with analog video capture hardware in linux who might be willing to provide other ideas?

Usually adding support for a new device is a matter of adding an entry to drivers/media/usb/em28xx/em28xx-cards.c.

Something like the EM2860_BOARD_TYPHOON_DVD_MAKER could be a starting point since it seems very similar.

I'm assuming that the problem is that the device isn't recognized, but since you don't actually say what the problem is I might be wrong...

Regards,

	Hans
