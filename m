Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m88NrFMP009938
	for <video4linux-list@redhat.com>; Mon, 8 Sep 2008 19:53:16 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m88NqTNt024830
	for <video4linux-list@redhat.com>; Mon, 8 Sep 2008 19:52:29 -0400
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
In-Reply-To: <de8cad4d0809081443o39bf9a17vc804e86981f2170e@mail.gmail.com>
References: <de8cad4d0809081443o39bf9a17vc804e86981f2170e@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 19:53:42 -0400
Message-Id: <1220918022.3137.4.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Recommended 2 input hardware encoder
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

On Mon, 2008-09-08 at 17:43 -0400, Brandon Jenkins wrote:
> Hi all,
> 
> I am looking for a Linux compatible board which has 2 analog
> svideo/composite inputs (NTSC) on a single bracket. Anyone know of
> such a thing? A tuner is not required, but a hardware encoder for
> mpeg-2 is.

If you want to do two captures simultaneously, you'll need two MPEG
encoders.

The PVR-500 (MCE version linked here) is one such device that has two
encoder chips:

http://www.hauppauge.com/pages/products/data_pvr500mce.html

You may need to wire up a custom cable to one of the internal white
header connectors to use the second MPEG encoder with an input other
then the 2nd tuner.

It's well supported by the ivtv driver for CX23416 based devices.

You can probably get the card cheap off of eBay.

Regards,
Andy

> Thanks,
> 
> Brandon


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
