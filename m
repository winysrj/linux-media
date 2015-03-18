Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47038 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878AbbCRNXm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 09:23:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	Yoshifumi Hosoya <yoshifumi.hosoya.wj@renesas.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux-sh list <linux-sh@vger.kernel.org>
Subject: Re: [PATCH/RFC] v4l: vsp1: Change VSP1 LIF linebuffer FIFO
Date: Wed, 18 Mar 2015 15:23:50 +0200
Message-ID: <35670369.0N4n9OXz2m@avalon>
In-Reply-To: <CAMuHMdVKmWgcSqLxfgOUFXd2mu-dacvQxLJr7xLaQ=S8Mt0gnw@mail.gmail.com>
References: <1426430018-3172-1-git-send-email-ykaneko0929@gmail.com> <CAMuHMdVKmWgcSqLxfgOUFXd2mu-dacvQxLJr7xLaQ=S8Mt0gnw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday 16 March 2015 09:06:22 Geert Uytterhoeven wrote:
> On Sun, Mar 15, 2015 at 3:33 PM, Yoshihiro Kaneko wrote:
> > From: Yoshifumi Hosoya <yoshifumi.hosoya.wj@renesas.com>
> > 
> > Change to VSPD hardware recommended value.
> > Purpose is highest pixel clock without underruns.
> > In the default R-Car Linux BSP config this value is
> > wrong and therefore there are many underruns.
> > 
> > Here are the original settings:
> > HBTH = 1300 (VSPD stops when 1300 pixels are buffered)
> > LBTH = 200 (VSPD resumes when buffer level has decreased
> >             below 200 pixels)
> > 
> > The display underruns can be eliminated
> > by applying the following settings:
> > HBTH = 1504
> > LBTH = 1248
> > 
> > --- a/drivers/media/platform/vsp1/vsp1_lif.c
> > +++ b/drivers/media/platform/vsp1/vsp1_lif.c
> > @@ -44,9 +44,9 @@ static int lif_s_stream(struct v4l2_subdev *subdev, int
> > enable)
> >  {
> >         const struct v4l2_mbus_framefmt *format;
> >         struct vsp1_lif *lif = to_lif(subdev);
> > -       unsigned int hbth = 1300;
> > -       unsigned int obth = 400;
> > -       unsigned int lbth = 200;
> > +       unsigned int hbth = 1536;
> > +       unsigned int obth = 128;
> > +       unsigned int lbth = 1520;
> 
> These values don't match the patch description?

Indeed. And where do these values come from ? A 16 bytes hysteresis is very 
small, the VSP1 will constantly start and stop. Isn't that bad from a power 
consumption point of view ?

> BTW, what's the significance of changing obth?

-- 
Regards,

Laurent Pinchart

