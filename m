Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:56010 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZFZSZq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 14:25:46 -0400
Received: by ewy6 with SMTP id 6so3634131ewy.37
        for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 11:25:47 -0700 (PDT)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "chaithrika" <chaithrika@ti.com>, linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	"'Manjunath Hadli'" <mrh@ti.com>,
	"'Brijesh Jadav'" <brijesh.j@ti.com>
Subject: Re: [PATCH] Subject: [PATCH v3 1/4] ARM: DaVinci: DM646x Video: Platform and board specific setup
References: <1241789157-23350-1-git-send-email-chaithrika@ti.com>
	<00cd01c9f311$77faf9a0$67f0ece0$@com>
	<200906262010.31064.hverkuil@xs4all.nl>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Fri, 26 Jun 2009 11:25:42 -0700
In-Reply-To: <200906262010.31064.hverkuil@xs4all.nl> (Hans Verkuil's message of "Fri\, 26 Jun 2009 20\:10\:30 +0200")
Message-ID: <87ws6yetsp.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> On Monday 22 June 2009 10:14:30 chaithrika wrote:
>> Kevin,
>> 
>> I think this patch has to be taken into DaVinci tree so that it
>> can be submitted upstream. This patch has to be present in the Linux 
>> tree for Hans to prepare a pull request for DM646x display driver 
>> patches.
>
> What are the plans for this patch? Will Kevin take care of this? In that
> case the v4l patches will have to wait until this patch is in Linus' git
> tree. Alternatively, we can pull this in via the v4l-dvb git tree. I think
> that is propably the easiest approach.

Hans, I'm ok if you pull this directly into v4l-dvb git.   But first, I
there are a couple minor problems with this patch.  I'll reply
to the original post.

Also, please let me know the url and branch so I can be sure to handle
any problems with other davinci patces going upstream.

Is this tree part of linux-next?  I now have a 'for-next' branch
of DaVinci git which is included in linux-next so any potential
conflicts will be found there as well.

Thanks,

Kevin
