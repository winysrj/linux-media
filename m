Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o6UBV0B4025956
	for <video4linux-list@redhat.com>; Fri, 30 Jul 2010 07:31:00 -0400
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o6UBUpBO025219
	for <video4linux-list@redhat.com>; Fri, 30 Jul 2010 07:30:52 -0400
Received: from jim.nabble.com ([192.168.236.80])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <sudhindra.nayak@gmail.com>) id 1Oennf-0007j1-KC
	for video4linux-list@redhat.com; Fri, 30 Jul 2010 04:30:51 -0700
Date: Fri, 30 Jul 2010 04:30:51 -0700 (PDT)
From: Sudhindra Nayak <sudhindra.nayak@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <1280489451608-5354598.post@n2.nabble.com>
Subject: Not able to capture video frames
MIME-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


Hi all,

I'm using the 'Omnivision' ov538 camera bridge processor along with an
ov10620 CMOS sensor. I'm using a driver which I got from the following link:

http://lwn.net/Articles/308358/

I've modified the driver by inserting printk statements in the driver code
to understand the flow of control between functions. I've also changed the
arguments passed to the 'sccb_reg_write' function to values corresponding to
the ov10620 sensor. 

I'm using a v4l2 example code as my application along with the above
mentioned driver. The example code can be found at the below link:

http://v4l2spec.bytesex.org/spec/capture-example.html

When I run the application after inserting the driver, it calls the
open_device(), init_device() and start_capturing() functions and then enters
the mainloop() function. In the mainloop() function, the select() function
call times out after 2 seconds and I'm not able to capture any video frames.

I'm also receiving some errors like:

gspca: ISOC data error: [3] len=56, status=-71
gspca: ISOC data error: [4] len=12, status=-71

This repeats with different values for 'len' and the value in [ ].

Any solutions??


-----
Regards,

Sudhindra Nayak
-- 
View this message in context: http://video4linux-list.1448896.n2.nabble.com/Not-able-to-capture-video-frames-tp5354598p5354598.html
Sent from the video4linux-list mailing list archive at Nabble.com.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
