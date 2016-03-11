Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:36566 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbcCKNXj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 08:23:39 -0500
Received: by mail-qk0-f170.google.com with SMTP id s68so47378594qkh.3
        for <linux-media@vger.kernel.org>; Fri, 11 Mar 2016 05:23:38 -0800 (PST)
Date: Fri, 11 Mar 2016 15:23:34 +0200
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	devel@driverdev.osuosl.org,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Andrey Utkin <andrey_utkin@fastmail.com>
Subject: Re: [RFC PATCH v0] Add tw5864 driver
Message-ID: <20160311152334.1c053054@zver>
In-Reply-To: <56E296E6.8000709@xs4all.nl>
References: <1451785302-3173-1-git-send-email-andrey.utkin@corp.bluecherry.net>
	<56938969.30104@xs4all.nl>
	<CAM_ZknVgTETBNXu+8N6eJa=cf_Mmj=+tA=ocKB9SJL5rkSyijQ@mail.gmail.com>
	<56B866D9.5070606@xs4all.nl>
	<20160309162924.6e6ebddf@zver>
	<56E27B12.1000803@xs4all.nl>
	<20160311104003.1cad89f3@zver>
	<56E296E6.8000709@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 11 Mar 2016 10:59:02 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:
> While userspace may specify FIELD_ANY when setting a format, the
> driver should always map that to a specific field setting and should
> never return FIELD_ANY back to userspace.
> 
> In this case, the 'field' field of the v4l2_buffer struct has
> FIELD_ANY which means it is not set correctly (or at all) in the
> driver.
> 
> It's a common mistake, which is why v4l2-compliance tests for it :-)

Thanks for great guidance Hans, finally I have solved all issues.

You can review latest state at tw5864 branch, also you can review
changelog of v4l2-compliance fixing at tags tw5864_pre_1.11,
tw5864_pre_1.10 of https://github.com/bluecherrydvr/linux .

I will make a final internal review before submission, and try
to submit the driver for inclusion.

Everybody is appreciated to make any comments even before submission,
the actual code to review is at tw5864 branch.
