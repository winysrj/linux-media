Return-path: <linux-media-owner@vger.kernel.org>
Received: from ist.d-labs.de ([213.239.218.44]:60363 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab1HDNCl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2011 09:02:41 -0400
Date: Thu, 4 Aug 2011 15:02:34 +0200
From: Florian Mickler <florian@mickler.org>
To: David Waring <david.waring@rd.bbc.co.uk>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Subject: Re: Problems with Hauppauge Nova-TD (dib0070/dib7000PC)
Message-ID: <20110804150234.1066f065@schatten.dmk.lab>
In-Reply-To: <4E1ADD30.6090502@rd.bbc.co.uk>
References: <4E1ADD30.6090502@rd.bbc.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 11 Jul 2011 12:23:28 +0100
David Waring <david.waring@rd.bbc.co.uk> wrote:

> I'm currently using 3 of these USB sticks on a PC with the videolan.org
> dvblast program to multicast the UK Freeview DVB-T muxes on our local
> network. I'm also using a PCTV nanostick 290e to multicast the DVB-T2
> mux too.
> 
> I'm having a problem with the Nova-TD sticks (52009) using recent builds
> from the media_build git repository (to get the 290e drivers) on Debian
> squeeze using 2.6.38-bpo.2-686. The problem is that only one half of
> each Nova-TD stick will tune and give data. Which half seems to be
> random and changes with each reboot. Occasionally I'll get a whole stick
> working or one of the sticks will not work at all. If I try to use a
> non-working half of a stick it will knock out the working half until I
> stop using trying to use the non-working half. So I'm seeing
> interference of one logical dvb adapter from another that are both on
> the same physical hardware.
> 
> Also after a few days the sticks stop working completely and need to be
> powered down before they work again, but this may be a different issue.
> 
> I'm getting a few "dib0700: tx buffer length is larger than 4. Not
> supported." in dmesg during first tune. Maybe coincidence, but I've
> noticed that on the last reboot 4 tuners (out of the 6 total Nova-TD
> tuners) are not working and I have 4 of the above message in dmesg, so
> there could be a link.
> 
> I've tried turning on the debugging for both the dvb_usb_dib0700 and
> dvb_usb modules but there was no indication of the problem.
> 
> Any suggestions for what I could try next to find the cause and fix this?
> 
> David

Hi,
maybe the fixes Patrick posted[1] fix your issue ?

http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/36393

Regards,
Flo


