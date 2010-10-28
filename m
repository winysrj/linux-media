Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:37548 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758438Ab0J1Xi3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 19:38:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: New media framework user space usage
Date: Fri, 29 Oct 2010 01:39:10 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTimx6XJKEz9883cwrm977OtXVPVB5K5PjSGFi_AJ@mail.gmail.com> <AANLkTi=Nv2Oe=61NQjzH0+P+TcODDJW3_n+NbfzxF5g3@mail.gmail.com>
In-Reply-To: <AANLkTi=Nv2Oe=61NQjzH0+P+TcODDJW3_n+NbfzxF5g3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201010290139.10204.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bastian,

On Thursday 28 October 2010 17:16:10 Bastian Hecht wrote:
> 
> after reading the topic "controls, subdevs, and media framework"
> (http://www.spinics.net/lists/linux-media/msg24474.html) I guess I
> double-posted something here :S
> But what I still don't understand is, how configuring the camera
> works. You say that the subdevs (my camera sensor) are configured
> directly. 2 things make me wonder. How gets the ISP informed about the
> change

The ISP doesn't need to know about sensor parameters except for image formats. 
Formats need to be set on both ends of every link, so the ISP will get 
informed when you will setup the sensor -> CCDC link.

> and why don't I see my camera in the subdevs name list I posted. All subdevs
> are from the ISP.

See my answer to your previous e-mail for that.

> My camera already receives a clock, the i2c connection works and my
> oscilloscope shows that the sensor is throwing out data on the parallel bus
> pins. But unfortunately I am a completely v4l2 newbie. I read through the
> v4l2-docs now but the first example already didn't work because of the new
> framework. Can you point me to a way to read /dev/video2?

With the media-ctl and yavta test applications, just run

./media-ctl -r -l '"mt9t001 3-005d":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP 
CCDC":1->"OMAP3 ISP CCDC output":0[1]'
./media-ctl -f '"mt9t001 3-005d":0[SGRBG10 1024x768], "OMAP3 ISP 
CCDC":1[SGRBG10 1024x768]'

./yavta -f SGRBG10 -s 1024x768 -n 4 --capture=4 --skip 3 -F $(./media-ctl -e 
"OMAP3 ISP CCDC output")

Replace all occurences of 1024x768 by your sensor native resolution, and 
"mt9t001 3-005d" by the sensur subdev name.

-- 
Regards,

Laurent Pinchart
