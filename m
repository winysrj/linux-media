Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([76.76.67.137]:3044 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbZFVSGD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 14:06:03 -0400
Message-ID: <4A3FC80B.9000302@mlbassoc.com>
Date: Mon, 22 Jun 2009 12:06:03 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
CC: Zach LeRoy <zleroy@rii.ricoh.com>,
	linux-omap <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: OMAP34XXCAM: Micron mt9d111 sensor support?
References: <25120191.127591245276351735.JavaMail.root@mailx.crc.ricoh.com> <A24693684029E5489D1D202277BE894441165A1C@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894441165A1C@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aguirre Rodriguez, Sergio Alberto wrote:
>   
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Zach LeRoy
>> Sent: Wednesday, June 17, 2009 5:06 PM
>> To: linux-omap; linux-media@vger.kernel.org
>> Subject: OMAP34XXCAM: Micron mt9d111 sensor support?
>>
>> I am working on adding support for a micron 2 MP sensor: mt9d111 on a
>> gumsitx overo.  This is a i2c-controlled sensor.  Ideally, I would like to
>> use the omap34xxcam driver to interface with this sensor.  I am wondering
>> if there are currently any distributions which already include support for
>> this sensor through the omap34xxcam driver, or if anyone else is
>> interested in this topic.
>>     
>
> Hi Zach,
>
> I'm working along with Sakari Ailus and others in this omap34xxcam driver you're talking about, and we are in the process to provide a newer patchset to work on the latest l-o tree.
>
> Sakari is sharing the camera core here:
>
> http://gitorious.org/omap3camera
>
> And I have also this repository which contains a snapshot of Sakari's tree + support from some sensors I have available for the 3430SDP and LDP (the name could confuse with the above, but I'll change the name/location soon):
>
> http://gitorious.org/omap3-linux-camera-driver
>
> Testing the driver with as much sensors as we can is very interesting (at least for me), because that help us spot possible bugs that aren't seen with our current HW. So, I'll be looking forward if you add this sensor driver to the supported list :)
>   

I'd like to move forward using this on OMAP/3530 with TVP5150 (S-video in)

Sadly, the tree above (omap3-linux-camera-driver) won't build for the
Zoom/LDP:
  CC      arch/arm/mach-omap2/board-ldp-camera.o
/local/omap3-linux-camera-driver/arch/arm/mach-omap2/board-ldp-camera.c:59:
error: implicit declaration of function 'PAGE_ALIGN'
/local/omap3-linux-camera-driver/arch/arm/mach-omap2/board-ldp-camera.c:59:
error: initializer element is not constant
/local/omap3-linux-camera-driver/arch/arm/mach-omap2/board-ldp-camera.c:59:
error: (near initialization for 'ov3640_hwc.capture_mem')
/local/omap3-linux-camera-driver/arch/arm/mach-omap2/board-ldp-camera.c:
In function 'ov3640_sensor_set_prv_data':
/local/omap3-linux-camera-driver/arch/arm/mach-omap2/board-ldp-camera.c:89:
error: 'hwc' undeclared (first use in this function)
/local/omap3-linux-camera-driver/arch/arm/mach-omap2/board-ldp-camera.c:89:
error: (Each undeclared identifier is reported only once
/local/omap3-linux-camera-driver/arch/arm/mach-omap2/board-ldp-camera.c:89:
error: for each function it appears in.)

Looking at the code, it seems that some pieces are missing - merge
problem maybe?

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------

