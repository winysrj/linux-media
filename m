Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nBMM0meK031122
	for <video4linux-list@redhat.com>; Tue, 22 Dec 2009 17:00:48 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id nBMM0WO2005633
	for <video4linux-list@redhat.com>; Tue, 22 Dec 2009 17:00:34 -0500
Date: Tue, 22 Dec 2009 23:00:28 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Carlos Lavin <carlos.lavin@vista-silicon.com>
Subject: Re: I2C of sensor SOC_CAMERA
In-Reply-To: <fe6fd5f60912220207t1271fd3atc4e3ec0abfdc3b9d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0912222239180.4919@axis700.grange>
References: <fe6fd5f60912220207t1271fd3atc4e3ec0abfdc3b9d@mail.gmail.com>
MIME-Version: 1.0
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

Hi

On Tue, 22 Dec 2009, Carlos Lavin wrote:

> hello. I'm developping a driver and I need develop a sensor with soc_camera
> library, well , I have a problem with the sensor because I can't read
> correctly of it, I use these instructions when I register the driver:
> static int __init ov7670_module_init(void)
> {
> 
>     return i2c_add_driver(&ov7670_soc_i2c_driver);
> }
> 
> and in function probe of sensor.
> ...
> if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> ...
> i2c_set_clientdata(client, priv);
> ...
> ret = soc_camera_device_register(icd);

If you're using this function, then you're using a very old kernel.

> I don't know why I can't read well of this sensor...the sensor return values
> incorrect and bad (as "fffffffb") the address I2C is correct, can someone
> help me? can be that I haven't important function in the driver or in the
> configuration board?

You should upgrade to the newest kernel, best to the Linus' git tree and 
port your driver to it. Then the most common reason for non-working I2C is 
not started master clock on the interface. I would look in that direction.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
