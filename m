Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n26Dlj7N022912
	for <video4linux-list@redhat.com>; Fri, 6 Mar 2009 08:47:45 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.173])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n26DlTWq020974
	for <video4linux-list@redhat.com>; Fri, 6 Mar 2009 08:47:29 -0500
Received: by wf-out-1314.google.com with SMTP id 25so491611wfc.6
	for <video4linux-list@redhat.com>; Fri, 06 Mar 2009 05:47:29 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 6 Mar 2009 19:17:29 +0530
Message-ID: <ca1417c50903060547l7cedda32q8795dc5a40b896dd@mail.gmail.com>
From: rahul G <freevofc6@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Problem with the TV out Sound !!!
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

 Hi All....
            I am using Pinnacle 50i TV tuner card for watching TV but
Radio functionality is not working with the card when I used
"/sbin/modprobe saa7134 card=77 tuner=54".
TV is working fine with this on linux-2.26.23.3.But when I used
"/sbin/modprobe saa7134 card=65 tuner=54" my radio is working fine
with this tuner card and not  TV.
When I tried with Linux-2.26.23.1 kernel with same command
"/sbin/modprobe saa7134 card=77 tuner=54" radio is working fine but
sound coming out from the device is too small.which not audiable.Can
any one tell me the reason behind this.

Thanks In Advance..

Regards,
Rahul G

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
