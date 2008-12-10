Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBABhZhC025064
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 06:43:35 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBABhDwX030591
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 06:43:13 -0500
Received: by wf-out-1314.google.com with SMTP id 25so124765wfc.6
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 03:43:13 -0800 (PST)
Message-ID: <5d5443650812100343t41fb7db8p1956d6aa0b184c26@mail.gmail.com>
Date: Wed, 10 Dec 2008 17:13:12 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Sakari Ailus" <sakari.ailus@nokia.com>
In-Reply-To: <493E3217.8050503@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d5443650811261044w30748b75w5a47ce8b04680f79@mail.gmail.com>
	<20081208194235.4991873d@pedra.chehab.org>
	<493E3217.8050503@nokia.com>
Cc: v4l <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org Mailing List" <linux-omap@vger.kernel.org>,
	hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Add OMAP2 camera driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Sakari,

On Tue, Dec 9, 2008 at 2:23 PM, Sakari Ailus <sakari.ailus@nokia.com> wrote:
> The DMA part is definitely the ugliest part of omap24xxcam.
>
> This is actually also a DMA controller driver. The system DMA driver could
> not be used as such as it was limited to just one controller --- the OMAP 2
> camera block has its own DMA controller with four transfers in queue
> (maximum).
>
> There's also an MMU, not the system MMU but the camera block MMU. This MMU
> is not being used now by omap24xxcam at all since when omap24xxcam driver
> was written, there was not too much time available and no generic MMU
> framework. So the MMU support was left out. Instead, there's a hack to
> allocate as large as possible continuous memory areas and avoid overruns
> that way. DMA transfer overruns happen on large proportion of frames without
> this hack.

This is due to legacy and carried forward to every new kernel version
from year 2004. I hope someone having H4 EVM can do it lot faster than
me, as I only have N8xx tablets, and debugging on them might be slow.

>
> Hiroshi Doyu is working on a generic IOMMU framework for OMAPs that could be
> used here. With that framework available, converting the OMAP 2 camera
> driver to use videobuf would be a lot easier. The performance would be
> better, too. A generic DMA controller driver would be also good to have but
> not mandatory.

This is not yet mainlined, so let's incorporate IOMMU bits once it
gets mainlined.


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
