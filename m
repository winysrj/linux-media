Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:9138 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3I3ReL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 13:34:11 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MTY009VL8SX5A40@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Sep 2013 13:34:09 -0400 (EDT)
Date: Mon, 30 Sep 2013 14:34:04 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Michael Krufky <mkrufky@linuxtv.org>,
	=?UTF-8?B?SmnFmcOt?= Pinkava <j-pi@seznam.cz>
Cc: Gianluca Gennari <gennarone@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] [media] r820t: fix nint range check
Message-id: <20130930143404.263d4110@samsung.com>
In-reply-to: <CAOcJUbyBewvrgiuDsuOtQJP_Un9ExF+L9yqkVzLXyEq2b9xbGQ@mail.gmail.com>
References: <524804B3.9090505@seznam.cz> <524804DB.7020108@seznam.cz>
 <CAOcJUbyVx=fqHwVeM9K3SKUTk3g7vNqsWf0xokX5nO_DdQenYA@mail.gmail.com>
 <5249A9EC.7020804@seznam.cz>
 <CAOcJUbyBewvrgiuDsuOtQJP_Un9ExF+L9yqkVzLXyEq2b9xbGQ@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Sep 2013 12:46:52 -0400
Michael Krufky <mkrufky@linuxtv.org> escreveu:

> Do you have any comments on this, Mauro?
> 
> Assuming that Mauro is OK with this change, (since he is the author of
> this driver) then yes - please resubmit the patch with some
> explanation within comments inline or within the commit message.

Michael,

Please don't top post. My comments are below.

> 
> Best regards,
> 
> Mike Krufky
> 
> On Mon, Sep 30, 2013 at 12:42 PM, Jiří Pinkava <j-pi@seznam.cz> wrote:
> > Mike,
> >
> > unfortunately no documentation can be referenced except preliminary
> > version of
> > datasheet (1).This change is based on lucky guess and supported by lot of
> > testing on real hardware.
> >
> > This change add support for devices with Xtal frequency bellow 28.8MHz.

Hmm... I'm not seeing any test there checking if the frequency of the xtal
is below to 28.8 MHz. So, if this logic apples only in this case, the
patch needs to add a test for the xtal frequency.

Also, as the driver does some tests for other Raphael tuners, if this change
is known to work fine only on rt820t, please add a test there for the tuner
model too.

Except for that, I'm ok with the changes, provided that you add the
explanations about it.

> >
> > From Nint  are computed values of Ni and Si. For 28.8MHz crystal can
> > reach up to 12 / 3 (Ni / Si). Tuner supports crystals with frequencies
> > (1) 12, 16, 20, 20.48, 24, 27, 28.8, 32 MHz, but this kind of device is
> > rare to found.
> > Allowing Ni to go up to 15 instead of only 12 should be safe and for 15
> > / 3 (Ni / Si)
> > we can compute limit for Nint = max(Ni) * 4 + max(Si) + 13 = 76.
> >
> > If This is sufficient and acceptable explanation I can add some sort of
> > documentation into patch and resend it (both patches, I can prove I'm
> > right :)
> >
> > (1)
> > http://rtl-sdr.com/wp-content/uploads/2013/04/R820T_datasheet-Non_R-20111130_unlocked.pdf
> >
> >> Jiří,
> >>
> >> Do you have any documentation that supports this value change?
> >> Changing this value affects the algorithm, and we'd be happier making
> >> this change if the patch included some better description and perhaps
> >> a reference explaining why the new value is correct.
> >>
> >> Regards,
> >>
> >> Mike Krufky
> >>
> >> On Sun, Sep 29, 2013 at 6:45 AM, Jiří Pinkava <j-pi@seznam.cz> wrote:
> >>>
> >>> Use full range of VCO parameters, fixes tunning for some frequencies.
> >>> ---
> >>>  drivers/media/tuners/r820t.c | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
> >>> index 1c23666..e25c720 100644
> >>> --- a/drivers/media/tuners/r820t.c
> >>> +++ b/drivers/media/tuners/r820t.c
> >>> @@ -637,7 +637,7 @@ static int r820t_set_pll(struct r820t_priv *priv,
> >>> enum v4l2_tuner_type type,
> >>>                 vco_fra = pll_ref * 129 / 128;
> >>>         }
> >>>
> >>> -       if (nint > 63) {
> >>> +       if (nint > 76) {
> >>>                 tuner_info("No valid PLL values for %u kHz!\n", freq);
> >>>                 return -EINVAL;
> >>>         }
> >>> --
> >>> 1.8.3.2
> >>>
> >>>
> >


-- 

Cheers,
Mauro
