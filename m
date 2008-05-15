Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4FEbVZ5004521
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 10:37:31 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4FEb2XL008549
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 10:37:02 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JweZm-00075V-Jb
	for video4linux-list@redhat.com; Thu, 15 May 2008 14:36:58 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 14:36:58 +0000
Received: from augulis.darius by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 14:36:58 +0000
To: video4linux-list@redhat.com
From: Darius <augulis.darius@gmail.com>
Date: Thu, 15 May 2008 17:31:45 +0300
Message-ID: <g0hhpt$jfp$1@ger.gmane.org>
References: <g09j17$3m9$1@ger.gmane.org>	<Pine.LNX.4.64.0805122030310.5526@axis700.grange>	<g0bjtj$b0d$1@ger.gmane.org>
	<Pine.LNX.4.64.0805132212530.4988@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-13; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.64.0805132212530.4988@axis700.grange>
Subject: Re: question about SoC Camera driver (Micron)
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

Guennadi Liakhovetski wrote:
> On Tue, 13 May 2008, Darius wrote:
> 
>> Now I see how it works. I2C devices should be created before driver loading.
>> There was my mistake, and driver does not call probe() function. Maybe would
>> be better to create I2C devices by driver itself, not by the board specific
>> config code? Now sensor driver is useless itself, without board specific
>> configuration... Would be correct to do so?
> 
> No. This is not how the driver model works. PCI drivers do not register 
> PCI devices. The PCI host controller scans the PCI bus and adds devices 
> into the system, to be later matched against PCI drivers. Similar for USB 
> devices, etc. The problem with i2c you cannot reliably scan the bus. 
> Therefore the information about devices present on the system has to come 
> from elsewhere: when it is an i2c device embedded into a USB web-camera, 
> its driver "knows", there's an i2c device and registers it. On embedded 
> systems the platform knows what i2c devices are onboard, and registers 
> them using i2c_register_board_info(), on powerpc (and sparc?) you can 
> register i2c devices in your device tree, etc.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

Guennadi, can you please describe more detailed struct soc_camera_device structure? All these members xmin, ymin, etc...
Also soc_camera_data_format structure has member depht. Should this member fit sensor bus bit count or pixel format depht in videodev2.h?
Because most pixel formats are 16 bit and camera sensor interface in most cases is 8 bit.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
