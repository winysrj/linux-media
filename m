Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBBKaZiI011101
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 15:37:27 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBBKY9wU017481
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 15:34:30 -0500
Date: Thu, 11 Dec 2008 21:34:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: agustin@ferrin.org
In-Reply-To: <824398.40186.qm@web32104.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0812112026560.8782@axis700.grange>
References: <824398.40186.qm@web32104.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux list <video4linux-list@redhat.com>
Subject: Re: Soc-Camera architecture and nomenclature, and I2C in V4L
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

Hi Agustin,

On Thu, 11 Dec 2008, Agustin Ferrin Pozuelo wrote:

> Hello all,
> 
> I am developing a synchronous camera array based on i.MX31 architecture 
> and using Guennadi's current patches, as posted on this list (thanks!). 
> Hardware is based on on a phyCORE-i.MX31, to whose camera bus (CMOS 
> Sensor Interface) we connect logic which interleaves data from several 
> cameras.

Would be interesting to know what cameras you're going to connect and in 
which mode - Bayer / RGB / YUV, how many bits?

> First of all I want to thank you guys and specially Guennadi because 
> this V4L work is helping me getting my project a good head-start. 
> Hopefully I will contribute something back, for now I am trying to 
> understand the existing system.
> 
> I have a couple comments to date, this is the first:
> 
> Comment on nomenclature: "camera host [bus]" and "xxx_camera" drivers.
> 
> Regarding Soc-Camera Architecture as described in 
> Documentation/video4linux/soc-camera.txt, the following two 'terms' are 
> defined:
> 
> a.- "Camera host - an interface to which a camera is connected."
> and:
> b.- "Camera host bus - a connection between a camera host and a camera".
> 
> What's the idea behind defining term 'b'? I guess it has something to do 
> with an scenario where several cameras are attached to the same host 
> interface, but in that case the interface itself, that is term 'a', must 
> be some kind of bus, thus the name 'bus' in term 'b' is misleading...

(a) refers to the controller itself, to its registers if you will. (b) 
refers to the signals connecting sensors to the controller - syncs, data, 
clocks...

> Later on in the document, the sentence "[...] specify to which camera 
> host bus the sensor is connected" mixes the terms definitely, while it 
> is the sole appearance the 'bus'.

No it doesn't. There can be several sensors on a bus, but there can also 
be several busses on a system, at least theoretically. That's what is 
meant there. And those multiple busses are numbered and camera platform 
data specify to which of the busses it is connected.

> I would suggest removing the term definition for "camera host bus", 
> since it does not help the reader, at least myself!

I hope the above explanation helped to clarify the terms.

> Then, while examining drivers for this subsystem, I find several called 
> "pxa_camera", "mx3_camera", and so on. What I have understood after more 
> detailed examination is that they are actually the drivers for the host 
> bus in different SoC architectures. What I would suggest, if it is not 
> too late, is that their names reflect that, instead of suggesting they 
> are camera drivers.

Well, for pxa_camera and sh_mobile_ceu_camera it is already too late. And 
mx3_camera just follows that convention. And personally I don't find it 
much worse than any other, certainly not bad enough to rename them:-)

> Please don't take me wrong, this SoC-Camera thing is a great job! V4L 
> seems awfully complex and it must have been hard to integrate the 
> SoC-Camera subsystem. I am just commenting from the point of view of a 
> newcomer who has the privilege of analyzing the architecture at a stage 
> where things are pretty developed.
> 
> And I have a question about the use of "platform device" kernel concept 
> within SoC-camera drivers. As far as I understand, it is just used to be 
> able to share some drivers among different 'platforms'. Is that all? 

It is there to be able to configure a driver for a specific platform. For 
example, on one PXA270 board a sensor can be connected to the SoC using 
all 10 data lines, on another board only 8 lines can be used. That's the 
sort of things that you specify in platform data.

> Because I am finding it easier to start off writing a (simple and) 
> specific driver which later I could "platform-ize", if I ever want to 
> enable "the same code in several platforms".

Well, it is both I guess. It is best if while developing your software you 
recognise immediately which parts are platform specific and can be 
implemented differently on different boards and you provide a platform 
binding to configure those options. On the other hand, it does happen (at 
least to me), that some things that are platform-specific get overseen and 
you have to extract them later, or otherwise things that you make 
configurable in platform data turn out to be constant. So, it is best to 
do everything right from the first time, of course:-)

> Finally, while caring of the I2C stuff in my design I have found some 
> I2C 'magic' within V4L API, but I am not quite sure yet. I personally 
> prefer to keep them apart V4L and I2C, let my camera driver care of the 
> way it communicates with its hardware... How is that a sin against V4L 
> bible? :-)

What exactly do you mean here?

> Again, thank you guys for the great job in V4L!

Thanks for using it. As usual, patches are welcome. Especially patches to 
the documentation:-) It will have to be updated now as we extended the API 
a bit, but improvements to the style or the contents are gladly accepted 
as well:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
