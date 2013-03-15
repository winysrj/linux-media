Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:57611 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551Ab3CON4p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 09:56:45 -0400
Date: Fri, 15 Mar 2013 07:38:41 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andy Walls <awalls@md.metrocast.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Johnson <brijohn@gmail.com>,
	Mike Isely <isely@pobox.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Huang Shijie <shijie8@gmail.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Takashi Iwai <tiwai@suse.de>,
	Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 3/5] v4l2: pass std by value to the write-only
 s_std ioctl.
Message-ID: <20130315073841.509c3908@hpe.lwn.net>
In-Reply-To: <968af7abdc8503e5bb59869b2e9a3d9b2b453563.1363342714.git.hans.verkuil@cisco.com>
References: <1363343245-23531-1-git-send-email-hverkuil@xs4all.nl>
	<968af7abdc8503e5bb59869b2e9a3d9b2b453563.1363342714.git.hans.verkuil@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 15 Mar 2013 11:27:23 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
> index 92a33f0..76a8623 100644
> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
> @@ -1357,7 +1357,7 @@ static int mcam_vidioc_s_input(struct file *filp, void *priv, unsigned int i)
>  }
>  
>  /* from vivi.c */
> -static int mcam_vidioc_s_std(struct file *filp, void *priv, v4l2_std_id *a)
> +static int mcam_vidioc_s_std(struct file *filp, void *priv, v4l2_std_id a)
>  {
>  	return 0;
>  }

Hard to find much to complain about there :)

Acked-by: Jonathan Corbet <corbet@lwn.net>

(for the Via version too).

jon
