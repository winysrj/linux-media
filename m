Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0JE35Ok012935
	for <video4linux-list@redhat.com>; Mon, 19 Jan 2009 09:03:05 -0500
Received: from co203.xi-lite.net (co203.xi-lite.net [149.6.83.203])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0JE2YU4019730
	for <video4linux-list@redhat.com>; Mon, 19 Jan 2009 09:02:34 -0500
Message-ID: <497487F2.7070400@parrot.com>
Date: Mon, 19 Jan 2009 15:02:26 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: soc-camera : sh_mobile_ceu_camera race on free_buffer ?
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

I am writing a soc camera driver, and I use sh_mobile_ceu_camera as an
example.

But I don't understand how buffer are handled when the application is
doing a streamoff :

streamoff will call videobuf_streamoff and then videobuf_queue_cancel.
videobuf_queue_cancel will call free_buffer.

But we didn't do stop_capture, so as far I understand the controller is
still writing data in memory. What prevent us to free the buffer we are
writing.


Why doesn't we do a stop_capture before videobuf_streamoff ?

I saw that pxa_camera use videobuf_waiton, before freeing the buffer.
That seem more safe, but that mean we need to wait that controller
finish to write all the pending buffer.


Matthieu

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
