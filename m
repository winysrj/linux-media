Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5H9PDMf020902
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 05:25:13 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m5H9P0iO007240
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 05:25:01 -0400
Date: Tue, 17 Jun 2008 11:24:39 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Veda N <veda74@gmail.com>
Message-ID: <20080617092439.GA631@daniel.bse>
References: <a5eaedfa0806170205r12eed4edl30e2653a918e4cad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5eaedfa0806170205r12eed4edl30e2653a918e4cad@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: v4l2_pix_format doubts
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

On Tue, Jun 17, 2008 at 02:35:04PM +0530, Veda N wrote:
>  My datasheet says the size of each pixel is 12 bits per color channel.
> 
>  Hence for RGB will be 36bits.
> 
>  I wanted to know if the same hold true for YUV data.

Can you tell us for which hardware you want to write a driver?

The values to fill in depend on the final layout of the data in memory.
As you should not convert to YUV in software, it depends solely on the
hardware.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
