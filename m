Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2OGRdIC001644
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 12:27:39 -0400
Received: from smtp105.biz.mail.re2.yahoo.com (smtp105.biz.mail.re2.yahoo.com
	[206.190.52.174])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n2OGQpZB030734
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 12:27:04 -0400
Message-ID: <49C909C8.8050107@migmasys.com>
Date: Tue, 24 Mar 2009 12:26:48 -0400
From: Ming Liu <mliu@migmasys.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: strange problem with KMC-4400R
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

I am working on KMC-4400R card. I tried to write a program to use two 
channels from the card by following the example program of V4l2. 
However, I met a very strange problem.

When I kept capturing image, there were several lines following the 
moving objects like a ghost (sometimes more than one ghost) on the 
collected image. I can not figure out what causes this problem and how 
to fix it. The standard xawtv does not have this problem when only one 
channel is displayed.

Any comments will be helpful and many thanks in advance.

Sincerely yours
Ming

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
