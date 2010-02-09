Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.epfl.ch ([128.178.224.226]:49555 "HELO smtp3.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751198Ab0BITH4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 14:07:56 -0500
Message-ID: <4B71B285.7020208@epfl.ch>
Date: Tue, 09 Feb 2010 20:07:49 +0100
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Magnus Damm <damm@opensource.se>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Antonio Ospite <ospite@studenti.unina.it>,
	=?ISO-8859-15?Q?N=E9meth_M=E1?= =?ISO-8859-15?Q?rton?=
	<nm127@freemail.hu>
Subject: Re: soc-camera: patches for 2.6.34
References: <Pine.LNX.4.64.1002091705500.4585@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1002091705500.4585@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> Hi all
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

Well, the above one is from me, and I have posted the updated version 
for pm context this morning: 
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/15897

(You certainly had noticed, but wanted to make sure).


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

Val

-- 
Valentin Longchamp, PhD Student, EPFL-STI-LSRO1
valentin.longchamp@epfl.ch, Phone: +41216937827
http://people.epfl.ch/valentin.longchamp
MEB3494, Station 9, CH-1015 Lausanne
