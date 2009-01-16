Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0G9FUgm013304
	for <video4linux-list@redhat.com>; Fri, 16 Jan 2009 04:15:30 -0500
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.187])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0G9FGb3012735
	for <video4linux-list@redhat.com>; Fri, 16 Jan 2009 04:15:16 -0500
Received: by rn-out-0910.google.com with SMTP id k32so1202576rnd.7
	for <video4linux-list@redhat.com>; Fri, 16 Jan 2009 01:15:16 -0800 (PST)
Message-ID: <aec7e5c30901160115n7468616cn8643a2220b69d225@mail.gmail.com>
Date: Fri, 16 Jan 2009 18:15:15 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0901161004060.4940@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <u1vv3u5j4.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0901160835240.4713@axis700.grange>
	<uzlhrslr1.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0901161004060.4940@axis700.grange>
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH] ov772x: add image flip support
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

On Fri, Jan 16, 2009 at 6:06 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Fri, 16 Jan 2009, morimoto.kuninori@renesas.com wrote:
>
>>
>> Dear Guennadi
>>
>> Thank you for checking patch.
>>
>> > This looks wrong to me. Please, use V4L2_CID_VFLIP and V4L2_CID_HFLIP
>> > controls for vertical and horisontal flips respectively.
>>
>> I could understand.
>>
>> And I have some questions.
>>
>> There is ov772x camera that has been inversely connected to board.
>> ap325 (SH7723) board is that board.
>>
>> Because it get upside down image,
>> I would like to get normal image by default.
>> But should I add V4L2_CID_XXX support ?
>>
>> And can I use V4L2_CID_VFLIP, V4L2_CID_HFLIP on mplayer ?
>> I think I can not ...
>
> I didn't find it either. Well, let's do it this way: you add
> V4L2_CID_VFLIP (and V4L2_CID_HFLIP if you like) support, and a flag to set
> flipped image by default, ok? Because implementing flipping functionality
> and not providing it to the user is sort of weird.

Maybe it's a good idea to implement it as xor? By that I mean letting
the platform data set the default direction and then allow user space
to change that by adding additional flipping once more. The code in
m5602_ov9650.c seems to do it right.

Cheers,

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
