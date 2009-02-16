Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:40147 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbZBPLc5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 06:32:57 -0500
Date: Mon, 16 Feb 2009 12:12:58 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: "Hans de Goede" <hdegoede@redhat.com>,
	"Trent Piepho" <xyzzy@speakeasy.org>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	kilgota@banach.math.auburn.edu,
	"Adam Baker" <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	"Olivier Lorin" <o.lorin@laposte.net>
Subject: Re: Adding a control for Sensor Orientation
Message-ID: <20090216121258.3645bf4f@free.fr>
In-Reply-To: <44220.62.70.2.252.1234782074.squirrel@webmail.xs4all.nl>
References: <44220.62.70.2.252.1234782074.squirrel@webmail.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Feb 2009 12:01:14 +0100 (CET)
"Hans Verkuil" <hverkuil@xs4all.nl> wrote:

> Anyone can add an API in 5 seconds. It's modifying or removing a bad
> API that worries me as that can take years. If you want to add two
> bits with mount information, feel free. But don't abuse them for
> pivot information. If you want that, then add another two bits for
> the rotation:
> 
> #define V4L2_BUF_FLAG_VFLIP     0x0400
> #define V4L2_BUF_FLAG_HFLIP     0x0800
> 
> #define V4L2_BUF_FLAG_PIVOT_0   0x0000
> #define V4L2_BUF_FLAG_PIVOT_90  0x1000
> #define V4L2_BUF_FLAG_PIVOT_180 0x2000
> #define V4L2_BUF_FLAG_PIVOT_270 0x3000
> #define V4L2_BUF_FLAG_PIVOT_MSK 0x3000

Hi,

HFLIP + VFLIP = PIVOT_180

then

#define V4L2_BUF_FLAG_PIVOT_180 0x0c00

Cheers.

-- 
Ken ar c'hentan	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
