Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m91IRpiL018676
	for <video4linux-list@redhat.com>; Wed, 1 Oct 2008 14:27:51 -0400
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.187])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m91IRfY2009363
	for <video4linux-list@redhat.com>; Wed, 1 Oct 2008 14:27:41 -0400
Received: by rn-out-0910.google.com with SMTP id k32so266108rnd.7
	for <video4linux-list@redhat.com>; Wed, 01 Oct 2008 11:27:39 -0700 (PDT)
Message-ID: <3ebb0dc80810011127v38c55961yd37cd13e32fcc829@mail.gmail.com>
Date: Wed, 1 Oct 2008 15:27:39 -0300
From: "Vinicius Kamakura" <thehexa@gmail.com>
To: "Vinicius Kamakura" <thehexa@gmail.com>, video4linux-list@redhat.com
In-Reply-To: <20080930121259.GA237@daniel.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <20080908160012.574456184D5@hormel.redhat.com>
	<48C5948D.5030504@migmasys.com> <20080909190727.GA2184@daniel.bse>
	<3ebb0dc80809300125n24567d11kf4b414b7909c8270@mail.gmail.com>
	<20080930121259.GA237@daniel.bse>
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: a multichannel capture problem
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

2008/9/30 Daniel Glöckner <daniel-gl@gmx.net>:
> On Tue, Sep 30, 2008 at 05:25:27AM -0300, Vinicius Kamakura wrote:
>> On Tue, Sep 09, 2008 at 09:07:27PM +0200, Daniel Glöckner wrote:
>> > Some time ago I made some experiments changing the input at random times
>> > using direct hardware access while capturing. IIRC the chip will skip at
>> > least one complete frame before it continues to capture.
>> >
>>
>> what do you mean by direct hardware access?
>
> I mmap'ed /sys/class/video4linux/video0/device/resource0 and toggled
> bit 5 of IFORM.
>
>  Daniel
>

Isn't that the same as using the VIDIOC_S_INPUT ioctl?
Or is there a performance gain (less field/frame skipping) on doing that?

- vk

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
