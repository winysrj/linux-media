Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6UDXhP8021788
	for <video4linux-list@redhat.com>; Thu, 30 Jul 2009 09:33:43 -0400
Received: from mail-yw0-f199.google.com (mail-yw0-f199.google.com
	[209.85.211.199])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n6UDXQCB031438
	for <video4linux-list@redhat.com>; Thu, 30 Jul 2009 09:33:27 -0400
Received: by ywh37 with SMTP id 37so684143ywh.28
	for <video4linux-list@redhat.com>; Thu, 30 Jul 2009 06:33:26 -0700 (PDT)
Message-ID: <4A71A11A.8070903@gmail.com>
Date: Thu, 30 Jul 2009 09:33:14 -0400
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
In-Reply-To: <829197380907290820j2ed4d4a0ycdccf8ffebd992ca@mail.gmail.com>
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

As a aside note, and probably this was asked before, do you know any way 
to set witch input be used as defoult in a device?, in my case xawtv 
allways start trying to use the S-video input and I have to change to 
the composite one, I now that xawtv have a config file in witch I can 
set something like that, but that is just for xawtv, I mean a more 
permanent way, may be setting something in the driver?, some dirty cheat 
in the code? ,

in advance thanks..

Mauricio

Devin Heitmueller wrote:
> On Wed, Jul 29, 2009 at 11:06 AM,
> buhochileno@gmail.com<buhochileno@gmail.com> wrote:
>   
>> weird, I follow the exact instruction of the previous mail, also doing a
>> update at the v4l-dvb there is no update:
>> shell> hg update
>> 0 files updated, 0 files merged, 0 files removed, 0 files unresolved
>>     
>
> Ah, you must be a cvs or svn user.  With hg, running "hg update" from
> your working directory doesn't actually go to the server to download
> the latest code.  To update to the latest code, you would need to run:
>
> cd v4l-dvb
> hg pull http://linuxtv.org/hg/v4l-dvb
> hg update
>
> That said, I would suggest you just do a fresh clone and try again.
> If you want, you can send me the full output as an attachment
> off-list, and I can take a look and see if there are any obvious
> problems.
>
>   
>>> Also, rereading your email, are you sure the device has a tuner?  Do
>>> you know what tuner chip it contains?  If not, can you send digital
>>> photos of the PCB?
>>>
>>>       
>> Yeap, it have a turner becouse it is the robotis bioloid wireless camera
>> set, that have this receiver recognized as the PointNix... witch use
>> channels, 1, 2, 3. 4 to get the image wirelessly from the camera, no idea
>> about what turner chip it use, going to see if I can take some photos of the
>> PCB, but it is still with warrantie so I a little concern about it...
>>     
>
> Can you send me a link to the webpage for the product?
>
> Devin
>
>   

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
