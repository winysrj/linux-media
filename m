Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8O40rpH011102
	for <video4linux-list@redhat.com>; Wed, 24 Sep 2008 00:00:53 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8O40f8W027098
	for <video4linux-list@redhat.com>; Wed, 24 Sep 2008 00:00:41 -0400
Received: by nf-out-0910.google.com with SMTP id d3so845367nfc.21
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 21:00:41 -0700 (PDT)
Date: Wed, 24 Sep 2008 14:01:20 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <20080924140120.44e5c238@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [REGRESSION] I2C remote controls on saa7134
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

Hi All.

I found what happens.
At 17 Aug in rev. 8394-8396 Mauro
Remove dependency saa7134 of ir-kbd-i2c. But all i2c remote controls work via this module.
Need load ir-kbd-i2c module with saa7134 or make module option for it.
If I load this module manualy remote control is working.

With my best regards, Dmitry.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
