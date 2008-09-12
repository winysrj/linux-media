Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8C73mMA011873
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 03:03:48 -0400
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.247])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8C73cOl009896
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 03:03:38 -0400
Received: by an-out-0708.google.com with SMTP id d31so97585and.124
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 00:03:38 -0700 (PDT)
Message-ID: <3192d3cd0809120003q11367eb1if685b033b4f4d070@mail.gmail.com>
Date: Fri, 12 Sep 2008 07:03:37 +0000
From: "Christian Gmeiner" <christian.gmeiner@gmail.com>
To: "Linux and Kernel Video" <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: [PATCH] Clean up adv7175 driver
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

This patch removes some not needed includes and also removes some not supported
variables from struct adv7175.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>

-- 
Christian Gmeiner, B.Sc.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
