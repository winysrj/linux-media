Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38840 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaIOM4p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 08:56:45 -0400
Message-ID: <5416E208.5010302@collabora.com>
Date: Mon, 15 Sep 2014 08:56:40 -0400
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH/RFC v2 1/2] v4l: vb2: Don't return POLLERR during transient
 buffer underruns
References: <1401970991-4421-1-git-send-email-laurent.pinchart@ideasonboard.com> <5416CA2B.1080004@xs4all.nl> <20140915090224.5a2889a1.m.chehab@samsung.com> <11047185.EGVanoRbYV@avalon>
In-Reply-To: <11047185.EGVanoRbYV@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Le 2014-09-15 08:49, Laurent Pinchart a écrit :
> Reverting the patch will also be a regression, as that would break
> applications that now rely on the new behaviour (I've developed this patch to
> fix a problem I've noticed with gstreamer). One way or another, we're screwed
> and we'll break userspace.

We have worked around this issue in GStreamer 1.4+, for older version, 
the problem may be faced again by users, specially if using a newer 
libv4l2 where the locking has been fixed (or no libv4l2).

cheers,
Nicolas
