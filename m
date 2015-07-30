Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36779 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbbG3OdJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 10:33:09 -0400
Received: by wicgb10 with SMTP id gb10so246818635wic.1
        for <linux-media@vger.kernel.org>; Thu, 30 Jul 2015 07:33:08 -0700 (PDT)
Date: Thu, 30 Jul 2015 15:33:04 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Michael Ira Krufky <mkrufky@linuxtv.org>
Cc: Joe Perches <joe@perches.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	LKML <linux-kernel@vger.kernel.org>,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media <linux-media@vger.kernel.org>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 02/12] [media] dvb-pll: Add support for THOMSON DTT7546X
 tuner.
Message-ID: <20150730143304.GA22196@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
 <1435158670-7195-3-git-send-email-peter.griffin@linaro.org>
 <1435195057.9377.18.camel@perches.com>
 <20150722185811.2d718baa@recife.lan>
 <20150730094738.GD488@griffinp-ThinkPad-X1-Carbon-2nd>
 <1438250928.2677.10.camel@perches.com>
 <CAOcJUbw5hSmPdrz6rPPYU6iMBHnvOZc1p3f+4WhEYq2-XmAPVw@mail.gmail.com>
 <CAOcJUbzhL2LXro9cwazZxtH=-=FndNARi7TSsFi+DGCPP3uEdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOcJUbzhL2LXro9cwazZxtH=-=FndNARi7TSsFi+DGCPP3uEdA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Thu, 30 Jul 2015, Michael Ira Krufky wrote:

> On Thu, Jul 30, 2015 at 7:14 AM, Michael Ira Krufky <mkrufky@linuxtv.org> wrote:
> > On Thu, Jul 30, 2015 at 6:08 AM, Joe Perches <joe@perches.com> wrote:
> >> On Thu, 2015-07-30 at 10:47 +0100, Peter Griffin wrote:
> >>> Hi Mauro / Joe,
> >>>
> >>> On Wed, 22 Jul 2015, Mauro Carvalho Chehab wrote:
> >>>
> >>> > Em Wed, 24 Jun 2015 18:17:37 -0700
> >>> > Joe Perches <joe@perches.com> escreveu:
> >>> >
> >>> > > On Wed, 2015-06-24 at 16:11 +0100, Peter Griffin wrote:
> >>> > > > This is used in conjunction with the STV0367 demodulator on
> >>> > > > the STV0367-NIM-V1.0 NIM card which can be used with the STi
> >>> > > > STB SoC's.
> >>> > >
> >>> > > Barely associated to this specific patch, but for
> >>> > > dvb-pll.c, another thing that seems possible is to
> >>> > > convert the struct dvb_pll_desc uses to const and
> >>> > > change the "entries" fixed array size from 12 to []
> >>> > >
> >>> > > It'd save a couple KB overall and remove ~5KB of data.
> >>> > >
> >>> > > $ size drivers/media/dvb-frontends/dvb-pll.o*
> >>> > >    text      data     bss     dec     hex filename
> >>> > >    8520      1552    2120   12192    2fa0 drivers/media/dvb-frontends/dvb-pll.o.new
> >>> > >    5624      6363    2120   14107    371b drivers/media/dvb-frontends/dvb-pll.o.old
> >>> >
> >>> > Peter,
> >>> >
> >>> > Please add this patch on the next patch series you submit.
> >>>
> >>> Ok will do, I've added this patch with a slightly updated commit message
> >>> to my series.
> >>>
> >>> Joe - Can I add your signed-off-by?
> >>
> >> Signed-off-by: Joe Perches <joe@perches.com>
> >
> > Reviewed-by: Michael Ira Krufky <m.krufky@samsung.com>
> >
> > Joe, nice optimization - thanks for that.
> >
> > With regards to Peter's patch, is this a digital-only tuner, or is it
> > a hybrid tuner?
> >
> > The 5th byte that you send to the THOMSON DTT7546X seems to resemble
> > the 'auxiliary byte' that gets set in tuner-simple.c
> >
> > I'm not sure that dvb-pll is the right place for this tuner
> > definition, if this is the case.  Maybe this definition belongs in
> > tuner-simple instead, if the pattern matches better there.
> >
> > Mauro, can we hold off on merging Peter's patch until we resolve this?
> >
> > -Michael Ira Krufky
> 
> eek!  I mispelled my own email address.
> 
> 
> With regards to Joe's patch - I'd like to see that merged.  ...and
> here is my correctly spelled email address:
> 
> 
> Reviewed-by: Michael Ira Krufky <m.krufky@samsung.com>

Ok I will add your reviewed-by and include it in my v2.
