Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41557 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1LYTAh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Dec 2011 14:00:37 -0500
Received: by werm1 with SMTP id m1so4725044wer.19
        for <linux-media@vger.kernel.org>; Sun, 25 Dec 2011 11:00:36 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Jonathan Nieder <jrnieder@gmail.com>,
	"Igor M. Liplianin" <liplianin@me.by>
Subject: Re: Add support for new Terratec DVB USB IDs
Date: Fri, 23 Dec 2011 18:20:03 +0100
Cc: linux-media@vger.kernel.org, Eduard Bloch <blade@debian.org>
References: <20111222215356.GA4499@rotes76.wohnheim.uni-kl.de> <20111222234446.GB10497@elie.Belkin>
In-Reply-To: <20111222234446.GB10497@elie.Belkin>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112231820.03693.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, December 23, 2011 12:44:46 AM Jonathan Nieder wrote:
> Hi,
> 
> Eduard Bloch wrote[1]:
> > current revision of the Cinergy S2 USB box from Terratec seems to use
> > another USB-IDs. The manufacturer provides patches at
> > http://linux.terratec.de/tv_en.html and it seems like the only
> > difference is really just the new ID and a couple of init flag changes.
> > 
> > Their patch is not exactly for the linux-3.x tree but for the current
> > s2-liplianin drivers, OTOH they still look similar enough and porting
> > the patch was straight-forward. I also added the patch for Terratec S7
> > which is not tested yet but shouldn't do any harm.
> 
> [...]
> 
> Eduard, meet the LinuxTV project.  linux-media folks, meet Eduard.
> Patch follows.
> 
> Eduard: may we have your sign-off?  Please see
> Documentation/SubmittingPatches, section 12 "Sign your work" for what
> this means.
> 
> My only other hint is that it would be better to add the new device
> IDs in some logical place in the list near the older ones, instead of
> at the end where it is more likely to collide with other patches in
> flight.  So if rerolling the patches, it might be useful to do that.

Due to the use of the reference in the USB-id table adding the new set at 
the end of the list is actually the best way. Adding them in the middle will 
cause a lot of changes and bugs.

Except the Signed-off-by everything is fine to my eyes.

--
Patrick
