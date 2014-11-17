Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:37535 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaKQSUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 13:20:30 -0500
Received: by mail-la0-f49.google.com with SMTP id ge10so18920568lab.36
        for <linux-media@vger.kernel.org>; Mon, 17 Nov 2014 10:20:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <546A343F.401@collabora.com>
References: <CAOMZO5AX0R-s94-5m0G=SKkNb38u+jZo=7Toa+LDOkiJLAh=Tg@mail.gmail.com>
	<546A343F.401@collabora.com>
Date: Mon, 17 Nov 2014 16:20:27 -0200
Message-ID: <CAOMZO5Ca82Z3ry8vDF3Y=iSErqjGF58p0sR_78AS+pOTy2jeeQ@mail.gmail.com>
Subject: Re: Using the coda driver with Gstreamer
From: Fabio Estevam <festevam@gmail.com>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Jean-Michel Hautbois <jhautbois@gmail.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On Mon, Nov 17, 2014 at 3:45 PM, Nicolas Dufresne
<nicolas.dufresne@collabora.com> wrote:
> Note, I'm only commenting about the GStreamer side...
>
> Le 2014-11-17 12:29, Fabio Estevam a écrit :
>> Hi,
>>
>> I am running linux-next 20141117 on a mx6qsabresd board and trying to
>> play a mp4 video via Gstreamer 1.4.1, but I am getting the following
>> error:
> You should update to latest stable version, this is a general rule. Not
> keeping track of stable branches is never a good idea. Current stable is
> 1.4.4.

Ok, let me upgrade Gstreamer to 1.4.4.

>> ERROR Failed to connect to X display server for file:///mnt/nfs/sample.mp4
> You have built glimagesink (hence libgstgl, part of gst-plugins-bad)
> against X11 but you don't have a X11 display running, or DISPLAY
> environment isn't set properly.

Yes, let me fix this first.

Thanks,

Fabio Estevam
