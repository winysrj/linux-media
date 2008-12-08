Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB8LhK7W010639
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 16:43:20 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mB8Lghom007241
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 16:42:43 -0500
Date: Mon, 8 Dec 2008 19:42:35 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Trilok Soni" <soni.trilok@gmail.com>
Message-ID: <20081208194235.4991873d@pedra.chehab.org>
In-Reply-To: <5d5443650811261044w30748b75w5a47ce8b04680f79@mail.gmail.com>
References: <5d5443650811261044w30748b75w5a47ce8b04680f79@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org Mailing List" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@nokia.com>
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

On Thu, 27 Nov 2008 00:14:51 +0530
"Trilok Soni" <soni.trilok@gmail.com> wrote:

> +
> +/*
> + *
> + * DMA hardware.
> + *
> + */
> +
> +/* Ack all interrupt on CSR and IRQSTATUS_L0 */
> +static void omap24xxcam_dmahw_ack_all(unsigned long base)

Oh, no! yet another dma video buffers handling...

Soni, couldn't this be converted to use videobuf?

Each time I see a driver implementing a different buffer schema I want to cry...

Those handlers seem to be very complex and different buffers implementations
lead to different errors that requires lots of time to fix. We should really
work to improve a common buffer handler that work fine for all drivers.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
