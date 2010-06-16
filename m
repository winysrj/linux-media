Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o5GCAM33028954
	for <video4linux-list@redhat.com>; Wed, 16 Jun 2010 08:10:22 -0400
Received: from mail-yx0-f174.google.com (mail-yx0-f174.google.com
	[209.85.213.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o5GCAAng013315
	for <video4linux-list@redhat.com>; Wed, 16 Jun 2010 08:10:11 -0400
Received: by yxl31 with SMTP id 31so2478683yxl.33
	for <video4linux-list@redhat.com>; Wed, 16 Jun 2010 05:10:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <981786867191595798@unknownmsgid>
References: <981786867191595798@unknownmsgid>
Date: Wed, 16 Jun 2010 17:40:10 +0530
Message-ID: <AANLkTim0wEYhn0z-b3aV2bImXLnXz7YxUbvKS2NMLtV2@mail.gmail.com>
Subject: Re: Time Stamp on Video(YUv420)
From: Vinay Verma <vinayverma@gmail.com>
To: Kiran Thakkar <kiran.thakkar@hitechroboticsystemz.com>
Cc: video4linux-list@redhat.com
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

Hi Kiran,

The timestamping part is already present in the V4l2 demo called Vivi. The
code is simple please have a look if its the same timestamping you require.

Regards,
Vinay

On Wed, Jun 16, 2010 at 11:02 AM, Kiran Thakkar <
kiran.thakkar@hitechroboticsystemz.com> wrote:

> Dear Friends,
>
>
>
> I am capturing images using V4l2 in my application and also I am saving
> some
> Image data as video in YUV420 format.
>
>
>
> Now, I want to put TimeStamp of capture images using V4l2.
>
>
>
> Can anybody help be for the same?
>
>
>
> Thanks & Regards,
>
> Kiran Thakkar
>
> Senior Research Developer
>
> Hitech Robotic Systemz -Hitech Group
>
> | B-13, Infocity,Sector-33/34, Gurgaon - 122001 |
>
> | (T) 91 124 4715300 Extn - 314 | Mobile: +91-9711528611 |
>
>
>
>
>
> -------------------------------------
> Hi-Tech Gears Limited, Gurgaon, India
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
