Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5BInq75018516
	for <video4linux-list@redhat.com>; Wed, 11 Jun 2008 14:49:52 -0400
Received: from smtp-vbr15.xs4all.nl (smtp-vbr15.xs4all.nl [194.109.24.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5BIndCm028549
	for <video4linux-list@redhat.com>; Wed, 11 Jun 2008 14:49:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: mschimek@gmx.at
Date: Wed, 11 Jun 2008 20:49:36 +0200
References: <200805262326.30501.hverkuil@xs4all.nl>
	<200805270900.20790.hverkuil@xs4all.nl>
	<1212791383.17465.742.camel@localhost>
In-Reply-To: <1212791383.17465.742.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200806112049.36291.hverkuil@xs4all.nl>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Need VIDIOC_CROPCAP clarification
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

On Saturday 07 June 2008 00:29:43 Michael Schimek wrote:
> On Tue, 2008-05-27 at 09:00 +0200, Hans Verkuil wrote:
> > Here's an old article I found detailing the design of pixelaspect,
> > it makes me wonder if what bttv does isn't wrong and pixelaspect is
> > really a pixel aspect.
>
> After all the time I spent on the stuff it better be right. ;)
>
> Well as the spec says, pixelaspect is the aspect ratio (y/x) of
> pixels sampled by the driver. For example in PAL mode bttv samples
> luminance pixels at four times the PAL-BG color carrier frequency:
> 35468950 / 2 Hz. The line frequency is 15625 Hz so one gets 1135.0064
> pixels/line. That's what v4l2_crop counts, pixels as sampled by the
> hardware.

I'm sorry, but it remains a headache inducing description in the spec. 
Put yourself in the place of an application writer. You want to do 
this:

1) how do I scale the image?

2) how do I crop the image?

3) what is the pixel aspect of the pixels that I capture?

I'll try to answer this based on my understanding of the spec.

1) This one is fairly easy: using G/S_FMT you can select the new width 
and height. The max width and height are specified by CROPCAP, 
bounds.width and bounds.height. The default initial width and height 
are defrect.width and defrect.height.

Note: bounds and defrect are very strange in that width and height have 
pixels as units and top and left have their own units (although in 
practice it also uses pixels as the unit). This is not at all obvious 
from the spec! Also, is there any reason why we shouldn't uses pixels 
as well as the top/left unit? See more about this below.

2) You change c.width and c.height (pixel units) to crop to part of the 
image, and you change c.left and c.top ('analog units') to move the 
origin. There doesn't seem to be a way to know what the maximum left 
and top values are (bounds only specifies the minimum). This would be 
possible if left and top also uses pixel units, then bounds really 
specifies the max frame you can capture. Note that there also does not 
seem to be any information about the relationship between the top/left 
units and the width/height pixels, so how can you ever hope to reliably 
crop a 300 by 200 pixel window that's 10 pixels to the left and 10 
pixels down from the default capture window?

Suppose you have a black border on the left hand side that's 6 pixels 
wide. If you want to crop that, how would you do that? If c.left is in 
pixels, then you just set that to 6 (and subtract 6 from c.width). 
Since c.left has it's own units, how do I know what to put in c.left?

Note that examples 1-12 and 1-13 in the spec clearly assume that the 
crop units are pixels! And I think all drivers we have do the same.

3) CROPCAP returns the pixelaspect of the pixels you capture when you 
use defrect.width/height as the width and height with S_FMT and 
defrect.width/height with S_CROP. Non-standard cropping and scaling 
means that you will have to calculate the new pixelaspect by taking 
that into account. This also does not take things like anamorphic 
widescreen into account, you have to detect that yourself and adjust 
accordingly.

Does all this make any sense? 

It's really this sentence that makes things so hard: 'the driver writer 
is free to choose origin and units of the coordinate system in the 
analog domain.' If that was replaced by: 'the driver writer is free to 
choose the origin of the coordinate system.' then it would make a lot 
more sense.

Regards,

	Hans

