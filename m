Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32949 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2HNWGP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 18:06:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: Patches submitted via linux-media ML that are at patchwork.linuxtv.org
Date: Wed, 15 Aug 2012 00:06:28 +0200
Message-ID: <23599424.KTEC3Hhc5D@avalon>
In-Reply-To: <502A7EC3.7030803@samsung.com>
References: <502A4CD1.1020108@redhat.com> <502A7EC3.7030803@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tuesday 14 August 2012 18:37:23 Sylwester Nawrocki wrote:
> On 08/14/2012 03:04 PM, Mauro Carvalho Chehab wrote:
> > This one requires more testing:
> > 
> > May,15 2012: [GIT,PULL,FOR,3.5] DMABUF importer feature in V4L2 API       
> >          http://patchwork.linuxtv.org/patch/11268  Sylwester Nawrocki
> > <s.nawrocki@samsung.com>
> Hmm, this is not valid any more. Tomasz just posted a new patch series
> that adds DMABUF importer and exporter feature altogether.
> 
> [PATCHv8 00/26] Integration of videobuf2 with DMABUF
> 
> I guess we need someone else to submit test patches for other H/W than just
> Samsung SoCs. I'm not sure if we've got enough resources to port this to
> other hardware. We have been using these features internally for some time
> already. It's been 2 kernel releases and I can see only Ack tags from
> Laurent on Tomasz's patch series, hence it seems there is no wide interest
> in DMABUF support in V4L2 and this patch series is probably going to stay in
> a fridge for another few kernel releases.

What would be required to push it to v3.7 ?

-- 
Regards,

Laurent Pinchart

