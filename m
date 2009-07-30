Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6UEJYdR002697
	for <video4linux-list@redhat.com>; Thu, 30 Jul 2009 10:19:34 -0400
Received: from mail-gx0-f221.google.com (mail-gx0-f221.google.com
	[209.85.217.221])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n6UEJJbJ002330
	for <video4linux-list@redhat.com>; Thu, 30 Jul 2009 10:19:19 -0400
Received: by gxk21 with SMTP id 21so2670408gxk.3
	for <video4linux-list@redhat.com>; Thu, 30 Jul 2009 07:19:19 -0700 (PDT)
Message-ID: <4A71ABDB.2070100@gmail.com>
Date: Thu, 30 Jul 2009 10:19:07 -0400
From: "buhochileno@gmail.com" <buhochileno@gmail.com>
MIME-Version: 1.0
CC: V4L Mailing List <video4linux-list@redhat.com>
References: <1244577481.32457.1319583459@webmail.messagingengine.com>	
	<1246654555282-3203325.post@n2.nabble.com>	
	<1246882966.1165.1323684945@webmail.messagingengine.com>	
	<4A7058FA.4060409@gmail.com>	
	<829197380907290734l175a2c18sc76ae82b1f5d2eb@mail.gmail.com>	
	<829197380907290742t678039al95c800e9a8c8c22e@mail.gmail.com>	
	<4A706591.2090707@gmail.com>	
	<829197380907290820j2ed4d4a0ycdccf8ffebd992ca@mail.gmail.com>	
	<4A71A11A.8070903@gmail.com>
	<829197380907300640g2b0df1ddm31cdef61c4565d25@mail.gmail.com>
In-Reply-To: <829197380907300640g2b0df1ddm31cdef61c4565d25@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: KWorld VS-USB2800D recognized as PointNix Intra-Oral Camera -
 No 	Composite Input
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


>> As a aside note, and probably this was asked before, do you know any way to
>> set witch input be used as defoult in a device?, in my case xawtv allways
>> start trying to use the S-video input and I have to change to the composite
>> one, I now that xawtv have a config file in witch I can set something like
>> that, but that is just for xawtv, I mean a more permanent way, may be
>> setting something in the driver?, some dirty cheat in the code? ,
>>
>> in advance thanks..
>>
>> Mauricio
>>     
>
> Well, if your device is always connected, you could do something like
> run v4l2-ctl in a init script which sets the input.  
weird, trying this  v4l2-ctl -d /dev/video0 -i 1 tell me that it change 
the input to "composite1", nevertheless xawtv, vlc or  ffplay start 
using s-video  input, I'm doing something wrong?

Thanks for you time Devin

Mauricio


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
