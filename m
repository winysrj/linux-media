Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54067 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754034Ab0BIQxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 11:53:48 -0500
Date: Tue, 9 Feb 2010 17:54:30 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Magnus Damm <damm@opensource.se>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Antonio Ospite <ospite@studenti.unina.it>,
	=?ISO-8859-15?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Subject: Re: soc-camera: patches for 2.6.34
In-Reply-To: <Pine.LNX.4.64.1002091705500.4585@axis700.grange>
Message-ID: <Pine.LNX.4.64.1002091749350.4585@axis700.grange>
References: <Pine.LNX.4.64.1002091705500.4585@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 9 Feb 2010, Guennadi Liakhovetski wrote:

> Hi all

Ok, add two more to these:

Guennadi Liakhovetski (2):
	soc-camera: add support for VIDIOC_S_PARM and VIDIOC_G_PARM ioctls
	sh_mobile_ceu_camera: pass .set_parm and .get_parm down to subdevices
	* status: pending confirmation from Kuninori Morimoto

> 
> Nothing exciting for soc-camera this time for a change, just a couple of 
> small improvements. These patches are already in my local tree, waiting to 
> be pushed up:
> 
> Antonio Ospite (1):
>       pxa_camera: remove init() callback
> 
> Guennadi Liakhovetski (3):
>       soc-camera: update mt9v022 to take into account board signal routing
>       tw9910: use TABs for indentation
>       soc-camera: adjust coding style to match V4L preferences
> 
> Kuninori Morimoto (1):
>       soc-camera: ov772x: Modify buswidth control
> 
> Magnus Damm (1):
>       soc-camera: return -ENODEV is sensor is missing
> 
> Others on the radar:
> 
> Kuninori Morimoto:
> 	MT9T031: write xskip and yskip at each set_params call
> 	* status: being discussed in PM context in:
> 
> Guennadi Liakhovetski:
> 	soc-camera: add runtime pm support for subdevices
> 	* under discussion
> 
> Németh Márton:
> 	soc_camera: match signedness of soc_camera_limit_side()                 
> 	* status: an updated patch has been proposed by me, waiting for 
> 	  confirmation
> 
> Guennadi Liakhovetski:
> 	document new pixel formats
> 	* status: I still have to figure out how to combine git / hg for 
> 	  this one and actually do it...
> 
> Kuninori Morimoto:
> 	[1/3] soc-camera: mt9t112: modify exiting conditions from standby mode
> 	[2/3] soc-camera: mt9t112: modify delay time after initialize
> 	[3/3] soc-camera: mt9t112: The flag which control camera-init is
> 	* status: at least patches 2 and 3 are still being discussed, 
> 	  waiting for results
> 
> 
> Any patches, that I've forgotten?
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
