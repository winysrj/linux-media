Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3588 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759657Ab2EQIux (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 04:50:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Proposal to deprecate four drivers
Date: Thu, 17 May 2012 10:50:46 +0200
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1337022719-13868-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1337022719-13868-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205171050.46082.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon May 14 2012 21:11:57 Hans Verkuil wrote:
> Hi all,
> 
> These two patches deprecate the ISA video capture pms driver and the three
> parallel port webcam drivers bw-qcam, c-qcam and w9966.
> 
> Nobody has hardware for the three parallel port webcams anymore (and we really
> tried to get hold of some), and my ISA pms board also no longer works (I suspect
> the Pentium motherboard I use for testing ISA cards is too fast :-) ).
> 
> I've given up on these drivers. I've posted a pull request to get these drivers
> up to speed with regards to the latest frameworks (the pms update has already
> been merged), and I think that should be the last change before removing them
> altogether. If someone ever gets working hardware for these drivers, then they
> are easy to resurrect from the git history should there be a desire to do so.
> 
> ISA and parallel port are both unsuitable for streaming video, so this hardware
> is really obsolete.

I'm shelving this RFC for the time being. I suddenly have leads on all three
parallel port webcams so with a bit of luck I might have actual hardware to
test these drivers in a few weeks time.

It's still not useful to anyone of course, but as long as I can test ancient
hardware I'm happy :-)

Regards,

	Hans
