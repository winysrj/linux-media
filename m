Return-path: <linux-media-owner@vger.kernel.org>
Received: from old.radier.ca ([76.10.149.124]:59993 "EHLO server.radier.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757846Ab2AEXQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 18:16:18 -0500
Received: from localhost (unknown [127.0.0.1])
	by server.radier.ca (Postfix) with ESMTP id 8CC459ECE88
	for <linux-media@vger.kernel.org>; Thu,  5 Jan 2012 18:16:15 -0500 (EST)
Received: from server.radier.ca ([127.0.0.1])
	by localhost (server.radier.ca [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XYCeF1DbThmm for <linux-media@vger.kernel.org>;
	Thu,  5 Jan 2012 18:16:14 -0500 (EST)
Received: from tag-00481.capella.ca (unknown [206.47.153.50])
	by server.radier.ca (Postfix) with ESMTPSA id 06C2A9ECE79
	for <linux-media@vger.kernel.org>; Thu,  5 Jan 2012 18:16:13 -0500 (EST)
From: Dmitriy Fitisov <dmitriy@radier.ca>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: em2874 bulk endpoint support
Date: Thu, 5 Jan 2012 18:16:12 -0500
Message-Id: <A66B7710-DC6D-4A88-AF1C-2853C39617ED@radier.ca>
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1251.1)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,
I know, Devin Heitmueller was about to add support  for em2874 bulk endpoint.

Is that still in plans?

Thank you.
Dmitriy 

Copying old thread:
> On Oct 29, 2010, at 2:37 PM, Devin Heitmueller wrote:
>
> > On Fri, Oct 29, 2010 at 2:04 PM, Jarod Wilson <jarod at wilsonet.com
> wrote:
> >> On Oct 15, 2010, at 6:07 PM, Jarod Wilson wrote:...
> >> So a spot of bad news here... I've been poking at one of Gavin's sticks inside a VM he set up for me, simultaneous with talking to one of the upstream em28xx driver authors. We now have a very good understanding of why the stick isn't working.
> >> 
> >> All known prior em28xx-based tuner sticks have had at least one isochronous usb endpoint, with a max packet size of 940 bytes, typically. This stick only has bulk usb endpoints and a max packet size of 512. Supporting this stick is actually going to require a fair bit of work in the em28xx driver core to support using bulk transfer instead of isochronous transfer.
> >> 
> >> Short version: don't buy this stick right now, its going to be a little while before its actually supported.
> > 
> > Jarod,
> > 
> > Just an FYI:  bulk support for em2874/em2884 is on my todo list for
> > the near future.
>
>
 Ah, very cool. I'm inclined to wait and let you do that part, since you know em28xx much better than I do, and I'll just focus on the device-specific implementation details (gpio settings, wiring up tuner and demod, etc). I'm assuming you have some other manufacturer's em2874/em2884 based devices to work on this for... :)


