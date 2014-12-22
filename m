Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49684 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbaLVQC1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 11:02:27 -0500
Date: Mon, 22 Dec 2014 17:02:24 +0100
From: Philipp Zabel <pza@pengutronix.de>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Sureau <frederic.sureau@vodalys.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Fabio Estevam <festevam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: coda: Unable to use encoder video_bitrate
Message-ID: <20141222160224.GC32333@pengutronix.de>
References: <54930468.6010007@vodalys.com>
 <1418921549.4212.57.camel@pengutronix.de>
 <549837A4.2060605@vodalys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <549837A4.2060605@vodalys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frédéric,

On Mon, Dec 22, 2014 at 04:24:20PM +0100, Frédéric Sureau wrote:
> Thanks for the patch!
> It works fine now after forcing framerate to 30fps (which seems to
> be hardcoded in the driver)

That is a good point, rate control can only work if the encoder has
an idea about the framerate. I've sent a patch that allows to use
VIDIOC_S_PARM to set it:
"[media] coda: Use S_PARM to set nominal framerate for h.264 encoder"

regards
Philipp
