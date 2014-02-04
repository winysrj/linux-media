Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45627 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaBDNXY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Feb 2014 08:23:24 -0500
Date: Tue, 4 Feb 2014 13:22:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rob Landley <rob@landley.net>,
	LKML <linux-kernel@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH 34/52] devices.txt: add video4linux device for Software
 Defined Radio
Message-ID: <20140204132256.7e829f9a@www.etchedpixels.co.uk>
In-Reply-To: <20140204111903.5c2e928e@samsung.com>
References: <20140204111903.5c2e928e@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 04 Feb 2014 11:19:03 -0200
Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:

> Alan/Greg/Andrew/Rob,
> 
> Not sure who is currently maintaining Documentation/devices.txt.
> 
> We're needing to add support of a new type of V4L2 devices there.
> 
> Could you please ack with the following patch? If this one is ok, I intend
> to send via my tree together with the patch series that implements support
> for it, if you agree.
> 
> Thank you!
> Mauro
> 
> Forwarded message:
> 
> Date: Sat, 25 Jan 2014 19:10:28 +0200
> From: Antti Palosaari <crope@iki.fi>
> To: linux-media@vger.kernel.org
> Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
> Subject: [PATCH 34/52] devices.txt: add video4linux device for Software Defined Radio
> 
> 
> Add new video4linux device named /dev/swradio for Software Defined
> Radio use. V4L device minor numbers are allocated dynamically
> nowadays, but there is still configuration option for old fixed style.
> Add note to mention that configuration option too.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Alan Cox <alan@linux.intel.com>
