Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:35937 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933165AbZHECb3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 22:31:29 -0400
MIME-Version: 1.0
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401451814F8@dlee06.ent.ti.com>
References: <200908040912.24718.hverkuil@xs4all.nl>
	 <19F8576C6E063C45BE387C64729E73940432AF3A5D@dbde02.ent.ti.com>
	 <A69FA2915331DC488A831521EAE36FE401451814F8@dlee06.ent.ti.com>
Date: Wed, 5 Aug 2009 11:31:29 +0900
Message-ID: <aec7e5c30908041931m2113cecerec2c732f8b5927ea@mail.gmail.com>
Subject: Re: Linux Plumbers Conference 2009: V4L2 API discussions
From: Magnus Damm <magnus.damm@gmail.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"eduardo.valentin@nokia.com" <eduardo.valentin@nokia.com>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 5, 2009 at 5:14 AM, Karicheri,
Muralidharan<m-karicheri2@ti.com> wrote:
> 2) Previewer & Resizer driver. I am working with Vaibhav who had worked on an RFC for this. The previewer and resizer devices are doing memory to memory operations. Also should be flexible to use these hardware with capture driver to do on the fly preview and resize. The TI hardware is parameter intensive. We believe these parameters are to be exported to user space through IOCTLs and would require addition of new IOCTLs and extension of control IDs. We will be working with you on this as well.

FWIW, for our SuperH Mobile devices we make use of UIO and user space
libraries to support for our on-chip multimedia blocks. These blocks
do scaling, rotation, color space conversion and hardware
encode/decode of various formats including h264 and mpeg4 in HD
resolution.

Apart from UIO we use V4L2 for the camera capture interface driver
sh_mobile_ceu_camera.c. It has support for on the fly color space
conversion and scaling/cropping. The CEU driver is making use of
videobuf-dma-contig.c and the USERPTR changes included in 2.6.31-rc
gives the driver zero copy frame capture support.

All of this is of course available upstream.

Cheers,

/ magnus
