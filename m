Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:31843 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbaIOPv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 11:51:57 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBY00GGG9EKNQ50@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 11:51:56 -0400 (EDT)
Date: Mon, 15 Sep 2014 12:51:50 -0300
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
Message-id: <20140915125150.36fc6074.m.chehab@samsung.com>
In-reply-to: <5416F89D.9080006@collabora.com>
References: <1401970991-4421-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <5416CA2B.1080004@xs4all.nl> <20140915090224.5a2889a1.m.chehab@samsung.com>
 <11047185.EGVanoRbYV@avalon> <5416E208.5010302@collabora.com>
 <20140915105503.105233bf.m.chehab@samsung.com> <5416F89D.9080006@collabora.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 15 Sep 2014 10:33:01 -0400
Nicolas Dufresne <nicolas.dufresne@collabora.com> escreveu:

> 
> Le 2014-09-15 09:55, Mauro Carvalho Chehab a écrit :
> > The DQBUF locking fixup was merged on libv4l2 for version 1.2. So, the
> > potential breakage happens when libv4l2 is 1.2 and Gstreamer versions
> > before 1.4.
> >
> > Do you have any procedure on gstreamer to fix a bug on stable releases?
> A backport is possible, even though not trivial. Also, due to resources 
> there is no guaranty of a new stable 1.2 release. 

Well, if someone pops up with a problem with Gst 1.2 + libv4l 1.2
(with seems unlikely, as you pointed below), then we can provide them
some directions to either:
	1) revert the libv4l2 DQBUF patch;
	2) upgrade to gst 1.4;
	3) don't revert the POLLERR patch, if VBI is not needed on such
specific scenario.

> For GStreamer 0.10, it 
> is no longer maintained since 2 years already (mentioning since Laurent 
> was using an old vendor specific version base on this). Though this 
> situation isn't different from using a vendor specific kernel.

Well, we can't do much with vendor-specific versions, especially
when they rely on too old Kernels and/or too old Gstreamer versions.

Anyway, I guess that the POLLERR patch were not backported to -stable.
So, vendor-specific versions with old stacks won't be affected, as
the POLLERR fixup was added on Kernel 3.16.

I suspect that there aren't many places where a vendor distro
using Gst 0.10 has Kernel 3.16.

> > Those VBI applications don't have any, as they're not actively
> > maintained anymore. Even if we patch them today, I guess it could take
> > a long time for those changes to be propagated on distros.
> >
> > So, I guess that the best is to try to fix Gstreamer on the distros
> > that are using libv4l version 1.2 and a pre-1.4 Gstreamer version.
> This seems an unlikely mix, as Gst 1.4 was released at around the same 
> moment as libv4l2 1.2.

Yes, I agree.

Regards,
Mauro
