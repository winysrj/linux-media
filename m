Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n021MWOq029322
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 20:22:32 -0500
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n021MEQR007169
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 20:22:14 -0500
Received: by rn-out-0910.google.com with SMTP id k32so4421597rnd.7
	for <video4linux-list@redhat.com>; Thu, 01 Jan 2009 17:22:13 -0800 (PST)
Message-ID: <495D7A51.40102@gmail.com>
Date: Thu, 01 Jan 2009 23:22:09 -0300
From: =?ISO-8859-1?Q?F=E1bio_Belavenuto?= <belavenuto@gmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <8ef00f5a0812171449o19fe5656wec05889b738e7aed@mail.gmail.com>	<20081230203235.1b7eecf3@pedra.chehab.org>	<200812311052.40693.hverkuil@xs4all.nl>
	<20081231081243.0cecad1d@pedra.chehab.org>
In-Reply-To: <20081231081243.0cecad1d@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Add TEA5764 radio driver
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

Mauro Carvalho Chehab escreveu:
> On Wed, 31 Dec 2008 10:52:40 +0100
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>   
>> Hi Mauro,
>>
>> Did you see my review of this driver?
>>
>> (http://lists-archives.org/video4linux/26062-add-tea5764-radio-driver.html)
>>
>> IMHO this driver shouldn't be added in this form. It's up to you of course 
>> to decide this, but I just want to make sure you read my posting.
>>     
>
> No, I haven't seen. I'm not sure why, but patchwork didn't show me your review.
>
> My comments about the points you raised:
>
> a) Yes, the proper approach is to split it into 2 separate drivers:
> 	1) a Motorola i2c bridge driver;
> 	2) a generic tea5764 driver;
>
> I would very much appreciate if Fabio can do this work, allowing others to use
> tea5764 driver;
>
> b) AFAIK, tea5764 is not so close to tea5767, so probably the right decision is
> to have it as a separate driver;
>
> c) The same design trouble on radio-tea5764 is also present on other radio-*
> drivers;
>
> d) While this design doesn't allow sharing tea5764 driver, for now, we have at
> least something. A future patch may split it into two drivers. That's why I
> decided to apply it.
>
> Fábio,
>
> Could you please work on split it into two drivers? You can use cx88 or saa7134
> as examples. On those drivers, the i2c stuff is at *-i2c.c, and the radio
> interface are at *-video.c.
>
> Cheers,
> Mauro
>   
Yes, I will change the driver, I will create 2 as explained, thanks.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
