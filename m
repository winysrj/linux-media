Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4TMvafl023187
	for <video4linux-list@redhat.com>; Thu, 29 May 2008 18:57:36 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.236])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4TMv3rd020456
	for <video4linux-list@redhat.com>; Thu, 29 May 2008 18:57:03 -0400
Received: by rv-out-0506.google.com with SMTP id f6so4194720rvb.51
	for <video4linux-list@redhat.com>; Thu, 29 May 2008 15:57:03 -0700 (PDT)
Message-ID: <f50b38640805291557m38e6555aqe9593a2a42706aa5@mail.gmail.com>
Date: Thu, 29 May 2008 18:57:03 -0400
From: "Jason Pontious" <jpontious@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Kworld 115-No Analog Channels
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

After getting upgraded to the latest v4l-dvb repository I am no longer able
to get any analog channels from my Kworld 115. (I finally broke down and
installed 2.6.25 kernel in Ubuntu).

Before I was getting analog channels via the top rf input.  Now I get no
channels regardless if i set atv_input tuner_simple module setting.  Digital
channels are not affected just analog in this.  I get no errors from dmesg.

Any Ideas?

Thanks!
Jason Pontious
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
