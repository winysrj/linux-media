Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:42091 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbbC1Qza (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2015 12:55:30 -0400
Message-ID: <5516DCF7.20203@xs4all.nl>
Date: Sat, 28 Mar 2015 09:55:19 -0700
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PULL] hvr2205 / hvr2255 support and misc patches
References: <CALzAhNU0JfCoeX4f+MOXO4A-V1BmOz3bBZfEhtiujtsejtvdSQ@mail.gmail.com>
In-Reply-To: <CALzAhNU0JfCoeX4f+MOXO4A-V1BmOz3bBZfEhtiujtsejtvdSQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/28/2015 08:51 AM, Steven Toth wrote:
> Mauro,
> 
> Please disregard my prior pull request for this patchset.
> 
> As requested, this is a second pull request including the ATSC
> inversion fix mentioned earlier.

Why didn't you incorporate my querycap patch in this pull request?
The querycap patch here still has the same problem I've addressed with
my patch.

I've changed the state of this pull request to 'Changes Requested' since
it makes no sense to take in this pull request where one patch has known
problems.

Regards,

	Hans

> 
> Thx
> 
> - Steve
> 
> The following changes since commit 4708e452aa3109fc23e0c6b5a658ccc1b720dfa6:
> 
>   [media] saa7164: I2C improvements for upcoming HVR2255/2205 boards
> (2015-03-23 14:37:32 -0400)
> 
> are available in the git repository at:
> 
>   git://git.linuxtv.org/stoth/media_tree.git saa7164-dev
> 
> for you to fetch changes up to c77cfc0fb29c278cf45e9c226bac39434098ca07:
> 
>   [media] saa7164: fix HVR2255 ATSC inversion issue (2015-03-28 08:07:47 -0400)
> 
> ----------------------------------------------------------------
> Steven Toth (6):
>       [media] saa7164: Adding additional I2C debug.
>       [media] saa7164: Improvements for I2C handling
>       [media] saa7164: Add Digital TV support for the HVR2255 and HVR2205
>       [media] saa7164: Fixup recent querycap warnings
>       [media] saa7164: Copyright update
>       [media] saa7164: fix HVR2255 ATSC inversion issue
> 
>  drivers/media/pci/saa7164/saa7164-api.c     |  21 ++-
>  drivers/media/pci/saa7164/saa7164-buffer.c  |   2 +-
>  drivers/media/pci/saa7164/saa7164-bus.c     |   2 +-
>  drivers/media/pci/saa7164/saa7164-cards.c   | 188 ++++++++++++++++++++++++++-
>  drivers/media/pci/saa7164/saa7164-cmd.c     |   2 +-
>  drivers/media/pci/saa7164/saa7164-core.c    |   2 +-
>  drivers/media/pci/saa7164/saa7164-dvb.c     | 232
> +++++++++++++++++++++++++++++++---
>  drivers/media/pci/saa7164/saa7164-encoder.c |   5 +-
>  drivers/media/pci/saa7164/saa7164-fw.c      |   2 +-
>  drivers/media/pci/saa7164/saa7164-i2c.c     |   2 +-
>  drivers/media/pci/saa7164/saa7164-reg.h     |   2 +-
>  drivers/media/pci/saa7164/saa7164-types.h   |   2 +-
>  drivers/media/pci/saa7164/saa7164-vbi.c     |   5 +-
>  drivers/media/pci/saa7164/saa7164.h         |   7 +-
>  14 files changed, 440 insertions(+), 34 deletions(-)
> 

