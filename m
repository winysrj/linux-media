Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48160 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558AbcFGNLm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2016 09:11:42 -0400
Date: Tue, 7 Jun 2016 10:11:33 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Rafael =?UTF-8?B?TG91cmVuw6dv?= de Lima Chehab
	<chehabrafael@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [PATCH 2/2] [media] media-device: dynamically allocate struct
 media_devnode
Message-ID: <20160607101133.5f13426c@recife.lan>
In-Reply-To: <57560388.7030903@osg.samsung.com>
References: <cover.1462633500.git.mchehab@osg.samsung.com>
	<83247b8a21c292a08949b3fe619cc56dc4709896.1462633500.git.mchehab@osg.samsung.com>
	<20160606084500.GW26360@valkosipuli.retiisi.org.uk>
	<57560388.7030903@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 6 Jun 2016 17:13:12 -0600
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> > A few general comments on the patch --- I agree we've had the problem from
> > the day one, but it's really started showing up recently. I agree with the
> > taken approach of separating the lifetimes of both media device and the
> > devnode. However, I don't think the patch as such is enough.

Do you or Laurent has an alternative patchset to fix those issues? From 
where I sit, we have a serious bug that it is already known for a while,
but nobody really tried to fix so far, except for Shuah and myself.

So, if you don't have any alternative patch ready to be merged, I'll
apply what we have later today, together with the patch that fixes cdev
livetime management:
	https://patchwork.linuxtv.org/patch/34201/

This will allow it to be tested to a broader audience and check if
the known issues will be fixed. I'll add a C/C stable, but my plan is
to not send it as a fix for 4.7. Instead, to keep the fixes on our tree
up to the next merge window, giving us ~5 weeks for testing.

As this is a Kernel only issue, it can be changed later if someone pops
up with a better approach.

Regards,
Mauro
