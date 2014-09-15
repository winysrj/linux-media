Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:54039 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaIONzK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 09:55:10 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBY00HER3ZX4D70@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 09:55:09 -0400 (EDT)
Date: Mon, 15 Sep 2014 10:55:03 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH/RFC v2 1/2] v4l: vb2: Don't return POLLERR during transient
 buffer underruns
Message-id: <20140915105503.105233bf.m.chehab@samsung.com>
In-reply-to: <5416E208.5010302@collabora.com>
References: <1401970991-4421-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <5416CA2B.1080004@xs4all.nl> <20140915090224.5a2889a1.m.chehab@samsung.com>
 <11047185.EGVanoRbYV@avalon> <5416E208.5010302@collabora.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 15 Sep 2014 08:56:40 -0400
Nicolas Dufresne <nicolas.dufresne@collabora.com> escreveu:

> 
> Le 2014-09-15 08:49, Laurent Pinchart a écrit :
> > Reverting the patch will also be a regression, as that would break
> > applications that now rely on the new behaviour (I've developed this patch to
> > fix a problem I've noticed with gstreamer). One way or another, we're screwed
> > and we'll break userspace.

Well, VB1 is working with the old behavior, as the breakage on saa7134
only happened after its migration to VB2. So, the Gstreamer version
you tested is still very likely broken with VB1.

So, I still think that the less damage is to revert the POLLERR patch,
with, according to Hans, is also a violation at the documented API.

> We have worked around this issue in GStreamer 1.4+,

Good to know.

> for older version, 
> the problem may be faced again by users, specially if using a newer 
> libv4l2 where the locking has been fixed (or no libv4l2).

The DQBUF locking fixup was merged on libv4l2 for version 1.2. So, the
potential breakage happens when libv4l2 is 1.2 and Gstreamer versions
before 1.4.

Do you have any procedure on gstreamer to fix a bug on stable releases?

Those VBI applications don't have any, as they're not actively
maintained anymore. Even if we patch them today, I guess it could take
a long time for those changes to be propagated on distros.

So, I guess that the best is to try to fix Gstreamer on the distros
that are using libv4l version 1.2 and a pre-1.4 Gstreamer version.

> 
> cheers,
> Nicolas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
