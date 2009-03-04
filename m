Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:51915 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbZCDWYv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 17:24:51 -0500
Date: Wed, 4 Mar 2009 14:24:50 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: "Erik S. Beiser" <erikb@bu.edu>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] cx88: Add IR support to pcHDTV HD3000 & HD5500
In-Reply-To: <49A9E4F0.1030005@bu.edu>
Message-ID: <Pine.LNX.4.58.0903041330510.24268@shell2.speakeasy.net>
References: <49A9E4F0.1030005@bu.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 28 Feb 2009, Erik S. Beiser wrote:

> cx88: Add IR support to pcHDTV HD3000 & HD5500
>
> Signed-off-by: Erik S. Beiser <erikb@bu.edu>
>
> ---
>
> Idea originally from http://www.pchdtv.com/forum/viewtopic.php?t=1529
> I made it into this small patch and added the HD3000 support also, which I have  I've actually
> been using this for over a year, updating for new kernel versions.  I'm tired of doing so,
> and would like to try and have it merged upstream -- I hope I got all the patch-mechanics
> correct.  I just updated and tested it today on 2.6.28.7 vanilla.  Thanks.

You forgot a patch description.

Since neither the HD-3000 or HD-5500 came with a remote, and at least my
HD-3000 didn't even come with an IR receiver.  So I have to ask why
configuring the driver to work a remote you happened to have is any more
correct than configuring it to work a remote someone else happens to have?

This patch also causes these cards to generate 101 interrupts per second
per card, even when not in use.  That seems pretty costly for a card that
doesn't even come with an ir sensor.
