Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m88L9mPH013439
	for <video4linux-list@redhat.com>; Mon, 8 Sep 2008 17:09:48 -0400
Received: from smtp107.biz.mail.re2.yahoo.com (smtp107.biz.mail.re2.yahoo.com
	[206.190.52.176])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m88L9aVg005355
	for <video4linux-list@redhat.com>; Mon, 8 Sep 2008 17:09:36 -0400
Message-ID: <48C5948D.5030504@migmasys.com>
Date: Mon, 08 Sep 2008 17:09:33 -0400
From: Ming Liu <mliu@migmasys.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <20080908160012.574456184D5@hormel.redhat.com>
In-Reply-To: <20080908160012.574456184D5@hormel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: a multichannel capture problem
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

Hello,

As a newbie in V4L2, I am trying to capture two video channels 
simultaneously (we can live with about 0.05s difference between two 
channels). Currently, I am using PV-143 (a cheap card with one bt878 
chip). After some research, I found:

1. bt878 can only handle one channel at one time, so I will not be able 
to reach a speed higher than 15 frames/second per channel.
2. Since I can not synchronize the two cameras, I will have much lower 
frame rate if I try to switch between two channels.

My problems are:

1. Is there any example codes that I can follow to estimate the frame 
rates using switch channel approach? Can I do this by using standard 
V4L2 APIs, or I will need to deal with the driver?
2. If I choose a multi-chip PCI based video capture card, is there any 
limit from the bandwidth? Are there any sample codes available?
3. In the program point of view, is there difference between using 
multi-chip card and several single chip cards?

Thank you in advance.
Sincerely yours
Ming

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
