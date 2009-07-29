Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6TF7OOF006423
	for <video4linux-list@redhat.com>; Wed, 29 Jul 2009 11:07:24 -0400
Received: from mail-gx0-f221.google.com (mail-gx0-f221.google.com
	[209.85.217.221])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n6TF6GVg021151
	for <video4linux-list@redhat.com>; Wed, 29 Jul 2009 11:07:09 -0400
Received: by mail-gx0-f221.google.com with SMTP id 21so1535094gxk.3
	for <video4linux-list@redhat.com>; Wed, 29 Jul 2009 08:07:09 -0700 (PDT)
Message-ID: <4A706591.2090707@gmail.com>
Date: Wed, 29 Jul 2009 11:06:57 -0400
From: "buhochileno@gmail.com" <buhochileno@gmail.com>
MIME-Version: 1.0
CC: V4L Mailing List <video4linux-list@redhat.com>
References: <1244577481.32457.1319583459@webmail.messagingengine.com>	
	<1246654555282-3203325.post@n2.nabble.com>	
	<1246882966.1165.1323684945@webmail.messagingengine.com>	
	<4A7058FA.4060409@gmail.com>	
	<829197380907290734l175a2c18sc76ae82b1f5d2eb@mail.gmail.com>
	<829197380907290742t678039al95c800e9a8c8c22e@mail.gmail.com>
In-Reply-To: <829197380907290742t678039al95c800e9a8c8c22e@mail.gmail.com>
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

Hi Devin,
Thanks for the quick reply..

>> I can tell from the dmesg output that the code you are running in
>> still very old.  The current code will now dump out the "Alternate
>> Setting" lines and will identify the device as an "em28xx/saa713x
>> reference design".
>>     
>
> Correction: I meant to say the "current code will *not* dump out"
> instead of "will now dump out".
>
>   
weird, I follow the exact instruction of the previous mail, also doing a 
update at the v4l-dvb there is no update:
shell> hg update
0 files updated, 0 files merged, 0 files removed, 0 files unresolved

> Also, rereading your email, are you sure the device has a tuner?  Do
> you know what tuner chip it contains?  If not, can you send digital
> photos of the PCB?
>   
Yeap, it have a turner becouse it is the robotis bioloid wireless camera 
set, that have this receiver recognized as the PointNix... witch use 
channels, 1, 2, 3. 4 to get the image wirelessly from the camera, no 
idea about what turner chip it use, going to see if I can take some 
photos of the PCB, but it is still with warrantie so I a little concern 
about it...

Mauricio

> Devin
>
>   

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
