Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:49351 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbbCKOFx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 10:05:53 -0400
Date: Wed, 11 Mar 2015 15:05:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?UTF-8?B?QXloYW4gS8Ocw4fDnEtNQU7EsFNB?=
	<ayhan.kucukmanisa@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Aptina MT9V024
In-Reply-To: <CAF-Najso-kd3dWNMQvPpnWKFeohsYQSjHLLbS8VXonQ1FnH9LA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1503111504070.4181@axis700.grange>
References: <CAF-NajsBJGtC2RCgzyX6=f8BkYtzFEcLu4q9XOhiE+Lgd+ux+Q@mail.gmail.com>
 <Pine.LNX.4.64.1503082133240.7485@axis700.grange>
 <CAF-NajvjMgZ9X8w=vZVTwVd3FQr4NKMU3Z6pv1d8Y=8a2cdK5A@mail.gmail.com>
 <CAF-Najso-kd3dWNMQvPpnWKFeohsYQSjHLLbS8VXonQ1FnH9LA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, 11 Mar 2015, Ayhan K�~\�~G�~\KMANİSA wrote:

> Hi Guennadi,
> 
> My sensor Color filter array is RGB Bayer. Can i get image values and save
> in any image format using v4l2?

The kernel v4l2 doesn't do any pixel format conversions. I'm not sure, but 
check libv4l, it probably supports Bayer format conversions in the 
meantime. You just have to pick up your correct colour order. gstreamer 
might be able to do that too.

Thanks
Guennadi

> 
> Thanks, regards.
> 
> ---------------------------------------------------------------------------------------------------
> Arş. Gör. Ayhan KÜÇÜKMANİSA
> Kocaeli Üniversitesi, Gömülü Sistemler ve Görüntüleme Sistemleri
> Laboratuvarı
> 
> Res. Asst. Ayhan KÜÇÜKMANİSA
> Kocaeli University, Laboratory of Embedded and Vision Systems
> 
> 2015-03-09 17:06 GMT+02:00 Ayhan KÜÇÜKMANİSA <ayhan.kucukmanisa@gmail.com>:
> 
> > Hi Guennadi,
> >
> > Thanks for your quick reply. I solved my width problem.  In the attachment
> > test pattern and normal camera image that i can get now. I think problem
> > yuv / bayer conversion problem that you said before.
> >
> > I get images using mplayer like that : mplayer tv:// -tv
> > driver=v4l2:width=752:height=480:device=/dev/video0:fps=10 -vo jpeg
> > And using mpeg-streamer like that : sudo ./mjpg_streamer -i
> > "/usr/local/lib/input_uvc.so -y -d /dev/video0 -r 752x480" -o
> > "/usr/local/lib/output_http.so -w ./www -p 5000"
> > now im trying to get images with code using v4l2(using derek molloy code
> > on his web page). In the attachment there is my code. But i always get this
> > error : Error 22, Invalid argument.
> > I tried to change "fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB24". But i
> > couldnt solve problem.
> >
> >
> > [image: Satır içi resim 1]
> >
> >
> >
> > ---------------------------------------------------------------------------------------------------
> > Arş. Gör. Ayhan KÜÇÜKMANİSA
> > Kocaeli Üniversitesi, Gömülü Sistemler ve Görüntüleme Sistemleri
> > Laboratuvarı
> >
> > Res. Asst. Ayhan KÜÇÜKMANİSA
> > Kocaeli University, Laboratory of Embedded and Vision Systems
> >
> > 2015-03-08 22:38 GMT+02:00 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> >
> >> Hi,
> >>
> >> On Sun, 8 Mar 2015, Ayhan KÃ~\Ã~GÃ~\KMANÄ°SA wrote:
> >>
> >> > Hi Guennadi,
> >> >
> >> > Previously i asked you a problem about accesing camera i2c bus. I solved
> >> > camera i2c detect problem. Now i can get images using mplayer and v4l2
> >> lib.
> >> > But i couldnt get right images. I try to get test pattern but when i get
> >> > image that in attachment. Could you give an advice about this problem?
> >>
> >> The first problem, that appears in your image is geometry. There seem to
> >> be more pixels in the image than you think there are. Also, I don't know
> >> what your test image should look like, but I doubt it should be that pink.
> >> So, looks like you also wrongly decode pixels. Maybe these two problems
> >> are related - your bytes-per-pixel is wrong, so the width is wrong and the
> >> pixel format too.
> >>
> >> Thanks
> >> Guennadi
> >>
> >> >
> >> > Thanks.
> >> >
> >> >
> >> >
> >> >
> >> ---------------------------------------------------------------------------------------------------
> >> > ArÅ . GÃ¶r. Ayhan KÃ Ã Ã KMANÄ°SA
> >> > Kocaeli Ã niversitesi, GÃ¶mÃŒlÃŒ Sistemler ve GÃ¶rÃŒntÃŒleme Sistemleri
> >> > LaboratuvarÄ±
> >> >
> >> > Res. Asst. Ayhan KÃ Ã Ã KMANÄ°SA
> >> > Kocaeli University, Laboratory of Embedded and Vision Systems
> >> >
> >>
> >
> >
> 
