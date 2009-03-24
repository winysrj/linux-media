Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2OMTfca027629
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 18:29:41 -0400
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.27])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2OMTJYV007928
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 18:29:19 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1304352qwh.39
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 15:29:18 -0700 (PDT)
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Date: Tue, 24 Mar 2009 19:29:09 -0300
References: <200903231708.08860.lamarque@gmail.com> <49C8AF04.7070208@hhs.nl>
	<200903241909.59494.lamarque@gmail.com>
In-Reply-To: <200903241909.59494.lamarque@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903241929.10498.lamarque@gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Skype and libv4
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


	By the way, the message "Skype Xv: No suitable overlay format found" was gone 
when I apply this patch, it was only one problem, not two. That makes the 
think that this message is misleading. It is not a Xv overlay problem, it is 
just Skype that does not recognize the format returned by the v4l2's driver 
(or libv4l in my case).

Em Tuesday 24 March 2009, Lamarque Vieira Souza escreveu:
> 	Hi,
>
> 	Applying this patch to libv4l makes Skype works with my webcam without
> changing the driver. Do you think the patch is ok?


-- 
Lamarque V. Souza
http://www.geographicguide.com/brazil.htm
Linux User #57137 - http://counter.li.org/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
