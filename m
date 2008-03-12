Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2C2Rmqs019488
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 22:27:48 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.184])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2C2RH2q012292
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 22:27:17 -0400
Received: by ti-out-0910.google.com with SMTP id 11so1052458tim.7
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 19:27:16 -0700 (PDT)
Message-ID: <9618a85a0803111927p347f97e0w3bd0278048587f0b@mail.gmail.com>
Date: Wed, 12 Mar 2008 10:27:15 +0800
From: "kevin liu" <lwtbenben@gmail.com>
To: video4linux-list@redhat.com, linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: v4l-dvb won't compile on Linux kernel 2.6.24.
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

Hi, list
    I wanted to try my television card on slax Linux which uses Linux
2.6.24 as its kernel.
And I compiled my downloaded v4l-dvb on slax, but unfortunately, it
won't compile.
    From the dmesg, I noticed that Linux i2c core and Linux v4l2 have
some changes. Such as
struct video_device and struct i2c_client.
    So, what should I do to make my v4l-dvb compiled under the newest
Linux kernel.

    Thanks in advance.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
