Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6AIvGTI015095
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 14:57:17 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.152])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6AIv21X031674
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 14:57:02 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1934622fga.7
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 11:57:02 -0700 (PDT)
Message-ID: <30353c3d0807101149t3166eeafn7011417ea173aaf1@mail.gmail.com>
Date: Thu, 10 Jul 2008 14:49:58 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Malsoaz James" <jmalsoaz@yahoo.fr>
In-Reply-To: <694825.25098.qm@web28404.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <694825.25098.qm@web28404.mail.ukl.yahoo.com>
Cc: video4linux-list@redhat.com
Subject: Re: Own software to use a camera
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

James,

I suspect you may benefit from using the new v4l-library. It should
help simplify the conversion of whatever format the camera supports
into whichever format your application desires. The current
development branch of the library is located here:
http://linuxtv.org/hg/~tmerle/v4l2-library/

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
