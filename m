Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:33321 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbbC2NMC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2015 09:12:02 -0400
MIME-Version: 1.0
In-Reply-To: <35670369.0N4n9OXz2m@avalon>
References: <1426430018-3172-1-git-send-email-ykaneko0929@gmail.com>
	<CAMuHMdVKmWgcSqLxfgOUFXd2mu-dacvQxLJr7xLaQ=S8Mt0gnw@mail.gmail.com>
	<35670369.0N4n9OXz2m@avalon>
Date: Sun, 29 Mar 2015 22:12:01 +0900
Message-ID: <CAH1o70KBNS9ns4MTf8d2TQ5LO97sQFmitWCceSHbn8U5VFQWhA@mail.gmail.com>
Subject: Re: [PATCH/RFC] v4l: vsp1: Change VSP1 LIF linebuffer FIFO
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Yoshifumi Hosoya <yoshifumi.hosoya.wj@renesas.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert, Hi Laurent,

Thanks for your review. There do indeed seem to be some problems with
this patch.
I'm happy get some feedback from the BSP team if you think it is
worthwhile. Else I suggest we simply drop this issue for now.

Thanks,
Kaneko

2015-03-18 22:23 GMT+09:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hello,
>
> On Monday 16 March 2015 09:06:22 Geert Uytterhoeven wrote:
>> On Sun, Mar 15, 2015 at 3:33 PM, Yoshihiro Kaneko wrote:
>> > From: Yoshifumi Hosoya <yoshifumi.hosoya.wj@renesas.com>
>> >
>> > Change to VSPD hardware recommended value.
>> > Purpose is highest pixel clock without underruns.
>> > In the default R-Car Linux BSP config this value is
>> > wrong and therefore there are many underruns.
>> >
>> > Here are the original settings:
>> > HBTH = 1300 (VSPD stops when 1300 pixels are buffered)
>> > LBTH = 200 (VSPD resumes when buffer level has decreased
>> >             below 200 pixels)
>> >
>> > The display underruns can be eliminated
>> > by applying the following settings:
>> > HBTH = 1504
>> > LBTH = 1248
>> >
>> > --- a/drivers/media/platform/vsp1/vsp1_lif.c
>> > +++ b/drivers/media/platform/vsp1/vsp1_lif.c
>> > @@ -44,9 +44,9 @@ static int lif_s_stream(struct v4l2_subdev *subdev, int
>> > enable)
>> >  {
>> >         const struct v4l2_mbus_framefmt *format;
>> >         struct vsp1_lif *lif = to_lif(subdev);
>> > -       unsigned int hbth = 1300;
>> > -       unsigned int obth = 400;
>> > -       unsigned int lbth = 200;
>> > +       unsigned int hbth = 1536;
>> > +       unsigned int obth = 128;
>> > +       unsigned int lbth = 1520;
>>
>> These values don't match the patch description?
>
> Indeed. And where do these values come from ? A 16 bytes hysteresis is very
> small, the VSP1 will constantly start and stop. Isn't that bad from a power
> consumption point of view ?
>
>> BTW, what's the significance of changing obth?
>
> --
> Regards,
>
> Laurent Pinchart
>
