Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m848AGYv004344
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 04:10:16 -0400
Received: from IMPaqm1.telefonica.net (impaqm1.telefonica.net [213.4.149.61])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8489xuG012728
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 04:09:59 -0400
Message-ID: <14252019.1220515774408.JavaMail.root@cps2>
Date: Thu, 4 Sep 2008 10:09:34 +0200 (MEST)
From: "EVENTYR@terra.es" <EVENTYR@terra.es>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: Cannot allocate memory
Reply-To: EVENTYR@terra.es
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

I'm executing test software which is in official website:


http://v4l2spec.bytesex.org/spec/capture-example.html

My system is a debian stable with kernel 2.6.24 (i'm trying with 2.6.18 too).


Software crash (stop) when i use USERPTR mode:

-u | --userp         Use application allocated buffers

Software returns:

"VIDIOC_QBUF error 12, Cannot allocate memory"

With other two modes (READ and MMAP) works fine, but i need that works with USERPTR mode, what is the problem?

Thanks a lot.






Ahora tambi&eacute;n puedes acceder a tu correo Terra desde el m&oacute;vil.

Inf&oacute;rmate pinchando aqu&iacute;.





--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
