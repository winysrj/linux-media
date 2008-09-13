Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8DGTH0Y006900
	for <video4linux-list@redhat.com>; Sat, 13 Sep 2008 12:29:17 -0400
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8DGSQHB018798
	for <video4linux-list@redhat.com>; Sat, 13 Sep 2008 12:28:26 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com, EVENTYR@terra.es
Date: Sat, 13 Sep 2008 18:28:31 +0200
References: <14252019.1220515774408.JavaMail.root@cps2>
In-Reply-To: <14252019.1220515774408.JavaMail.root@cps2>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809131828.32120.laurent.pinchart@skynet.be>
Cc: 
Subject: Re: Cannot allocate memory
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

Hi,

On Thursday 04 September 2008, EVENTYR@terra.es wrote:
> Hi,
>
> I'm executing test software which is in official website:
>
>
> http://v4l2spec.bytesex.org/spec/capture-example.html
>
> My system is a debian stable with kernel 2.6.24 (i'm trying with 2.6.18
> too).
>
>
> Software crash (stop) when i use USERPTR mode:
>
> -u | --userp         Use application allocated buffers
>
> Software returns:
>
> "VIDIOC_QBUF error 12, Cannot allocate memory"
>
> With other two modes (READ and MMAP) works fine, but i need that works with
> USERPTR mode, what is the problem?

The driver you're using probably doesn't support the user pointer method. Not 
all drivers do. Why do you need that specific method ?

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
