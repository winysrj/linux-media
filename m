Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n986xOxb007109
	for <video4linux-list@redhat.com>; Thu, 8 Oct 2009 02:59:24 -0400
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n986x9ZC016238
	for <video4linux-list@redhat.com>; Thu, 8 Oct 2009 02:59:09 -0400
Received: from tervel.nabble.com ([192.168.236.150])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <bounces@n2.nabble.com>) id 1Mvmxw-0005sW-L5
	for video4linux-list@redhat.com; Wed, 07 Oct 2009 23:59:08 -0700
Date: Wed, 7 Oct 2009 23:59:08 -0700 (PDT)
From: Carlos Lavin <carlos.lavin@vista-silicon.com>
To: video4linux-list@redhat.com
Message-ID: <1254985148643-3786323.post@n2.nabble.com>
In-Reply-To: <9319940908100515w21d38a5bs6c6a552b07498fc4@mail.gmail.com>
References: <eedb5540908060552n43021d5bla6ee655c294307eb@mail.gmail.com>
	<20090807191809.GJ5842@pengutronix.de>
	<9319940908091109l64530b9cgd2e305ea8127a35a@mail.gmail.com>
	<eedb5540908092359g27e61389wad4a918f3339ae38@mail.gmail.com>
	<9319940908100515w21d38a5bs6c6a552b07498fc4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: soc-camera driver for i.MX27
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


hello, i'm Carlos Lavín and i'm partner of Javier. I was trying download the
PHYTEC repository of this URL git: / /
git.pengutronix.de/git/phytec/linux-2.6.git but I have a problem when I
download it, this repositoy isn't complete. moreover, when i'm downloading
this repository i have a warning... why?
can you help me, please? thank you. 




Derek Bouius wrote:
> 
> On Mon, Aug 10, 2009 at 3:25 AM, Sascha Hauer<sha@pengutronix.de> wrote:
>> Hi,
>>
>> On Mon, Aug 10, 2009 at 08:59:23AM +0200, javier Martin wrote:
>>> Dear Derek,
>>>
>>> >> We have a driver for the phyCORE-i.MX27 board:
>>> >>
>>> http://git.pengutronix.de/?p=phytec/linux-2.6.git;a=blob;f=drivers/media/video/mx27_camera.c;h=9e9f4426c3db890e6fc13130e047c65c073aa0b4;hb=refs/heads/phytec-master
>>>
>>> Thank you for the pointer to the patch.
>>>
>>> > I have just used this driver to interface to a soc imager (Aptina
>>> > mt9p031) on the phyCORE-i.MX27 board. It works for acquiring a 640x480
>>> > video stream quite reliably. I am currently working on getting it to
>>> > be able to capture a full image frame (5MB) as well as various image
>>> > sizes in between. I am running into out of memory issues with the
>>> > dma_alloc_coherent() and not sure what the solution is yet.
>>> >
>>>
>>> Maybe you are requesting too much contiguous memory. I don't remember
>>> where that could be changed.
>>
>> It's CONSISTENT_DMA_SIZE.
>>
> That did the trick.
> Thanks, Derek
> 
> 
>> Sascha
>>
>> --
>> Pengutronix e.K.                           |                            
>> |
>> Industrial Linux Solutions                 | http://www.pengutronix.de/
>>  |
>> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0  
>>  |
>> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555
>> |
>>
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 
> 

-- 
View this message in context: http://n2.nabble.com/soc-camera-driver-for-i-MX27-tp3398063p3786323.html
Sent from the video4linux-list mailing list archive at Nabble.com.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
