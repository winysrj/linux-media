Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4M7oaB8003751
	for <video4linux-list@redhat.com>; Fri, 22 May 2009 03:50:36 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.28])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n4M7oMoO007173
	for <video4linux-list@redhat.com>; Fri, 22 May 2009 03:50:22 -0400
Received: by yw-out-2324.google.com with SMTP id 3so1171694ywj.81
	for <video4linux-list@redhat.com>; Fri, 22 May 2009 00:50:22 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 22 May 2009 15:50:22 +0800
Message-ID: <b90a809a0905220050k6f64321g7f72adee3f1e21c3@mail.gmail.com>
From: =?GB2312?B?vrDOxMHW?= <wenlinjing@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: How to acces TVP5150 .command function from userspace
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

I am working with a video capture chip TVP5150. I want to adjust the
"Brightness" "Contrast" "Saturation" and "hue" in user space.
In TVP5150 drivers ,the V4l2 commands are in function tvp5150_command.And
this function is a member of struct i2c_device.

The linux is 2.6.19.2.
I write my code according kernel document  Documentation/i2c/dev-interface
But I can`t access tvp5150_command.
How can i acces i2c_device .command  function from user space?


william.jing
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
