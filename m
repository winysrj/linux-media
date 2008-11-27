Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mARBtNxm032495
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 06:55:24 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.172])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mARBtMdi021036
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 06:55:22 -0500
Received: by wf-out-1314.google.com with SMTP id 25so929332wfc.6
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 03:55:21 -0800 (PST)
Message-ID: <62e5edd40811270355id4e856g1a8fb53f73455a39@mail.gmail.com>
Date: Thu, 27 Nov 2008 12:55:21 +0100
From: "=?ISO-8859-1?Q?Erik_Andr=E9n?=" <erik.andren@gmail.com>
To: "Chia-I Wu" <olvaffe@gmail.com>
In-Reply-To: <20081127105931.GD19421@m500.domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492B15E1.2080207@gmail.com> <20081125082002.GC18787@m500.domain>
	<492E7906.905@redhat.com> <20081127105931.GD19421@m500.domain>
Cc: Hans de Goede <hdegoede@redhat.com>, video4linux-list@redhat.com,
	noodles@earth.li, qce-ga-devel@lists.sourceforge.net
Subject: Re: Please test the gspca-stv06xx branch
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

2008/11/27 Chia-I Wu <olvaffe@gmail.com>:
> On Thu, Nov 27, 2008 at 11:40:06AM +0100, Hans de Goede wrote:
>> Chia-I Wu, I'm afraid this might conflict with your HDCS work, as it is
>> against Erik's latest hg tree, so without your patches. I noticed you
>> were defining your own read/write register functions which really seems
>> the wrong thing todo, hopefully with my new functions you can use those
>> directly, or ?
> IMO, it is almost always a good thing that each driver defines its own
> wrapping reg read/write functions.  It is less confusing and saves
> typings.  It makes the sub-driver loosely coupled with the main driver.
> And, the compiler will do the right thing, and optimize them out if
> appropriate.
>

I agree with Hans on this matter. It convolutes the driver and gives
no real gain.
I've just been converting the gspca-m5602 to use one set of read /
write functions instead of sensor specific ones and it removes a large
amount of code.

What the compiler does is one thing but when dealing with non
performance critical code paths, code simplicity is more important.

Best regards,
Erik

> --
> Regards,
> olv
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
