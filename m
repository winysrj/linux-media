Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:41130 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab2COLFs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 07:05:48 -0400
Date: Thu, 15 Mar 2012 13:03:36 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, k.debski@samsung.com
Subject: Re: [Q] media: V4L2 compressed frames and s_fmt.
Message-ID: <20120315110336.GH4220@valkosipuli.localdomain>
References: <CACKLOr3T-w1JdaGgnL+ZEXFX4v_oVd0HY8mqrm5ZzxEziH32jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKLOr3T-w1JdaGgnL+ZEXFX4v_oVd0HY8mqrm5ZzxEziH32jw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

(Cc Kamil.)

On Wed, Mar 14, 2012 at 12:22:43PM +0100, javier Martin wrote:
> Hi,
> I'm developing a V4L2 mem2mem driver for the codadx6 IP video codec
> which is included in the i.MX27 chip.
> 
> The capture interface of this driver can therefore return h.264 or
> mpeg4 video frames.
> 
> Provided that the size of each frame varies and is unknown to the
> user, how is the driver supposed to react to a S_FMT when it comes to
> parameters such as the following?
> 
> pix->width
> pix->height
> pix->bytesperline
> pix->sizeimage
> 
> According to the documentation [1] I understand that the driver can
> just ignore 'bytesperline' and should return in 'sizeimage' the
> maximum buffer size to store a compressed frame. However, it does not
> mention anything special about width and height. Does it make sense
> setting width and height for h.264/mpeg4 formats?

It does. This has been recently discussed, and there were a few ideas how to
do this. But no final conclusion AFAIR.

<URL:http://www.spinics.net/lists/linux-media/msg40905.html>

Kamil: do you have plans to update the RFC?

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
