Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7JE6FKG012885
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 10:06:15 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7JE6Cea009023
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 10:06:13 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KVRqZ-0003ew-Re
	for video4linux-list@redhat.com; Tue, 19 Aug 2008 14:06:07 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 14:06:07 +0000
Received: from paulius.zaleckas by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 14:06:07 +0000
To: video4linux-list@redhat.com
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Date: Tue, 19 Aug 2008 17:05:51 +0300
Message-ID: <48AAD33F.7000000@teltonika.lt>
References: <A69FA2915331DC488A831521EAE36FE457EDDAA9@dlee06.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <A69FA2915331DC488A831521EAE36FE457EDDAA9@dlee06.ent.ti.com>
Subject: Re: V4L2 - contiguous buffer support
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

Karicheri, Muralidharan wrote:
> Hello All,
> 
> I had seen some patches in the past about adding support for contiguous buffer allocation in V4L2 buffer management subsystem. Could someone tell me when this is expected to be in the kernel tree ? If possible, I would like to work with an interim version if available.

It is already in the mainline. If I am not mistaken since 2.6.27-rc1.
videobuf-dma-contig.c

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
