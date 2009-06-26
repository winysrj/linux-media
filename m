Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1732 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZFZSKc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 14:10:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "chaithrika" <chaithrika@ti.com>
Subject: Re: [PATCH] Subject: [PATCH v3 1/4] ARM: DaVinci: DM646x Video: Platform and board specific setup
Date: Fri, 26 Jun 2009 20:10:30 +0200
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	"'Manjunath Hadli'" <mrh@ti.com>,
	"'Brijesh Jadav'" <brijesh.j@ti.com>,
	"'Kevin Hilman'" <khilman@deeprootsystems.com>
References: <1241789157-23350-1-git-send-email-chaithrika@ti.com> <00cd01c9f311$77faf9a0$67f0ece0$@com>
In-Reply-To: <00cd01c9f311$77faf9a0$67f0ece0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906262010.31064.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 22 June 2009 10:14:30 chaithrika wrote:
> Kevin,
> 
> I think this patch has to be taken into DaVinci tree so that it
> can be submitted upstream. This patch has to be present in the Linux 
> tree for Hans to prepare a pull request for DM646x display driver 
> patches.

What are the plans for this patch? Will Kevin take care of this? In that
case the v4l patches will have to wait until this patch is in Linus' git
tree. Alternatively, we can pull this in via the v4l-dvb git tree. I think
that is propably the easiest approach.

I just need to know who will do what so we don't do duplicate work.

Regards,

	Hans

> 
> Regards,
> Chaithrika
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Chaithrika U S
> > Sent: Friday, May 08, 2009 6:56 PM
> > To: linux-media@vger.kernel.org
> > Cc: davinci-linux-open-source@linux.davincidsp.com; Chaithrika U S;
> > Manjunath Hadli; Brijesh Jadav
> > Subject: [PATCH] Subject: [PATCH v3 1/4] ARM: DaVinci: DM646x Video:
> > Platform and board specific setup
> > 
> > Platform specific display device setup for DM646x EVM
> > 
> > Add platform device and resource structures. Also define a platform
> > specific
> > clock setup function that can be accessed by the driver to configure
> > the clock
> > and CPLD.
> > 
> > This patch is dependent on a patch submitted earlier, which adds
> > Pin Mux and clock definitions for Video on DM646x.
> > 
> > Signed-off-by: Manjunath Hadli <mrh@ti.com>
> > Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> > Signed-off-by: Chaithrika U S <chaithrika@ti.com>
> > ---
> > Applies to Davinci GIT tree
> > 
> >  arch/arm/mach-davinci/board-dm646x-evm.c    |  122
> > +++++++++++++++++++++++++++
> >  arch/arm/mach-davinci/dm646x.c              |   63 ++++++++++++++
> >  arch/arm/mach-davinci/include/mach/dm646x.h |   25 ++++++
> >  3 files changed, 210 insertions(+), 0 deletions(-)
> > 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
