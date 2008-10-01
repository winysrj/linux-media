Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m917STqw026714
	for <video4linux-list@redhat.com>; Wed, 1 Oct 2008 03:28:29 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.172])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m917SIEn029149
	for <video4linux-list@redhat.com>; Wed, 1 Oct 2008 03:28:18 -0400
Received: by wf-out-1314.google.com with SMTP id 25so421287wfc.6
	for <video4linux-list@redhat.com>; Wed, 01 Oct 2008 00:28:18 -0700 (PDT)
Message-ID: <62e5edd40810010028yba5fa91m6acaf93d3662acb8@mail.gmail.com>
Date: Wed, 1 Oct 2008 09:28:18 +0200
From: "=?ISO-8859-1?Q?Erik_Andr=E9n?=" <erik.andren@gmail.com>
To: "Hans de Goede" <j.w.r.degoede@hhs.nl>
In-Reply-To: <48E320F0.6030002@hhs.nl>
MIME-Version: 1.0
References: <48E273C3.5030902@gmail.com> <48E320F0.6030002@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Cc: video4linux-list@redhat.com, m560x-driver-devel@sourceforge.net
Subject: Re: [PATCH]Add support for the ALi m5602 usb bridge
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

2008/10/1 Hans de Goede <j.w.r.degoede@hhs.nl>

> Erik Andr=E9n wrote:
>
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Hi,
>>
>> This patch adds support for the ALi m5602 usb bridge and is based on the
>> gspca framework.
>> It contains code for communicating with 5 different sensors:
>> OmniVision OV9650, Pixel Plus PO1030, Samsung S5K83A, S5K4AA and finally
>> Micron MT9M111.
>>
>> Regards,
>> Erik Andr=E9n
>>
>>
> I like it, thanks for converting this to a gspca sub driver, I assume thi=
s
> helped you to reduce the code size somewhat?

Yes, about 20% give or take.


> If you have any remarks / suggestions to improve the gspca framework plea=
se
> say so.
>
It fitted in quite nicely, some more inline comments regarding
implementation would be good.
Perhaps a skeleton driver could be made to ease implementation.

I have some patches which I intend to send in the next couple of days.

Regards,
Erik




>
> Jean Fran=E7ois, can you pick this up and feed it to Mauro through the gs=
pca
> tree?
>
> Regards,
>
> Hans
>
>
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
