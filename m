Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:2238 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307AbZBZNQY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2009 08:16:24 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH]Add green balance v4l2 ctrl support
Date: Thu, 26 Feb 2009 14:20:24 +0100
Cc: Erik =?utf-8?q?Andr=C3=A9n?= <erik.andren@gmail.com>,
	linux-media@vger.kernel.org
References: <49874612.1000109@gmail.com> <20090226090447.52bef1a3@caramujo.chehab.org>
In-Reply-To: <20090226090447.52bef1a3@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902261420.25040.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Erik,

On Thursday 26 February 2009 13:04:47 Mauro Carvalho Chehab wrote:
> On Mon, 02 Feb 2009 20:14:26 +0100
>
> Erik Andrén <erik.andren@gmail.com> wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> >
> > Hi,
> >
> > The m5602 gspca driver has two sensors offering the possiblity to
> > control the green balance. This patch adds a v4l2 ctrl for this.

What's a "green balance" exactly ? The "red balance" and "blue balance" 
controls make up the two components of the white balance control (which can 
also be expressed in color temperature units). How does the "green balance" 
relate to those ?

Regards,

Laurent Pinchart

