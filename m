Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5OD3MnH006473
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 09:03:22 -0400
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.240])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5OD2p6M032148
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 09:02:51 -0400
Received: by an-out-0708.google.com with SMTP id d31so738031and.124
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 06:02:51 -0700 (PDT)
Message-ID: <d9def9db0806240602k14759806v40c8484825ecc09e@mail.gmail.com>
Date: Tue, 24 Jun 2008 09:02:51 -0400
From: "Markus Rechberger" <mrechberger@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: ir-kbd-i2c.c bug
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

lately I had a closer look at why my box crashed when reloading the
videomodules.
I initially took the remote control polling code from ir-kbd-i2c.c and
noticed that there's a problem with the deinitialization of the timer.

 http://linuxtv.org/hg/v4l-dvb/file/d182c0bbc49d/linux/drivers/media/video/ir-kbd-i2c.c


      502 	/* kill outstanding polls */
      503 	del_timer_sync(&ir->timer);
      504 	flush_scheduled_work();

Work Struct:
      307 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
      308 static void ir_work(void *data)
      309 #else
      310 static void ir_work(struct work_struct *work)
      320 	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(100));

So in that case the timer could be deleted before the work has been
finished, the final result in such a case would be that the kernel
dies in interrupt mode by accessing the deinitialized timer struct.

best would probably be to use delayed_work here...

It's rather easy reproduceable when using msecs_to_jiffies(5).

I have limited internet access at the moment, so submitting a patch
could take a while from my side, maybe someone else can fix it? :)
I guess this constellation can be found in other code too, especially
hotpluggable devices might trigger such a problem.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
