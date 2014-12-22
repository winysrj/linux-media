Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46975 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbaLVP2h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 10:28:37 -0500
Message-ID: <5498389E.606@collabora.com>
Date: Mon, 22 Dec 2014 10:28:30 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: =?UTF-8?B?RnLDqWTDqXJpYyBTdXJlYXU=?= <frederic.sureau@vodalys.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
CC: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Fabio Estevam <festevam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: coda: Unable to use encoder video_bitrate
References: <54930468.6010007@vodalys.com> <1418921549.4212.57.camel@pengutronix.de> <549837A4.2060605@vodalys.com>
In-Reply-To: <549837A4.2060605@vodalys.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Le 2014-12-22 10:24, Frédéric Sureau a écrit :
> Thanks for the patch!
> It works fine now after forcing framerate to 30fps (which seems to be 
> hardcoded in the driver) 

Can you comment about this on gnome bug. Would make sense for the 
encoder element in GStreamer to relay the framerate to the driver, so 
the driver can make any sense out of the bitrate.

https://bugzilla.gnome.org/show_bug.cgi?id=728438

Nicolas
