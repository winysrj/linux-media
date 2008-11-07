Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA7I41J6031126
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 13:04:01 -0500
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA7I3xOQ016579
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 13:03:59 -0500
To: Antonio Ospite <ospite@studenti.unina.it>
References: <20081107125919.ddf028a6.ospite@studenti.unina.it>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Fri, 07 Nov 2008 19:03:54 +0100
In-Reply-To: <20081107125919.ddf028a6.ospite@studenti.unina.it> (Antonio
	Ospite's message of "Fri\, 7 Nov 2008 12\:59\:19 +0100")
Message-ID: <874p2jbegl.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH,
	RFC] mt9m111: allow data to be received on pixelclock falling edge?
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

Antonio Ospite <ospite@studenti.unina.it> writes:

> Now I have many questions:
>
> * Can the same sensor model have different default hardwired values?
>   I am referring to IO/Timings differences between mt9m111 on A910
>   and A780
Technically, yes.
Even the sensor can sometimes be configured to dump its date on falling edge
rather than rising edge. See MT9M111 datasheet, register 0x13a (Output Format
Control 2), bit 9.

> * Should I change the sensor setup instead of changing its advertised
>   capabilities? Maybe modifying mt9m111 so it can use platform data?
Would't it be better to change format negociation instead : patch in mt9m111.c
the mt9m111_query_bus_param() function, add SOCAM_PCLK_SAMPLE_FALLING, and add
necessary handling in the mt9m111_set_bus_param() ? That would be a little
extension of your attached patch ...

> * Is the pxa-camera code dealing with PXA_CAMERA_PCP too conservative?
>   Shouldn't PXA_CAMERA_PCP be independent from the specific sensor
>   capabilities? it is a valid pxa-camera setting even if it produces
>   wrong results with the specific sensor.
Well, I don't understand something here : you have to configure the sensor to
output data on rising edge, while the PXA is reading them on the falling edge,
am I right ? Would that mean the clock signal is inverted by the hardware ? I
don't really understand that part ...

> @@ -410,7 +410,8 @@ static int mt9m111_stop_capture(struct soc_camera_device *icd)
>
>  static unsigned long mt9m111_query_bus_param(struct soc_camera_device *icd)
>  {
> - return SOCAM_MASTER | SOCAM_PCLK_SAMPLE_RISING |
> + return SOCAM_MASTER |
> +   SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING |
>     SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
>     SOCAM_DATAWIDTH_8;
>  }
Don't forget mt9m111_set_bus_param(), and add an entry in struct mt9m111 to
remember the setting on suspend/resume. Amend accordingly mt9m111_setup_pixfmt()
with the new field in mt9m111_set_bus_param().

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
