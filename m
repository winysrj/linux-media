Return-path: <video4linux-list-bounces@redhat.com>
Message-ID: <5e9665e10901082031w44ada663le47f0d503e27a687@mail.gmail.com>
Date: Fri, 9 Jan 2009 13:31:29 +0900
From: "DongSoo Kim" <dongsoo.kim@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <20090109021805.517f8c83@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5e9665e10901081920q4d99fe3ercf163a285d1462c5@mail.gmail.com>
	<20090109021805.517f8c83@pedra.chehab.org>
Cc: kyungmin.park@samsung.com,
	=?EUC-KR?B?x/zB2CCx6A==?= <riverful.kim@samsung.com>,
	video4linux-list@redhat.com, jongse.won@samsung.com,
	linux-media@vger.kernel.org
Subject: Re: Any rules in making ioctl or cids?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>

Thank you Mauro.

I finally got it what to do.

I'll figure it out how to make it easier to control strobe lights through CIDs.

"Try to avoid creating newer ioctls" is the same I think.

Cheers,

Nate

On Fri, Jan 9, 2009 at 1:18 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On Fri, 9 Jan 2009 12:20:16 +0900
> "DongSoo Kim" <dongsoo.kim@gmail.com> wrote:
>
>> Hello everyone.
>>
>> I'm facing with some questions about "Can I make it ioctl or CID?"
>
> For most cases, creating a control (CID) is better than using another ioctl.
>
>> Because if I make it in ioctl It should occupy one of the extra ioctl
>> number for v4l2, and I'm afraid it deserves that.
>>
>> Actually I'm working on strobe flash device (like xenon flash, LED
>> flash and so on...) for digital camera.
>>
>> And in my opinion it looks good in v4l2 than in misc device. (or..is
>> there some subsystems for strobe light? sorry I can't find it yet)
>
> As far as I understand, having this on V4L2 would be better.
>
>> As far as I worked on, strobe light seems to be more easy to control
>> over ioctl than CID. Since we need to check its status (like not
>> charged, turned off etc..).
>
> v4l2 controls can be used also to read. You may even group several different
> controls into one get or set request.
>
>> But here is the thing.
>>
>> "Is that really worthy of occupying an ioctl number for v4l2?"
>>
>> Can I use extra ioctl numbers as many as I like for v4l2 if It is reasonable?
>>
>> Can I have a rule if there is a rule for that?
>
> There's no rule, but we generally try to avoid creating newer ioctls. It is not
> forbidden to create, but we need to take some care with.
>
> Cheers,
> Mauro
>



-- 
========================================================
Dong Soo, Kim
Engineer
Mobile S/W Platform Lab. S/W centre
Telecommunication R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
           dongsoo45.kim@samsung.com
========================================================

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
