Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47755 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab3EPLxt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 May 2013 07:53:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Sekhar Nori <nsekhar@ti.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/6] ARM: davinci: dm365 evm: remove init_enable from ths7303 pdata
Date: Thu, 16 May 2013 13:54:08 +0200
Message-ID: <8665087.XDPi8z3vzr@avalon>
In-Reply-To: <CA+V-a8txWU=ohuJfmtKk5fQ_rh_qsp8wA72vUXWEDBZU1TJR-g@mail.gmail.com>
References: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com> <CA+V-a8uU6QkYcMg1b5BPHbA0gUGypZeXZNScE-WLa-GqK4_fQA@mail.gmail.com> <CA+V-a8txWU=ohuJfmtKk5fQ_rh_qsp8wA72vUXWEDBZU1TJR-g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On Thursday 16 May 2013 17:18:00 Prabhakar Lad wrote:
> On Wed, May 15, 2013 at 5:41 PM, Prabhakar Lad wrote:
> > On Wed, May 15, 2013 at 5:35 PM, Laurent Pinchart wrote:
> >> On Wednesday 15 May 2013 17:27:18 Lad Prabhakar wrote:
> >>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >>> 
> >>> remove init_enable from ths7303 pdata as it is no longer exists.
> >> 
> >> You should move this before 1/6, otherwise you will break bisection.
> 
> How about I just reshuffles while issuing a pull rather than resending
> the whole series ?

As long as you don't forget to do so, sure :-)

-- 
Regards,

Laurent Pinchart

