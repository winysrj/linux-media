Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:45357 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaKQRsq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 12:48:46 -0500
Received: by mail-vc0-f177.google.com with SMTP id ij19so6121177vcb.22
        for <linux-media@vger.kernel.org>; Mon, 17 Nov 2014 09:48:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOMZO5AX0R-s94-5m0G=SKkNb38u+jZo=7Toa+LDOkiJLAh=Tg@mail.gmail.com>
References: <CAOMZO5AX0R-s94-5m0G=SKkNb38u+jZo=7Toa+LDOkiJLAh=Tg@mail.gmail.com>
Date: Mon, 17 Nov 2014 21:48:45 +0400
Message-ID: <CAM_ZknVe-ciJBeTLy5FFuGyue=s=wdVJLLdWEzEGQjoFfOffTA@mail.gmail.com>
Subject: Re: Using the coda driver with Gstreamer
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Fabio Estevam <festevam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Jean-Michel Hautbois <jhautbois@gmail.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

could you give `lspci -v` so that i see what module is a driver for
that component?

Try playing to same device with recent ffmpeg: ffmpeg -i sample.mp4
-codec copy -f v4l2 -y /dev/videoWhatYouHave
and check if you have the same kernel warning.

-- 
Bluecherry developer.
