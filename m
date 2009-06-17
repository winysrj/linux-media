Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:50782 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbZFQW30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 18:29:26 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Zach LeRoy <zleroy@rii.ricoh.com>,
	linux-omap <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Date: Wed, 17 Jun 2009 17:30:56 -0500
Subject: RE: OMAP34XXCAM: Micron mt9d111 sensor support?
Message-ID: <A24693684029E5489D1D202277BE894441165A1C@dlee02.ent.ti.com>
References: <25120191.127591245276351735.JavaMail.root@mailx.crc.ricoh.com>
In-Reply-To: <25120191.127591245276351735.JavaMail.root@mailx.crc.ricoh.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Zach LeRoy
> Sent: Wednesday, June 17, 2009 5:06 PM
> To: linux-omap; linux-media@vger.kernel.org
> Subject: OMAP34XXCAM: Micron mt9d111 sensor support?
> 
> I am working on adding support for a micron 2 MP sensor: mt9d111 on a
> gumsitx overo.  This is a i2c-controlled sensor.  Ideally, I would like to
> use the omap34xxcam driver to interface with this sensor.  I am wondering
> if there are currently any distributions which already include support for
> this sensor through the omap34xxcam driver, or if anyone else is
> interested in this topic.

Hi Zach,

I'm working along with Sakari Ailus and others in this omap34xxcam driver you're talking about, and we are in the process to provide a newer patchset to work on the latest l-o tree.

Sakari is sharing the camera core here:

http://gitorious.org/omap3camera

And I have also this repository which contains a snapshot of Sakari's tree + support from some sensors I have available for the 3430SDP and LDP (the name could confuse with the above, but I'll change the name/location soon):

http://gitorious.org/omap3-linux-camera-driver

Testing the driver with as much sensors as we can is very interesting (at least for me), because that help us spot possible bugs that aren't seen with our current HW. So, I'll be looking forward if you add this sensor driver to the supported list :)

Regards,
Sergio
> 
> Cheers,
> 
> Zach LeRoy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

