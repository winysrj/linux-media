Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4184 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbZFZSm1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 14:42:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH] Subject: [PATCH v3 1/4] ARM: DaVinci: DM646x Video: Platform and board specific setup
Date: Fri, 26 Jun 2009 20:42:25 +0200
Cc: "chaithrika" <chaithrika@ti.com>, linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	"'Manjunath Hadli'" <mrh@ti.com>,
	"'Brijesh Jadav'" <brijesh.j@ti.com>
References: <1241789157-23350-1-git-send-email-chaithrika@ti.com> <200906262010.31064.hverkuil@xs4all.nl> <87ws6yetsp.fsf@deeprootsystems.com>
In-Reply-To: <87ws6yetsp.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906262042.25802.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 26 June 2009 20:25:42 Kevin Hilman wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
> 
> > On Monday 22 June 2009 10:14:30 chaithrika wrote:
> >> Kevin,
> >> 
> >> I think this patch has to be taken into DaVinci tree so that it
> >> can be submitted upstream. This patch has to be present in the Linux 
> >> tree for Hans to prepare a pull request for DM646x display driver 
> >> patches.
> >
> > What are the plans for this patch? Will Kevin take care of this? In that
> > case the v4l patches will have to wait until this patch is in Linus' git
> > tree. Alternatively, we can pull this in via the v4l-dvb git tree. I think
> > that is propably the easiest approach.
> 
> Hans, I'm ok if you pull this directly into v4l-dvb git.   But first, I
> there are a couple minor problems with this patch.  I'll reply
> to the original post.

OK. I'll wait for the fixed patch and I'll then ask Mauro to merge this
platform patch and the vpif display driver into the v4l-dvb git tree.

> Also, please let me know the url and branch so I can be sure to handle
> any problems with other davinci patces going upstream.

git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git#master

> Is this tree part of linux-next?

Yes.

> I now have a 'for-next' branch 
> of DaVinci git which is included in linux-next so any potential
> conflicts will be found there as well.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
