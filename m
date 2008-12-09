Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB98sm7M023150
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 03:54:48 -0500
Received: from mgw-mx03.nokia.com (smtp.nokia.com [192.100.122.230])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB98sDJ4025916
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 03:54:13 -0500
Message-ID: <493E3217.8050503@nokia.com>
Date: Tue, 09 Dec 2008 10:53:43 +0200
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: ext Mauro Carvalho Chehab <mchehab@infradead.org>
References: <5d5443650811261044w30748b75w5a47ce8b04680f79@mail.gmail.com>
	<20081208194235.4991873d@pedra.chehab.org>
In-Reply-To: <20081208194235.4991873d@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: v4l <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org Mailing List" <linux-omap@vger.kernel.org>,
	hiroshi DOYU <Hiroshi.DOYU@nokia.com>
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

ext Mauro Carvalho Chehab wrote:
> On Thu, 27 Nov 2008 00:14:51 +0530
> "Trilok Soni" <soni.trilok@gmail.com> wrote:
> 
>> +
>> +/*
>> + *
>> + * DMA hardware.
>> + *
>> + */
>> +
>> +/* Ack all interrupt on CSR and IRQSTATUS_L0 */
>> +static void omap24xxcam_dmahw_ack_all(unsigned long base)
> 
> Oh, no! yet another dma video buffers handling...
> 
> Soni, couldn't this be converted to use videobuf?

Yes, it could be.

The DMA part is definitely the ugliest part of omap24xxcam.

This is actually also a DMA controller driver. The system DMA driver 
could not be used as such as it was limited to just one controller --- 
the OMAP 2 camera block has its own DMA controller with four transfers 
in queue (maximum).

There's also an MMU, not the system MMU but the camera block MMU. This 
MMU is not being used now by omap24xxcam at all since when omap24xxcam 
driver was written, there was not too much time available and no generic 
MMU framework. So the MMU support was left out. Instead, there's a hack 
to allocate as large as possible continuous memory areas and avoid 
overruns that way. DMA transfer overruns happen on large proportion of 
frames without this hack.

Hiroshi Doyu is working on a generic IOMMU framework for OMAPs that 
could be used here. With that framework available, converting the OMAP 2 
camera driver to use videobuf would be a lot easier. The performance 
would be better, too. A generic DMA controller driver would be also good 
to have but not mandatory.

Cheers,

-- 
Sakari Ailus
sakari.ailus@nokia.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
