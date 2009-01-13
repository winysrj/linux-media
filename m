Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45325 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbZAMUeF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2009 15:34:05 -0500
Date: Tue, 13 Jan 2009 18:33:30 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>
Subject: Re: [REVIEW PATCH 01/14] V4L: Int if: Dummy slave
Message-ID: <20090113183330.066d75e4@pedra.chehab.org>
In-Reply-To: <A24693684029E5489D1D202277BE894416429F97@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE894416429F97@dlee02.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 12 Jan 2009 20:03:08 -0600
"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com> wrote:

>
> +static struct v4l2_int_slave dummy_slave = {
> +	/* Dummy pointer to avoid underflow in find_ioctl. */
> +	.ioctls = (void *)0x80000000,

Why are you using here a magic number?

> +	.num_ioctls = 0,
> +};

Cheers,
Mauro
