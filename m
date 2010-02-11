Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o1BHE3nB024259
	for <video4linux-list@redhat.com>; Thu, 11 Feb 2010 12:14:03 -0500
Received: from mail-qy0-f185.google.com (mail-qy0-f185.google.com
	[209.85.221.185])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o1BHDEC7004359
	for <video4linux-list@redhat.com>; Thu, 11 Feb 2010 12:13:48 -0500
Received: by mail-qy0-f185.google.com with SMTP id 15so1036418qyk.7
	for <video4linux-list@redhat.com>; Thu, 11 Feb 2010 09:13:48 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 11 Feb 2010 17:13:47 +0000
Message-ID: <3cf2debb1002110913l5493e8c0h114fe59e732b9763@mail.gmail.com>
Subject: control frame rate
From: Nuno Cardoso <linun77@gmail.com>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi list,

How can I control the frame rate in v4l2? ffmpeg use v4l2 driver, and when
you configure the input camera to capture n frames, the driver capture all
the frames and drop the frames to process only n frames. Is this a good
solution? Or there are a better solution?

Thanks,
Nuno Cardoso.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
