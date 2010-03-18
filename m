Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2ICRGpU006831
	for <video4linux-list@redhat.com>; Thu, 18 Mar 2010 08:27:16 -0400
Received: from dns1.dekooi.nl (static.kpn.net [92.68.105.29] (may be forged))
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2ICR3We015437
	for <video4linux-list@redhat.com>; Thu, 18 Mar 2010 08:27:04 -0400
Message-ID: <4BA21C12.6090609@bysky.nl>
Date: Thu, 18 Mar 2010 13:26:58 +0100
From: Gert-Jan de Jonge <de_jonge@bysky.nl>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Any update on em28xx on igevp2 ?
References: <4B9FA07B.3000206@bysky.nl>
	<829197381003160834k7e82cd6am5cf8153e3e5625b2@mail.gmail.com>
	<4BA2197E.4000305@saturnus.nl>
In-Reply-To: <4BA2197E.4000305@saturnus.nl>
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Devin,

just some extra info:

I have tested the difference on the arm board compared to the pc:
  int  height=576;
  height >>= 576;
  printf("%d\n", height);

on arm it gives a 0, on the pc it gives 576.
on both i get a warning from the compiler, as in my test code the 576 is 
hardcoded in stead of a variable
warning: right shift count >= width of type ( which is logical ;) )

regards,
Gert-Jan


Gert-Jan de Jonge wrote:
> Hi Devin,
>
> I am a big step further, I can now get video from the device.
> At this moment I am looking at  the function em28xx_resolution_set on 
> arm the height is set to 0 by the following lines:
>
>       if (!dev->progressive)
>                height >>= norm_maxh(dev);
>
> I am not sure what it should do, should it really shift the height 
> over the value of height ?
> If I set the height to f.e. 576 ater this line, i can capture video ( 
> it is 576 before this line )
> should it shift by 1 if it is interlaced and the resolution is higher 
> than the interlaced height ?
>
> regards,
> Gert-Jan
>
>
> Devin Heitmueller wrote:
>> 2010/3/16 Gert-Jan de Jonge <de_jonge@bysky.nl>:
>>  
>>> Hi,
>>>
>>> I saw on the list the John Banks was having problems getting video 
>>> from an
>>> em28xx device on an igepv2 board. I am curious if there is already a 
>>> fix ?
>>>     
>>
>> Nobody is working on it except for John.  If someone has some
>> commercial interest in seeing it working, I can probably help out.
>> Otherwise, the ARM is such an obscure platform for these sorts of
>> devices that it's not worth any of the developers' time (relative to
>> working on other things).
>>
>> Devin
>>
>>   
>
>

-----------------------------------------------------------------------

 BySky is  in 2007 bekroond door het Innovatie Aktie Programma Drenthe
 voor de backup en noodoplossingen.
 http://www.bysky.nl Fast Internet Anywhere                                                   

 BySpy heeft in 2008 de Bizz top 100 van innovatie bedrijven behaald (no. 38), 
 met haar video surveillance programma, zelfs een 3e plaats in de top 100 in 
 de categorie ICT/Creatief.
 http://www.byspy.nl An Eye Anywhere, video surveillance & online security

 BySpy is in 2009 met de applicatie voor frisse scholen (co2), genomineerd 
 door Syntens als Innovatie van de week.

 Disclaimer: http://www.bysky.nl/index.php/Disclaimer_email

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
