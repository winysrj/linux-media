Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:43895 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaAMWjs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 17:39:48 -0500
Message-ID: <52D46B30.6050503@gmail.com>
Date: Mon, 13 Jan 2014 23:39:44 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Emad Hosseini Moghadam <s.e.hossini.m@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: s3c-camif question
References: <CACeCsj56M5ea_wWsePZkKn5=kdGEzORYUDiDnQ0K81=aMqbdTA@mail.gmail.com>
In-Reply-To: <CACeCsj56M5ea_wWsePZkKn5=kdGEzORYUDiDnQ0K81=aMqbdTA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Emad,

(adding linux-media at Cc)

On 01/13/2014 10:43 PM, Emad Hosseini Moghadam wrote:
> Dear Mr. Nawrocki,
>
> I am writing a driver for an image sensor, using i2c-s3c2410 and
> s3c-camif platforms,in order to initialize the registers of the image
> sensor. My cpu is s3c2440 . I have some questions regarding s3c-camif,
> if it is possible for you of course:
>
> 1. I think it is impossible to initialize the registers of my image
> sensor by s3c-camif. Then, why s3c-camif needs the information of the
> sensor in "struct s3c_camif_sensor_info"?

Basically the driver of an image sensor is supposed to take care of the
I2C registers details. It implements some v4l2_subdevice callbacks, of 
which
some can be called by the host interface driver (s3c-camif). You can do
some initialization for example in s_power() callback, or during a first
call to s_stream(). For an example see ov9650 driver [1].

s3c-camif registers an I2C client device for the sensor, so it needs an
information to which physical I2C bus the sensor is connected (i2c bus
adapter id) and what is an I2C slave address of the sensor.

The other members of struct s3c_camif_plat_data [2] include sensor master
clock frequency information - so s3c-camif driver sets clock frequency
appropriate for the sensor; polarization of signals like pixel clock, 
VSYNC,
HSYNC - in order to match configuration of the parallel video interface at
the sensor (transmitter) and the application processor SoC (receiver) side.

> 2. Would you please tell me how can I initialize the "struct
> s3c_camif_sensor_info" or give a sample?

For your reference, a patch I used for mini2440 board and ov9650 sensor
can be found at [2].

I hope it helps, please ask if anything is not clear.

--
Regards,
Sylwester

[1] 
http://git.linuxtv.org/media_tree.git/blob/eab924d0e2bdfd53c902162b0b499b8464c1fb4a:/drivers/media/i2c/ov9650.c
[2] 
http://git.linuxtv.org/snawrocki/media.git/commitdiff/48a72b878abdc9795da753981beff4a99ff80656
