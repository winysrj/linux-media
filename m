Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2BMhKKD027090
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 18:43:20 -0400
Received: from mailrelay009.isp.belgacom.be (mailrelay009.isp.belgacom.be
	[195.238.6.176])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2BMgeTx021574
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 18:42:40 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Tue, 11 Mar 2008 23:49:35 +0100
References: <47d5b4b5.3b9.49c0.1570821612@uninet.com.br>
In-Reply-To: <47d5b4b5.3b9.49c0.1570821612@uninet.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803112349.35894.laurent.pinchart@skynet.be>
Cc: danflu@uninet.com.br
Subject: Re: webcam frame grabber - help please!
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

On Monday 10 March 2008, danflu@uninet.com.br wrote:
> Hello Everybody,
>
> I'm writing a linux app (testing under ubuntu) that should
> capture frames from webcam and do some processing to it. I
> have some background in this area because i've written
> several directshow apps, but i've never used to capture
> video under linux systems.
>
> So I'd really want to know from you what's the best way to
> capture video from webcam using V4L2, some sample code would
> be pretty usefull to me...

I uploaded a small test application to http://linux-uvc.berlios.de/test.c (it 
will probably not stay there forever). It should work with any V4L2 compliant 
driver that implements the mmap() streaming I/O method (which I recommend 
over read()). Feel free to experiment and modify the code.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
