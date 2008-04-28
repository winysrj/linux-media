Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3SKR26c032391
	for <video4linux-list@redhat.com>; Mon, 28 Apr 2008 16:27:02 -0400
Received: from bay0-omc1-s19.bay0.hotmail.com (bay0-omc1-s19.bay0.hotmail.com
	[65.54.246.91])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3SKQmpK026491
	for <video4linux-list@redhat.com>; Mon, 28 Apr 2008 16:26:49 -0400
Message-ID: <BAY109-W23742D6ECAA5EF9CDEF632CBDE0@phx.gbl>
From: =?Windows-1252?Q?Vicent_Jord=E0?= <vjorda@hotmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Mon, 28 Apr 2008 20:26:43 +0000
In-Reply-To: <20080428114741.040ccfd6@gaivota>
References: <BAY109-W5337BE0CEB1701C6AC945ACBDE0@phx.gbl>
	<20080428114741.040ccfd6@gaivota>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: RE: Trying to set up a NPG Real DVB-T PCI Card
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


Hi,

(1) Firmware is not version 2.7;

I have got the firmware  following the instuctions on http://lists-archives.org/video4linux/20837-extract-tool-for-xc3028-firmware.html

(2) tuner-callback is sending a wrong reset. Xc3028 needs to receive a reset, gia a GPIO pin, for firmware to load. If you don't send a reset, firmware won't load; The better is to use regspy.exe (provided together with DCALER) and see what gpio changes during firmware load.

But regspy.exe is a Windows program. I tried to run it from wine but doesn't work.

(3) On some devices, you need to slow down firmware sending.

How can I try this?

Thanks, 
Vicent

> Date: Mon, 28 Apr 2008 11:47:41 -0300
> From: mchehab@infradead.org
> To: vjorda@hotmail.com
> CC: video4linux-list@redhat.com
> Subject: Re: Trying to set up a NPG Real DVB-T PCI Card
>
> On Mon, 28 Apr 2008 14:40:24 +0000
> Vicent Jordà  wrote:
>
>>
>> Hi,
>>
>> I'm trying to set up a NPG Real DVB-T PCI Card.
>>
>> [ 1587.165812] xc2028 0-0061: Loading firmware for type=MTS (4), id 0000000100000007.
>> [ 1587.183960] xc2028 0-0061: Incorrect readback of firmware version.
>> ==============================================================================
>>
>> What can I do to workaroud this problem?
>
> Are you sure you're using the correct firmware?
>
> This kind of error could happen on a few cases:
> 1) Firmware is not version 2.7;
> 2) tuner-callback is sending a wrong reset. Xc3028 needs to receive a reset, gia a GPIO pin, for firmware to load. If you don't send a reset, firmware won't load;
> 3) On some devices, you need to slow down firmware sending.
>
> If your firmware is correct, I guess your problem is (2). The better is to use regspy.exe (provided together with DCALER) and see what gpio changes during firmware load.
>
> Cheers,
> Mauro

_________________________________________________________________
Tecnología, moda, motor, viajes,…suscríbete a nuestros boletines para estar siempre a la última
Guapos y guapas, clips musicales y estrenos de cine. 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
