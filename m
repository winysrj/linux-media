Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2P06AY6006605
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 20:06:10 -0400
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2P05l6q007377
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 20:05:48 -0400
Received: by ey-out-2122.google.com with SMTP id 9so435118eyd.39
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 17:05:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <751977.60511.qm@web65409.mail.ac4.yahoo.com>
References: <751977.60511.qm@web65409.mail.ac4.yahoo.com>
Date: Tue, 24 Mar 2009 21:05:47 -0300
Message-ID: <9c4b1d600903241705h4a44d3eerb0f8fc5aab886b9b@mail.gmail.com>
From: Adrian Pardini <pardo.bsso@gmail.com>
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Tom Watson <sdc695@yahoo.com>
Subject: Re: But all I want to do is view my webcam...
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

On 24/03/2009, Tom Watson <sdc695@yahoo.com> wrote:
>
> So I tried 'xawtv'.  It gave "No space left on device", which sounds weird
> to me.

With usb devices that usually means the driver cannot get the
requested bandwidth from the usb bus. Try unplugging *every* (really,
I mean, just leave the cam alone) other usb thing you have and see if
that error vanishes.

kind regards.


-- 
Adrian.
http://solar.org.ar

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
