Return-path: <mchehab@pedra>
Received: from gateway07.websitewelcome.com ([67.18.80.17]:51396 "HELO
	gateway07.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752821Ab1DSTD3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 15:03:29 -0400
From: "Charlie X. Liu" <charlie@sensoray.com>
To: <video4linux-list@redhat.com>
Cc: <linux-media@vger.kernel.org>
References: <BANLkTikqBPdr2M8jyY1zmu4TPLsXo0y5Xw@mail.gmail.com> <BANLkTi=dVYRgUbQ5pRySQLptnzaHOMKTqg@mail.gmail.com> <1302015521.4529.17.camel@morgan.silverblock.net> <BANLkTimQkDHmDsqSsQ9jiYnHWXnc7umeWw@mail.gmail.com> <1302481535.2282.61.camel@localhost> <20110411163239.GA4324@mgebm.net> <20110418141514.GA4611@mgebm.net> <ac791492-7bc5-4a78-92af-503dda599346@email.android.com> <20110418224855.GB4611@mgebm.net> <1303215523.2274.27.camel@localhost> <20110419171220.GA4883@mgebm.net>
In-Reply-To: <20110419171220.GA4883@mgebm.net>
Subject: Sensoray Model 314 DIP Switch setting for LiPPERT's Cool XpressRunner-GS45 SBC
Date: Tue, 19 Apr 2011 11:54:17 -0700
Message-ID: <002601cbfec3$3043f930$90cbeb90$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Per Sensoray Model 314 ( http://www.sensoray.com/products/314.htm )
customer's request, we have tested 314 with LiPPERT's Cool XpressRunner-GS45
( http://www.lippertembedded.com/en/lipperts-cool-xpressrunner-gs45.html )
SBC (Single Board Computer). 

Per customer's request and for their convenience, here, we list the Model
314's DIP switch setting combinations that work with the LiPPERT's Cool
XpressRunner-GS45 SBC:

(on Model 314)
SW2-1 2 3 4 5 6     Slot # and INT    Verified
----------------------------------------------
    D D U U U D     Slot #0 + INTA#      V
    U D U U D U     Slot #1 + INTB#      V
    D U U D U U     Slot #2 + INTC#      V
    U U D U U U     Slot #3 + INTD#      V
----------------------------------------------
Note:   D -- Down (ON);   U -- Up (OFF)


Best regards,

Charlie X. Liu @ Sensoray Co.



