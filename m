Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38929 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbaIOOdH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 10:33:07 -0400
Message-ID: <5416F89D.9080006@collabora.com>
Date: Mon, 15 Sep 2014 10:33:01 -0400
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH/RFC v2 1/2] v4l: vb2: Don't return POLLERR during transient
 buffer underruns
References: <1401970991-4421-1-git-send-email-laurent.pinchart@ideasonboard.com> <5416CA2B.1080004@xs4all.nl> <20140915090224.5a2889a1.m.chehab@samsung.com> <11047185.EGVanoRbYV@avalon> <5416E208.5010302@collabora.com> <20140915105503.105233bf.m.chehab@samsung.com>
In-Reply-To: <20140915105503.105233bf.m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Le 2014-09-15 09:55, Mauro Carvalho Chehab a écrit :
> The DQBUF locking fixup was merged on libv4l2 for version 1.2. So, the
> potential breakage happens when libv4l2 is 1.2 and Gstreamer versions
> before 1.4.
>
> Do you have any procedure on gstreamer to fix a bug on stable releases?
A backport is possible, even though not trivial. Also, due to resources 
there is no guaranty of a new stable 1.2 release. For GStreamer 0.10, it 
is no longer maintained since 2 years already (mentioning since Laurent 
was using an old vendor specific version base on this). Though this 
situation isn't different from using a vendor specific kernel.
> Those VBI applications don't have any, as they're not actively
> maintained anymore. Even if we patch them today, I guess it could take
> a long time for those changes to be propagated on distros.
>
> So, I guess that the best is to try to fix Gstreamer on the distros
> that are using libv4l version 1.2 and a pre-1.4 Gstreamer version.
This seems an unlikely mix, as Gst 1.4 was released at around the same 
moment as libv4l2 1.2.

cheers,
Nicolas