> The industry standard sampling rate to get PAL square pixels is 14.75
> MHz, giving 944 samples/line. Therefore cropcap.pixelaspect is 1135 /
> 944. In human terms the pixels are too narrow. On a square pixel
> display like a computer monitor the unscaled image looks stretched.
>
> Square pixel PAL images have 576 * 4 / 3 = 768 pixels per line. To
> produce 768 square pixels the bttv driver must sample 768 * 1135 /
> 944 = 923.4 pixels and scale down to 768. (The driver actually
> captures 924x576 pixels since times immemorial, so cropcap.defrect is
> 924x576.)
>
> As Daniel wrote, another way to view this is that the active portion
> of the video is about 52 탎 wide. At 12.27 MHz (for NTSC square
> pixels) one would sample or "crop" 638 pixels over this period. At
> 13.5 MHz (BT.601) 702 pixels, at 14.75 MHz (for PAL square pixels)
> 767 pixels, and at 17.73 MHz (bttv) 922.2 pixels.
>
> The pixel aspect is (actual sampling rate) / (square pixel sampling
> rate). The examples in the spec are: 54 / 59 = 13.5 MHz / 14.75 MHz
> (PAL BT.601) and 11 / 10 = 13.5 MHz / 12 3/11 MHz (NTSC BT.601).
>
> Of course there's no guarantee defrect will cover exactly 52 탎. An
> older chip may always capture 720 pixels at 13.5 MHz with no support
> for scaling or cropping whatsoever. But since all video capture
> drivers are supposed to support VIDIOC_CROPCAP, apps can still
> determine the pixel aspect and display captured images correctly.
>
> > [cropcap] does not take into account anamorphic 16:9 transmissions.
>
> It's true cropcap assumes the pixel aspect (or sampling rate) will
> never change. PAL/NTSC/SECAM has a 4:3 picture aspect. Apps must find
> out by other means, perhaps WSS, if a 16:9 signal is transmitted
> instead, and ask the driver to scale the images accordingly or do
> that themselves.
>
> But for a webcam with an anamorphic lens it would be perfectly
> correct to return e.g. defrect=640x480 and pixelaspect=3/4.
>
> > The height of defrect should correspond to the active picture area.
> > In case of 625-line PAL/SECAM it should represent 576 lines.
> > It follows that
> > width = defrect.height * 4/3
> >         * v4l2_cropcap.pixelaspect.numerator
> >         / v4l2_cropcap.pixelaspect.denominator;
> > covers 52탎 of a 64탎 PAL/SECAM line.
> > 52탎 equals 702 BT.601 pixels.
>
> Not quite. Let's say defrect is 720x576 and pixelaspect is 54/59
> (PAL/SECAM BT.601).
>
> If you want to capture exactly what the driver samples (no scaling)
> just call VIDIOC_S_FMT width cropcap.defrect as the image size. From
> our hypothetical BT.601 driver you'd get 720x576 images (no square
> pixels) with a black bar at the left and right edge because BT.601
> overscans the picture: 720 / 13.5 MHz = 53.3 탎.
>
> To get the same area of the picture with square pixels you request:
>
> image width = defrect.width / pixelaspect;
> image height = defrect.height;
>
> Now the images will be 720 / 54 * 59 = 786 square pixels wide. That's
> more than 768 because you're still overscanning. What you really need
> is:
>
> image width = 768;
> image height = 576;
>
> crop width = round (image width * pixelaspect);
> crop height = defrect.height;
> crop left = defrect.left + (defrect.width - crop width) / 2;
> crop top = defrect.top;
>
> Now the images will be 768 pixels wide, scaled up from 768 * 54 / 59
> = 703 sampled pixels, which cover 703 / 13.5 MHz = 52.0 탎 centered
> over the active picture. With the same code the bttv driver with
> defrect 924x576 and pixelaspect 1135/944 would give you 768x576
> square pixel images covering 923 / 17.73 MHz = 52.0 탎 centered.
>
> But a driver can return any defrect.height and the picture aspect is
> not necessarily 4:3. Imagine a webcam with a 1280x720 sensor.
>
> image width = 768;
> image height = 576;
>
> crop width = round (image width * pixelaspect
>                     * defrect.height / image height);
> crop height = defrect.height;
> crop left = defrect.left + (defrect.width - crop width) / 2;
> crop top = defrect.top;
>
> Now let's say defrect is 720x480 and pixelaspect is 11/10 (NTSC
> BT.601). Result: The driver scales up from 704x480 to 768x576 square
> pixels covering 704 / 13.5 MHz = 52.1 탎 centered.
>
> Let's say defrect is 1280x720 and pixelaspect is 1/1 (16:9 camera).
> Result: It scales images down from 960x720 to 768x576, cutting off
> 160 pixels left and right.
>
> Let's say defrect is 640x480 and pixelaspect is 3/4 (camera with
> anamorphic lens). Result: It scales images up from 480x480 to
> 768x576, cutting off 80 pixels left and right.
>
> The relation between picture aspect and pixel aspect is:
> picture aspect = defrect.width / defrect.height / pixelaspect;
> E.g. 16/9 = 640 / 480 / (3/4).
>
> > The defrect.left+defrect.width/2 should be the center of the active
> > picture area.
>
> That's required by the spec, also in the vertical direction. (Well,
> duh. What else would drivers capture by default.)
>
> > Many people use 480 lines instead of 486 lines for the active
> > region in NTSC and if there are inconsistencies in drivers,
> > application may degrade the picture by scaling. Therefore it would
> > be nice if at least analog vertical resolution was mapped 1:1 to
> > cropping regions per standard. Not doing so would make sense only
> > if there was a tv standard where the image is drawn column-wise.
>
> Horizontally the bttv driver's v4l2_crop counts luminance samples
> starting at 0H, which is an obvious choice to me. Don't know about
> saa7134.
>
> Vertically the bttv and saa7134 driver count frame lines. Field lines
> would be admissible too, but considering these devices can capture
> interlaced images it makes sense to return defrect.height 480 and
> 576. An odd cropping height is not possible though.
>
> The vertical origin is given by counting ITU-R line numbers as in the
> VBI API, which simplifies things quite a bit. Specifically these
> drivers count ITU-R line numbers of the first field times two, so
> bttv's defrect.top is 23 * 2.
>
> It may be nice if other drivers followed this convention, but apps
> cannot blindly rely on that. (They can check the driver name if exact
> cropping is important.) The cropping units are undefined by the spec
> because samples, microseconds or scan lines depend on the video
> standard and make no sense for a webcam.
>
> Michael



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
