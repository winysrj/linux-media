Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44913 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753171AbcHCT2a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Aug 2016 15:28:30 -0400
Date: Wed, 3 Aug 2016 22:28:19 +0300
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Marty Plummer <netz.kernel@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: TW2866 i2c driver and solo6x10
Message-ID: <20160803192819.GB24606@zver>
References: <d5269058-c953-5b3e-7b19-0b4c6474714c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5269058-c953-5b3e-7b19-0b4c6474714c@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 27, 2016 at 11:51:22PM -0500, Marty Plummer wrote:
> I have one of those rebranded chinese security dvrs, the ones with all the gaping
> security holes. I'd like to fix that up and setup a good rtsp server on it, but
> first comes low-level stuff, drivers and such. I've been squinting at the pcb and
> ID'ing chips for a bit now, and I've figured most of them out. Looks like the actual
> video processing is done on 4 tw2866 chips, though the kernel module has symbols
> referring to tw2865. I've seen another driver in the kernel tree, the bluecherry
> solo6x10, but that's on the pci bus. as far as I can figure, the dvr uses i2c for
> them. So, what I'm wondering is would it be feasible to factor out some of the solo
> functionality into a generic tw2865 driver and be able to pull from that for an i2c
> kernel module? I'd really hate to have to rewrite the whole thing, duplicated code
> and overworking are generally a bad idea, even if I do have a datasheet for the chip
> in question


Hi Matt,

Bluecherry LLC software developer here (barely knowing about tw28xx stuff).

If I was you, I'd restrain from such project unless I had a bulk of such
hardware, not just single unit. This is because things are hard to get
right without tinkering step by step. Also somebody would still need to
do fair amount of coding. And unless you are already qualified to do it
alone, you'd need many cycles of asking questions and providing lots of
details of your actual system. If you are interested in merging your
results upstream, then there's even more efforts to put.
As a developer affiliated with Bluecherry LLC, I will do my best to help
you, but I am mere mortal with all sorts of constraints - knowledge,
time, etc. But I or Bluecherry won't just make everything for you, even
if you send us a sample of hardware (which would be a good start for a
volunteer willing to take that challenge).
So feel free to post here your specific questions if you go for it.
