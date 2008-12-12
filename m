Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBCBkett028982
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 06:46:40 -0500
Received: from web32104.mail.mud.yahoo.com (web32104.mail.mud.yahoo.com
	[68.142.207.118])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBCBkOQE024228
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 06:46:24 -0500
Date: Fri, 12 Dec 2008 03:46:23 -0800 (PST)
From: Agustin <gatoguan-os@yahoo.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0812112026560.8782@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <577793.93046.qm@web32104.mail.mud.yahoo.com>
Content-Transfer-Encoding: 8bit
Cc: video4linux list <video4linux-list@redhat.com>
Subject: Re: Soc-Camera architecture and nomenclature, and I2C in V4L
Reply-To: gatoguan-os@yahoo.com
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

(I hope this one makes its way to the list, seems that I used the wrong from-address in the original...)

Hi Guennadi, find my answer inline...

--- On Tue, 11/12/08, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Hi Agustin,
> 
> On Thu, 11 Dec 2008, Agustin Ferrin Pozuelo wrote:
> 
> > Hello all,
> > 
> > I am developing a synchronous camera array based on i.MX31
> > architecture and using Guennadi's current patches, as posted
> > on this list (thanks!). 
> > Hardware is based on on a phyCORE-i.MX31, to whose camera bus
> > (CMOS Sensor Interface) we connect logic which interleaves data
> > from several cameras.
> 
> Would be interesting to know what cameras you're going
> to connect and in which mode - Bayer / RGB / YUV, how many bits?

Absolutely. Right now I am connecting 6 MT9P031, the monochrome type, with 12 bits ADC so I think the right format would be 'Y16'.

Later on I plan to use the complete bus width in the i.MX31 (16 or 15 bit?) as 'raw' data, in order to pack pixels and get higher data rate at the same clock.

For multiplexing I2C I have a 4-channel I2C switch 'PCA9546A'. This is required as the MT9P031 can only choose among 2 I2C address (an improvement over previous models, insufficient for me though. 

> (a) refers to the controller itself, to its registers if
> you will. (b) refers to the signals connecting sensors to the
> controller - syncs, data, clocks...

I see the use and meaning of (a), regarding (b) I have the feeling that it is something internal to SoC-Camera implementation, as I have not recognized it during the (unfinished) development of my SoC-Camera driver.

> > Later on in the document, the sentence "[...] specify to which camera 
> > host bus the sensor is connected" mixes the terms definitely, while it 
> > is the sole appearance the 'bus'.
> 
> No it doesn't. There can be several sensors on a bus, but there can
> also be several busses on a system, at least theoretically.
> That's what is meant there. And those multiple busses are numbered and
> camera platform data specify to which of the busses it is connected.

Yeah, I meant that the document could be more clear, but I will rather propose a correction.

> > I would suggest removing the term [...]
> 
> I hope the above explanation helped to clarify the terms.
> 
> > Then, while examining drivers for this subsystem, I find several
> > called "pxa_camera", "mx3_camera", and so on. [...]
> 
> Well, for pxa_camera and sh_mobile_ceu_camera it is already
> too late. And mx3_camera just follows that convention. And personally I
> don't find it much worse than any other, certainly not bad enough to
> rename them :-)

All right, I recognize here the power of "de facto" :-).

> > [...]
> > And I have a question about the use of "platform device" kernel
> > concept within SoC-camera drivers. As far as I understand, it
> > is just used to be able to share some drivers among different
> > 'platforms'. Is that all? 
> 
> It is there to be able to configure a driver for a specific
> platform. For example, on one PXA270 board a sensor can be connected
> to the SoC using all 10 data lines, on another board only 8 lines can
> be used. That's the sort of things that you specify in platform data.

OK.
 
> > Because I am finding it easier to start off writing a (simple and) 
> > specific driver [...]
>
> Well, it is both I guess. [...] it is best to 
> do everything right from the first time, of course :-)

Of course, when you are not in a deadline crunch as I am today :-). I am not doing any complete driver at the moment, just getting what I need for testing hardware, optics, etc. which are a big task in my project. Later on it will take some rework to provide a separate driver for the sensors and the I2C mux, and have them integrated seamlessly into V4L and I2C stacks, something slightly away from my current knowledge of both systems.

> > Finally, while caring of the I2C stuff in my design I have found some 
> > I2C 'magic' within V4L API, but I am not quite sure yet. I personally 
> > prefer to keep them apart V4L and I2C, let my camera driver care of
> > the way it communicates with its hardware... How is that a sin against
> > V4L bible? :-)
> 
> What exactly do you mean here?

I mean things like this I see in mt9m001 driver:

static int mt9m001_get_chip_id(struct soc_camera_device *icd,
			       struct v4l2_chip_ident *id)
{
	if (id->match_type != V4L2_CHIP_MATCH_I2C_ADDR)
		return -EINVAL;
[...]
}

Where V4L seems to be caring about I2C somehow behind the scenes. And in my case I need full control over what's going on in I2C, as I have something there in the middle (an I2C switch!).

I know there is a better way to integrate the I2C switch, I just don't have time now to get to implement a transparent I2C switch driver, since I don't even know where to start from!

> > Again, thank you guys for the great job in V4L!
> 
> Thanks for using it. As usual, patches are welcome. Especially patches
> to the documentation :-) It will have to be updated now as we extended
> the API a bit, but improvements to the style or the contents are gladly
> accepted as well:-)

I guess I must, now.

Regards,
--Agustín.

--
Agustin Ferrin Pozuelo
Embedded Systems Consultant
http://embedded.ferrin.org/
Tel. +34 610502587


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
