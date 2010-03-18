Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2ID9obY028561
	for <video4linux-list@redhat.com>; Thu, 18 Mar 2010 09:09:51 -0400
Received: from smtp.positive-internet.com (mail.positive-internet.com
	[80.87.128.64])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id o2ID9ZtL019383
	for <video4linux-list@redhat.com>; Thu, 18 Mar 2010 09:09:36 -0400
Subject: Re: Any update on em28xx on igevp2 ?
From: John Banks <john.banks@noonanmedia.com>
To: Gert-Jan de Jonge <de_jonge@bysky.nl>
In-Reply-To: <4BA21C12.6090609@bysky.nl>
References: <4B9FA07B.3000206@bysky.nl>
	<829197381003160834k7e82cd6am5cf8153e3e5625b2@mail.gmail.com>
	<4BA2197E.4000305@saturnus.nl>  <4BA21C12.6090609@bysky.nl>
Date: Thu, 18 Mar 2010 13:09:34 +0000
Message-ID: <1268917774.3616.61.camel@chimpin>
Mime-Version: 1.0
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

On Thu, 2010-03-18 at 13:26 +0100, Gert-Jan de Jonge wrote:
> Hi Devin,
> 
> just some extra info:
> 
> I have tested the difference on the arm board compared to the pc:
>   int  height=576;
>   height >>= 576;
>   printf("%d\n", height);
> 
> on arm it gives a 0, on the pc it gives 576.
> on both i get a warning from the compiler, as in my test code the 576 is 
> hardcoded in stead of a variable
> warning: right shift count >= width of type ( which is logical ;) )
> 
> regards,
> Gert-Jan
> 
> 
> Gert-Jan de Jonge wrote:
> > Hi Devin,
> >
> > I am a big step further, I can now get video from the device.
> > At this moment I am looking at  the function em28xx_resolution_set on 
> > arm the height is set to 0 by the following lines:
> >
> >       if (!dev->progressive)
> >                height >>= norm_maxh(dev);
> >
> > I am not sure what it should do, should it really shift the height 
> > over the value of height ?
> > If I set the height to f.e. 576 ater this line, i can capture video ( 
> > it is 576 before this line )
> > should it shift by 1 if it is interlaced and the resolution is higher 
> > than the interlaced height ?
> >
> > regards,
> > Gert-Jan
> >

Hey,

Yeah this is how I fixed my problem also. Though mine was set as 0 but
144 on the pc. Strange since the resolution I then get out is certainly
not 144.

Hardcoding the values completely fixed the problem for me (as long as I
ignore the compiler warnings :P ).

Looking to find out why the arm gives 0 to fix the cause.


-- 
John Banks - Head of Engineering
Noonan Media Ltd 

www.noonanmedia.com 

MB: +44 779 62 64 707 
E: john.banks@noonanmedia.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
