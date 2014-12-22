Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:47037 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbaLVQGb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 11:06:31 -0500
Message-ID: <54984181.2030306@collabora.com>
Date: Mon, 22 Dec 2014 11:06:25 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: Philipp Zabel <pza@pengutronix.de>,
	=?windows-1252?Q?Fr=E9d=E9ric_S?= =?windows-1252?Q?ureau?=
	<frederic.sureau@vodalys.com>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Fabio Estevam <festevam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>, k.debski@samsung.com
Subject: Re: coda: Unable to use encoder video_bitrate
References: <54930468.6010007@vodalys.com> <1418921549.4212.57.camel@pengutronix.de> <549837A4.2060605@vodalys.com> <20141222160224.GC32333@pengutronix.de>
In-Reply-To: <20141222160224.GC32333@pengutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Le 2014-12-22 11:02, Philipp Zabel a écrit :
> That is a good point, rate control can only work if the encoder has
> an idea about the framerate. I've sent a patch that allows to use
> VIDIOC_S_PARM to set it:
> "[media] coda: Use S_PARM to set nominal framerate for h.264 encoder"
Thanks, I'll sort out what is needed on Gst side. Kamil, do MFC need to 
be looked at too ?

Nicolas
