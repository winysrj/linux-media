Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab3CXPfN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 11:35:13 -0400
Date: Sun, 24 Mar 2013 12:35:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 16/42] go7007: switch to standard tuner/i2c
 subdevs.
Message-ID: <20130324123506.7d8eb627@redhat.com>
In-Reply-To: <a5f72624c6412dc0a7e4ef04f5e49316cae53a15.1363000605.git.hans.verkuil@cisco.com>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
	<a5f72624c6412dc0a7e4ef04f5e49316cae53a15.1363000605.git.hans.verkuil@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 11 Mar 2013 12:45:54 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Instead of using the wis-* drivers we now use the standard 'proper' subdev
> drivers.
> 
> The board configuration tables now also list the possible audio inputs,
> this will be used later to implement audio inputs.
> 
> Special mention deserves a little change in set_capture_size() where the
> height passed to s_mbus_fmt is doubled: that is because the saa7115 driver
> expects to see the frame height, not the field height as the wis_saa7115
> driver did.
> 
> Another change is that the tuner input is moved from last to the first
> input, which is consistent with the common practice in other video drivers.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/staging/media/go7007/Kconfig          |   77 ++---------------
>  drivers/staging/media/go7007/Makefile         |   12 ---
>  drivers/staging/media/go7007/go7007-driver.c  |   29 +++++--
>  drivers/staging/media/go7007/go7007-i2c.c     |    1 -
>  drivers/staging/media/go7007/go7007-priv.h    |   18 +++-
>  drivers/staging/media/go7007/go7007-usb.c     |  112 +++++++++++++++++--------
>  drivers/staging/media/go7007/go7007-v4l2.c    |   18 +++-
>  drivers/staging/media/go7007/saa7134-go7007.c |    2 +-
>  8 files changed, 135 insertions(+), 134 deletions(-)

That produced the following warnings:

drivers/media/i2c/sony-btf-mpx.c:335:2: warning: initialization from incompatible pointer type [enabled by default]
drivers/media/i2c/sony-btf-mpx.c:335:2: warning: (near initialization for 'sony_btf_mpx_tuner_ops.s_tuner') [enabled by default]

Cheers,
Mauro
