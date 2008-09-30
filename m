Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8U8PbhH020925
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 04:25:38 -0400
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8U8PRxK006982
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 04:25:27 -0400
Received: by yx-out-2324.google.com with SMTP id 31so371433yxl.81
	for <video4linux-list@redhat.com>; Tue, 30 Sep 2008 01:25:27 -0700 (PDT)
Message-ID: <3ebb0dc80809300125n24567d11kf4b414b7909c8270@mail.gmail.com>
Date: Tue, 30 Sep 2008 05:25:27 -0300
From: "Vinicius Kamakura" <thehexa@gmail.com>
To: "Ming Liu" <mliu@migmasys.com>, video4linux-list@redhat.com
In-Reply-To: <20080909190727.GA2184@daniel.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080908160012.574456184D5@hormel.redhat.com>
	<48C5948D.5030504@migmasys.com> <20080909190727.GA2184@daniel.bse>
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

>> Can I do this by using standard V4L2 APIs, or I will need to deal with
>> the driver?
>
> You can do this with V4L2.
>
> Some time ago I made some experiments changing the input at random times
> using direct hardware access while capturing. IIRC the chip will skip at
> least one complete frame before it continues to capture.
>

what do you mean by direct hardware access?

- vk

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
