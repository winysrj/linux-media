Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:57082 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaG0Qx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 12:53:59 -0400
cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Mauro Carvalho Chehab" <m.chehab@samsung.com>,
	"Kamil Debski" <k.debski@samsung.com>,
	"Nicolas Dufresne" <nicolas.dufresne@collabora.com>,
	"Sascha Hauer" <kernel@pengutronix.de>,
	"Hans Verkuil" <hverkuil@xs4all.nl>
MIME-Version: 1.0
from: "Nicolas Dufresne" <nicolas.dufresne@collabora.co.uk>
subject: =?utf-8?q?Re:_[PATCH_2/3]_[media]_coda:_fix_coda=5Fg=5Fselection?=
message-id: <69ab-53d52e80-1-565f8200@126846484>
to: "Philipp Zabel" <philipp.zabel@gmail.com>
content-type: text/plain; charset="utf-8"
date: Sun, 27 Jul 2014 17:53:57 +0100
in-reply-to: <CA+gwMcd2hETKbkqM5yeJiVDzadHyQX=qgPTqobFXTN4JQ-+vdA@mail.gmail.com>
content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 
Le Samedi 26 Juillet 2014 12:37 EDT, Philipp Zabel <philipp.zabel@gmail.com> a écrit: 

> I have tried the GStreamer v4l2videodec element with the coda driver and
> noticed that GStreamer calls VIDIOC_CROPCAP to obtain the pixel aspect
> ratio. This always fails with -EINVAL because of this issue. Currently GStreamer
> throws a warning if the return value is an error other than -ENOTTY.


But for now, this seems like a fair thing to do. We currently assume that if your
driver is not implementing CROPCAP, then pixel aspect ratio at output will be
unchanged at capture. If there is an error though, it's not good sign, and we report
it. If that is wrong, let us know why and how to detect your driver error isn't a an error.

cheers,
Nicolas 
 
 
 

