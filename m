Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.thls.bbc.co.uk ([132.185.240.36]:58677 "EHLO
	mailout1.thls.bbc.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab1HDNBO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 09:01:14 -0400
Message-ID: <4E3A980C.90903@rd.bbc.co.uk>
Date: Thu, 04 Aug 2011 14:01:00 +0100
From: David Waring <david.waring@rd.bbc.co.uk>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: DiBxxxx: fixes for 3.1/3.0
References: <alpine.LRH.2.00.1108031728090.30199@pub2.ifh.de>
In-Reply-To: <alpine.LRH.2.00.1108031728090.30199@pub2.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/08/11 16:33, Patrick Boettcher wrote:
> Hi Mauro,
> 
> Would you please pull from
> 
> git://linuxtv.org/pb/media_tree.git for_v3.0
> 
> for the following to changesets:
> 
> [media] dib0700: protect the dib0700 buffer access
> [media] DiBcom: protect the I2C bufer access
> 
These patches seem to fix the issue I was having with Hauppauge Nova-TD
USB sticks where only half the stick would work (random half each boot).
These may also fix tuning issues others were having with DiBcom based
cards/sticks. I've also noticed I'm no longer getting the "dib0700: tx
buffer length is larger than 4. Not
supported." errors in dmesg either.

I did have a bit of trouble compiling the patches, I had to modify the
dprintk(...) calls in the dib0700 patch to
dprintk(dvb_usb_dib0700_debug, 0x01, ...), although these should
probably be deb_info(...) calls.

Regards,
David

-- 
David Waring, Software Engineer, BBC Research & Development
5th Floor, Dock House, MediaCity:UK, Salford, M50 2LH, United Kingdom
Tel. +44(0)30 3040 9517
----------------------------------------------------------------------
This e-mail, and any attachment, is confidential. If you have received
it in error, please delete it from your system, do not use or disclose
the information in any way, and notify me immediately. The contents of
this message may contain personal views which are not the views of the
BBC, unless specifically stated.
