Return-path: <mchehab@pedra>
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:38760 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226Ab1EREMh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 00:12:37 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: "Charlie X. Liu" <charlie@sensoray.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: "laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Date: Wed, 18 May 2011 12:10:43 +0800
Subject: RE: Audio Video synchronization for data received from a HDMI
 receiver chip
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384DF11B5D98@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384DF1137013@EAPEX1MAIL1.st.com>
	<004b01cc10c5$f85bf6c0$e913e440$@com>
	<201105122229.56642.hverkuil@xs4all.nl>
 <BANLkTi=rpQEkroia3kUqp6zUHTQk3k220Q@mail.gmail.com>
In-Reply-To: <BANLkTi=rpQEkroia3kUqp6zUHTQk3k220Q@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

(adding alsa mailing list in cc)

> On Thursday, May 12, 2011 18:59:33 Charlie X. Liu wrote:
> > Which HDMI receiver chip?
> 
> Indeed, that's my question as well :-)

We use Sil 9135 receiver chip which is provided by Silicon Image.
Please see details here: http://www.siliconimage.com/products/product.aspx?pid=109
 
> Anyway, this question comes up regularly. V4L2 provides timestamps for
> each
> frame, so that's no problem. But my understanding is that ALSA does not
> give
> you timestamps, so if there are processing delays between audio and
> video, then
> you have no way of knowing. The obvious solution is to talk to the ALSA
> people
> to see if some sort of timestamping is possible, but nobody has done
> that.

I am aware of the time stamping feature provided by V4L2, but I am also
not sure whether the same feature is supported by ALSA. I have included
alsa-mailing list also in copy of this mail. Let's see if we can get
some sort of confirmation on this from them.
 
> This is either because everyone that needs it hacks around it instead
> of trying
> to really solve it, or because it is never a problem in practice.

What should be the proper solution according to you to solve this issue.
Do we require a Audio-Video Bridge kind of utility/mechanism?

Regards,
Bhupesh

> 
> >
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org
> > [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Bhupesh
> SHARMA
> > Sent: Wednesday, May 11, 2011 10:49 PM
> > To: linux-media@vger.kernel.org
> > Cc: Laurent Pinchart; Guennadi Liakhovetski; Hans Verkuil
> > Subject: Audio Video synchronization for data received from a HDMI
> receiver
> > chip
> >
> > Hi Linux media folks,
> >
> > We are considering putting an advanced HDMI receiver chip on our SoC,
> > to allow reception of HDMI audio and video. The chip receives HDMI
> data
> > from a host like a set-up box or DVD player. It provides a video data
> > interface
> > and SPDIF/I2S audio data interface.
> >
> > We plan to support the HDMI video using the V4L2 framework and the
> HDMI
> > audio using ALSA framework.
> >
> > Now, what seems to be intriguing us is how the audio-video
> synchronization
> > will be maintained? Will a separate bridging entity required to
> ensure the
> > same
> > or whether this can be left upon a user space application like
> mplayer or
> > gstreamer.
> >
> > Also is there a existing interface between the V4L2 and ALSA
> frameworks and
> > the same
> > can be used in our design?
> >
> > Regards,
> > Bhupesh
> > ST Microelectronics
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> --
> regards
> Shiraz Hashim
