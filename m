Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA8KaxVL011796
	for <video4linux-list@redhat.com>; Sat, 8 Nov 2008 15:36:59 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mA8KalPZ025874
	for <video4linux-list@redhat.com>; Sat, 8 Nov 2008 15:36:47 -0500
Date: Sat, 8 Nov 2008 21:36:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <874p2jbegl.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811082119280.8956@axis700.grange>
References: <20081107125919.ddf028a6.ospite@studenti.unina.it>
	<874p2jbegl.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH, RFC] mt9m111: allow data to be received on pixelclock
 falling edge?
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

On Fri, 7 Nov 2008, Robert Jarzmik wrote:

> Antonio Ospite <ospite@studenti.unina.it> writes:
> 
> > Now I have many questions:
> >
> > * Can the same sensor model have different default hardwired values?
> >   I am referring to IO/Timings differences between mt9m111 on A910
> >   and A780
> Technically, yes.
> Even the sensor can sometimes be configured to dump its date on falling edge
> rather than rising edge. See MT9M111 datasheet, register 0x13a (Output Format
> Control 2), bit 9.

Also register 0x00a is intersting...

> > * Should I change the sensor setup instead of changing its advertised
> >   capabilities? Maybe modifying mt9m111 so it can use platform data?
> Would't it be better to change format negociation instead : patch in mt9m111.c
> the mt9m111_query_bus_param() function, add SOCAM_PCLK_SAMPLE_FALLING, and add
> necessary handling in the mt9m111_set_bus_param() ? That would be a little
> extension of your attached patch ...

Yes, that would be correct, but, it seems, it would then stop working 
again, see below.

> > * Is the pxa-camera code dealing with PXA_CAMERA_PCP too conservative?
> >   Shouldn't PXA_CAMERA_PCP be independent from the specific sensor
> >   capabilities? it is a valid pxa-camera setting even if it produces
> >   wrong results with the specific sensor.
> Well, I don't understand something here : you have to configure the sensor to
> output data on rising edge, while the PXA is reading them on the falling edge,
> am I right ? Would that mean the clock signal is inverted by the hardware ? I
> don't really understand that part ...

That's also the only explanation I can see here too... I was actually 
wondering as I was developing the framework, if anyone ever would come up 
with an idea to put inverters on any of sync / clock lines or any other 
additional logic. Ok, you can configure inverters with extra platform 
flags, but can we really add enough flags to support any possible 
camera-interface design?... I am not a hardware designer, so, I have no 
idea what other configurations one can think of here. Shall we really add 
flags for inverters on all interface lines and hope noone will ever 
engineer anything more complex than that?

> > @@ -410,7 +410,8 @@ static int mt9m111_stop_capture(struct soc_camera_device *icd)
> >
> >  static unsigned long mt9m111_query_bus_param(struct soc_camera_device *icd)
> >  {
> > - return SOCAM_MASTER | SOCAM_PCLK_SAMPLE_RISING |
> > + return SOCAM_MASTER |
> > +   SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING |
> >     SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
> >     SOCAM_DATAWIDTH_8;
> >  }
> Don't forget mt9m111_set_bus_param(), and add an entry in struct mt9m111 to
> remember the setting on suspend/resume. Amend accordingly mt9m111_setup_pixfmt()
> with the new field in mt9m111_set_bus_param().

I think, it currently works thanks to this code in pxa_camera.c:

	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
	    (common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
		if (pcdev->platform_flags & PXA_CAMERA_PCP)
			common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
		else
			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
	}

i.e., if both sensor and host support both polarities take what's 
suggested by the platform. That's, probably, why Antonio's patch helped. 
But, if you also add flag handling to mt9m111_set_bus_param(), it will 
invert the pixel clock too, and it will stop working again... It's a pity 
we'll, probably, never see schematics of the phone:-)

So, shall we add inverter flags?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
