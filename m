Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2R4WZMo031608
	for <video4linux-list@redhat.com>; Fri, 27 Mar 2009 00:32:35 -0400
Received: from vsmtp14.tin.it (vsmtp14.tin.it [212.216.176.118])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2R4WFpi026196
	for <video4linux-list@redhat.com>; Fri, 27 Mar 2009 00:32:15 -0400
Received: from [79.17.5.86] (79.17.5.86) by vsmtp14.tin.it (8.0.022)
	id 49CB8EC300091619 for video4linux-list@redhat.com;
	Fri, 27 Mar 2009 05:32:14 +0100
Message-ID: <49CC565B.7090204@virgilio.it>
Date: Fri, 27 Mar 2009 05:30:19 +0100
From: "Ra.M." <ramsoft@virgilio.it>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: SAA7133 not working with kernel 2.6.29
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

After I have installed 2.6.29, now at boot time I get the message:

"IRQ 18/SAA7133: IRQF_DISABLED is not guaranteed on shared IRQs"

Signal strength is very low and Kaffeine is unable to tune in any channels.
No problem with 2.6.28.x

Is this a 2.6.29 bug?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
