Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nBMA86vc025962
	for <video4linux-list@redhat.com>; Tue, 22 Dec 2009 05:08:06 -0500
Received: from mail-pw0-f52.google.com (mail-pw0-f52.google.com
	[209.85.160.52])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nBMA7oXY015388
	for <video4linux-list@redhat.com>; Tue, 22 Dec 2009 05:07:50 -0500
Received: by pwi8 with SMTP id 8so4071475pwi.11
	for <video4linux-list@redhat.com>; Tue, 22 Dec 2009 02:07:49 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 22 Dec 2009 11:07:49 +0100
Message-ID: <fe6fd5f60912220207t1271fd3atc4e3ec0abfdc3b9d@mail.gmail.com>
Subject: I2C of sensor SOC_CAMERA
From: Carlos Lavin <carlos.lavin@vista-silicon.com>
To: video4linux-list@redhat.com
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

hello. I'm developping a driver and I need develop a sensor with soc_camera
library, well , I have a problem with the sensor because I can't read
correctly of it, I use these instructions when I register the driver:
static int __init ov7670_module_init(void)
{

    return i2c_add_driver(&ov7670_soc_i2c_driver);
}

and in function probe of sensor.
...
if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
...
i2c_set_clientdata(client, priv);
...
ret = soc_camera_device_register(icd);

I don't know why I can't read well of this sensor...the sensor return values
incorrect and bad (as "fffffffb") the address I2C is correct, can someone
help me? can be that I haven't important function in the driver or in the
configuration board?
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
