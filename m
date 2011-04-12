Return-path: <mchehab@pedra>
Received: from mail.visioncatalog.de ([217.6.246.34]:59290 "EHLO
	root.phytec.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab1DLLWq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 07:22:46 -0400
Subject: Re: Antwort: Re: [PATCH 1/2] mt9v022: fix pixel clock
From: Teresa Gamez <T.Gamez@phytec.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1302269227.5045.437.camel@lws-gamez>
References: <1302098515-12176-1-git-send-email-t.gamez@phytec.de>
	 <Pine.LNX.4.64.1104071303001.26842@axis700.grange>
	 <OF0E7310A6.B4F9559D-ONC125786B.003E2F29-C125786B.004202D7@phytec.de>
	 <Pine.LNX.4.64.1104071419540.26842@axis700.grange>
	 <1302269227.5045.437.camel@lws-gamez>
Date: Tue, 12 Apr 2011 13:22:47 +0200
Message-ID: <1302607367.17189.12.camel@lws-gamez>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am Freitag, den 08.04.2011, 15:27 +0200 schrieb Teresa Gamez:
> Hello Guennadi,
> 
> Am Donnerstag, den 07.04.2011, 14:41 +0200 schrieb Guennadi
> Liakhovetski:
> > Hello Teresa
> > 
> > On Thu, 7 Apr 2011, Teresa Gamez wrote:
> > 
> > > Hello Guennadi,
> > > 
> > > the datasheet also says (see table 3):
> > > 
> > > <quote>
> > > Pixel clock out. DOUT is valid on rising edge of this
> > > clock.
> > > </quote>
> > > 
> > > There is a difference between DOUT beeing vaild and DOUT beeing set up. 
> > > So does SOCAM_PCLK_SAMPLE_RISING mean that the data is valid at rising 
> > > edge or 
> > > does it mean the data is set up at rising edge? 
> > 
> > Hm, yeah, looks like a typical example of a copy-paste datasheet to me:-( 
> > And now we don't know which of the two is actually supposed to be true. As 
> > for "set up" vs. "valid" - not sure, whether there is indeed a difference 
> > between them. To me "set up _TO_ the rising edge" is a short way to set 
> > "set up to be valid at the rising edge," however, I might be wrong. Can 
> > you tell me in more detail what and where (at the sensor board or on the 
> > baseboard) you measured and what it looked like? I think, Figure 7 and the 
> > description below it are interesting. From that diagram I would indeed say 
> > indeed the DOUT pins are valid and should be sampled at the rising edge by 
> > default - when bit 4 in 0x74 is not set. SOCAM_PCLK_SAMPLE_RISING means, 
> > that the data should be sampled at the rising of pclkm, i.e., it is valid 
> > there.
> 
> I meassured the outgoing pins from the baseboard to the camera board and
> checked the PCLK and D0 to see at which point the data is valid. I have
> also checked the quality of the image.
> All tests where made with sensor_type=color
> 
> My results for pcm038 are with following register settings:
> 
> mx2_camera
> 0x0 CSICR1:		0x10020b92
> -> rising edge
> 
> mt9v022
> 0x74 PIXCLK_FV_LV:      0x00000010
> -> rising edge (which I think is falling edge)
> 
> meassured: falling edge (ugly image, wrong colors)
> 
> Now I set the SOCAM_SENSOR_INVERT_PCLK flag in the platformcode for the
> mt9v022:
> 
> mx2_camera
> 0x0 CSICR1		  0x10020b92
> -> rising edge 
> 
> mt9v022
> 0x74 PIXCLK_FV_LV         0x00000000
> -> falling edge (which I think is rising edge)
> 
> meassured: rising edge (image is OK)
> 
> Now changed the PCLK of the mx2_camera:
> 
> mx2_camera
> 0x0 CSICR1               0x10020b90
> -> falling edge 
> 
> mt9v022
> 0x74 PIXCLK_FV_LV        0x00000010
> -> rising edge (which I think is falling edge)
> 
> meassured: falling edge (image is OK)
> 
> > 
> > So, yes, if your measurements agree with figure 7 from the datasheet, we 
> > shall assume, that the driver implements the pclk polarity wrongly. But 
> > the fix should be more extensive, than what you've submitted: if we invert 
> > driver's behaviour, we should also invert board configuration of all 
> > driver users: pcm990 and pcm037. Or we have to test them and verify, that 
> > the inverted pclk polarity doesn't megatively affect the image quality, or 
> > maybe even improves it.
> > 
> > Thanks
> > Guennadi
> > 
> > > I have tested this with a pcm038 but I will also make meassurements with 
> > > the pcm037.
> > > 
> 
> Same results with the pcm037:
> 
> mx3_camera
> 0x60 CSI_SENS_CONF:		0x00000700
> -> rising edge
> 
> mt9v022
> 0x74 PIXCLK_FV_LV:		0x00000010
> -> rising edge (which I think is falling edge)
> 
> meassured: falling edge (ulgy image, looks like b/w with pixel errors)
> 
> Set SOCAM_SENSOR_INVERT_PCLK flag in the platformcode for the mt9v022:
> mx3_camera
> 0x60 CSI_SENS_CONF:		0x00000700
> -> rising edge
> 
> mt9v022
> 0x74 PIXCLK_FV_LV		0x00000000
> -> falling edge (which I think is rising edge)
> 
> meassured: rising edge (image is OK)
> 
> Additionally set MX3_CAMERA_PCP of the mx3_camera flags 
> 
> mx3_camera
> 0x60 CSI_SENS_CONF:		0x00000708
> -> falling edge
> 
> mt9v022
> 0x74 PIXCLK_FV_LV:       	0x00000010
> -> rising edge (which I think is falling edge)
> 
> meassured: falling edge (image is OK)
> 
> Removed SOCAM_SENSOR_INVERT_PCLK flag for the mt9v022:
> 
> mx3_camera
> 0x60 CSI_SENS_CONF:		0x00000708
> -> falling edge
> 
> mt9v022
> 0x74 PIXCLK_FV_LV		0x00000000
> -> falling edge (which I think is rising edge)
> 
> meassured: risging edge (ugly image, looks like the first one)
> 
> I have noticed that on our pcm037 BSP the SOCAM_SENSOR_INVERT_PCLK flag
> for the camera was set to "fix" this issue.
> I will continue this test on the pcm990.
> 

Got the same result with the pcm990:

pxa_camera
0x50000010 CICR4:	0x00880001
			-> rising edge (0 << 22)
mt9v022
0x74 PIXCLK_FV_LV:      0x00000010
			-> rising edge (1 << 4) (which I think is falling edge)

meassured: falling edge (some pixel have wrong colors)

---
Now set the SOCAM_SENSOR_INVERT_PCLK for mt9v022:

pxa_camera
0x50000010 CICR4:	0x00880001
			-> rising edge (0 << 22)

mt9v022
0x74 PIXCLK_FV_LV:	0x00000000
			-> falling edge (0 << 4) (which I think is rising edge)

meassured: rising edge (image is OK)

---
Additionaly set the PXA_CAMERA_PCP flag:

pxa_camera
0x50000010 CICR4:	0x00c80001
			-> falling edge (1 << 22)

mt9v022
0x74 PIXCLK_FV_LV:	0x00000010
			-> rising edge (1 << 4) (which I think is falling edge)

meassured: falling edge (image is OK)

---
Removed SOCAM_SENSOR_INVERT_PCLK again:

pxa_camera
0x50000010 CICR4:       0x00c80001
			-> falling edge (1 << 22)

mt9v022
0x74 PIXCLK_FV_LV: 	0x00000000
        	 	    -> falling edge (0 << 4) (which I think is rising edge)

meassured: rising edge (same as above, image shows wrong colored pixels) 


I hope thats sufficed.

Teresa


