Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9S8TeHS028585
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 04:29:40 -0400
Received: from smtp0.lie-comtel.li (smtp0.lie-comtel.li [217.173.238.80])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9S8Tbw1016883
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 04:29:38 -0400
Message-ID: <4906CD70.1060402@kaiser-linux.li>
Date: Tue, 28 Oct 2008 09:29:36 +0100
From: Thomas Kaiser <linux-dvb@kaiser-linux.li>
MIME-Version: 1.0
To: Tommy van der Vorst <tommy@mycms.nl>
References: <001401c93855$9b263d80$d172b880$@nl>
In-Reply-To: <001401c93855$9b263d80$d172b880$@nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Video 4 Linux <video4linux-list@redhat.com>
Subject: Re: Trust WB-1300N webcam
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

Hello Tommy

I forward this mail to the v4l mail list because gspca V1 (spca5xx) is 
deprecated.

New, gspca V2 (v4l2 interface) is part of the official kernel tree, now. 
The newest source is included in the linuxtv project (www.linuxtv.org).

Jean-Francois, can you please pick up these changes?

Regards, Thomas

PS: Tommy, subscribe to the v4l mail list to get more infos about the 
progress with gspca v2.


Tommy van der Vorst wrote:
> Hi Michel, Thomas,
> 
>  
> 
> I tried to use the Trust WB-1300N webcam with the spca5xx drivers. The 
> device is not on the compatibility list, but is is based on the Pixart 
> PAC207 chip. Unfortunately, this webcam is not recognized by the driver 
> (it has USB ID 145f:013a, according to lsusb). When I read through the 
> source code, I realized that since the chip used is supported (Pixart 
> PAC207) and the chip is also the bridge itself, it might work if I 
> changed the USB vendor/device ID from another PAC207 device to my 
> device’s numbers. I edited a few lines in spca5xx.c to do that. That 
> didn’t work immediately, since the pac207 driver also seems to check 
> some kind of ‘id’ in the registers of the PAC207. The device was 
> recognized, but it didn’t work with any capture program (and would cause 
> errors to show up in dmesg). After disabling this check (which is 
> probably not the way it should be done…) I loaded the module and things 
> worked great! I now use it as a network camera (it’s connected to a 
> Linksys NSLU2, a small, ARM-based device).
> 
>  
> 
> My changes are below; I’m not such a hero with Linux source code so I 
> don’t know how to quickly create a patch, but it’s just a few changed 
> lines. It would be great if you could add these to the spca package, so 
> this is another cam to be supported!
> 
>  
> 
> Best regards,
> 
>  
> 
> Tommy van der Vorst.
> 
>  
> 
> *Pac207.h lines 137/138:*
> 
> // if (id[0] != 0x27 || id[1] != 0x00)
> 
> // return -ENODEV;
> 
>  
> 
> Probably change this to something sensible…
> 
>  
> 
> *In spca5xx.c function spcaDetectCamera:*
> 
> * *
> 
> *Add*
> 
> * *
> 
> case 0x145f:                       /* Trust */
> 
>                 switch(product) {
> 
>                                 case 0x013a:
> 
>                                                 spca50x->desc = PAC207;
> 
>                                                 spca50x->bridge = 
> BRIDGE_PAC207;
> 
>                                                 spca50x->sensor = 
> SENSOR_PAC207;
> 
>                                                 spca50x->cameratype = PGBRG;
> 
>                                                 
> memcpy(&spca50x->funct,&fpac207,sizeof(struct cam_operation));
> 
>                                                 break;
> 
>                                 }
> 
>                                 break;
> 
>                 }
> 
> }
> 
>  
> 
> Also add a USB_DEVICE with USB vendor ID 145f and product ID 013a.
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
