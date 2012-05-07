Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:39914 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932337Ab2EGV2l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2012 17:28:41 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Antti Palosaari <crope@iki.fi>,
	Thomas Mair <thomas.mair86@googlemail.com>
Subject: Re: [PATCH v3 1/3] Modified RTL28xxU driver to work with RTL2832
Date: Mon, 7 May 2012 23:28:34 +0200
Cc: linux-media@vger.kernel.org
References: <CAKZ=SG9U48d=eE3avccR-Auao5UMo0OANw8KKb=MP1XPtkHwmg@mail.gmail.com> <4FA8168E.3040807@googlemail.com> <4FA82244.9020804@iki.fi>
In-Reply-To: <4FA82244.9020804@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205072328.34261.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, 7. Mai 2012 schrieb Antti Palosaari:
> On 07.05.2012 21:38, Thomas Mair wrote:
> > On 07.05.2012 09:59, Antti Palosaari wrote:
> >>> @@ -330,12 +335,12 @@ static int rtl2831u_frontend_attach(struct
> >>> dvb_usb_adapter *adap)
> >>> 
> >>>        /* check QT1010 ID(?) register; reg=0f val=2c */
> >>>        ret = rtl28xxu_ctrl_msg(adap->dev,&req_qt1010);
> >>>        if (ret == 0&&   buf[0] == 0x2c) {
> >>> 
> >>> -        priv->tuner = TUNER_RTL2830_QT1010;
> >>> +        priv->tuner = TUNER_RTL28XX_QT1010;
> >> 
> >> The idea why I named it as a TUNER_RTL2830_QT1010 was to map RTL2830 and
> >> given tuner. It could be nice to identify used demod/tuner combination
> >> in some cases if there will even be such combination same tuner used
> >> for multiple RTL28XXU chips.
> > 
> > Ok. Should we use the TUNER_RTL2830/TUNER_RTL2832 approach or the
> > RUNER_RTL28XX?
> 
> I vote for style example; RTL2830_QT1010 versus RTL2832_QT1010, just in
> case same tuner could be used for multiple configurations.
> 
> But it is not big issue for RTL2830 as it supports only 3 tuners
> currently - and there will not be likely any new. But there is some
> other RTL28XXU chips, like DVB-C model and etc.
> 

Antti, Thomas,

I don't understand why it should be benefitial to distinguish between e.g. the 
qt1010 connected to the RTL2830 or connected to the RTL2832. After all, the 
demodulator knows which type it is, so there is no need to keep the 
combination demodulator_tuner. And I find it rather confusing to have the same 
tuner defined for either demod.

> >> It is ~same function that existing one but without LED GPIO. Hmmm, dunno
> >> what to do. Maybe it is OK still as switching "random" GPIOs during
> >> streaming control is not good idea.
> > 
> > I know. I had the same thougths and could not come up with a more elegant
> > idea. Maybe here the TUNER_RTL2832 definition could be used. But that is
> > too not the ideal solution I guess.
> 
> I dont even care if whole LED GPIO is removed. It is not needed at all
> and I even suspect it is not on same GPIO for all RTL2831U devices... Do
> what you want - leave it as you already did.
> 
> >> This looks weird as you write demod register. Is that really needed?
> >> 
> >> If you has some problems I suspect those are coming from the fact page
> >> cached by the driver isdifferent than page used by chip. Likely demod
> >> is reseted and page is 0 after that.
> >> 
> >> If you really have seen some problems then set page 0 in demod sleep. Or
> >> set page directly to that driver priv.
> > 
> > I'll check that.
> > 
> >>> +#define RTL28XXU_TUNERS_H
> >>> +
> >>> +enum rtl28xxu_tuner {
> >>> +       TUNER_NONE,
> >>> +       TUNER_RTL28XX_QT1010,
> >>> +       TUNER_RTL28XX_MT2060,
> >>> +       TUNER_RTL28XX_MT2266,
> >>> +       TUNER_RTL28XX_MT2063,
> >>> +       TUNER_RTL28XX_MAX3543,
> >>> +       TUNER_RTL28XX_TUA9001,
> >>> +       TUNER_RTL28XX_MXL5005S,
> >>> +       TUNER_RTL28XX_MXL5007T,
> >>> +       TUNER_RTL28XX_FC2580,
> >>> +       TUNER_RTL28XX_FC0012,
> >>> +       TUNER_RTL28XX_FC0013,
> >>> +       TUNER_RTL28XX_E4000,
> >>> +       TUNER_RTL28XX_TDA18272,
> >>> +};
> >>> +
> >>> +#endif
> >> 
> >> I don't see it good idea to export tuners from the DVB-USB-driver to the
> >> demodulator. Demod drivers should be independent. For the other
> >> direction it is OK, I mean you can add tuners for demod config
> >> (rtl2832.h).
> > 
> > Ok. So the definitions of the tuners would go into the rtl2830.h and
> > rtl2832.h.
> 
> Put those to the demod as a af9013 and af9033 for example has. rtl2830.h
> does not need to know tuner at all, not need to add.
> 

what about renaming the header file to rtl283x_tuners.h, then it would be 
clearer that the tuners are not defined in the USB driver, but rather as part 
of all demod drivers available (ignore for a moment the rtl2840, which doesn't 
fit into the proposed naming scheme)?

> >> After all, you have done rather much changes. Even such changes that are
> >> not relevant for the RTL2832 support. One patch per one change is the
> >> rule. Also that patch serie is wrong order, it will break compilation
> >> for example very bad when git bisect is taken. It should be done in
> >> order first tuner or demod driver then DVB-USB-driver.
> > 
> > Sorry for the inconsistent patches. I will go over my changes again and
> > split them into smaller chunks, trying to keep the changes to a minimum.
> > That includes to change the order of the patches to tuner, demod and
> > finally dvb-usb driver. Thanks for all the comments. They really help me
> > getting the driver nice and neat. I will probably not be able to do the
> > changes before next weekend.
> 
> regards
> Antti

Regards,
Hans-Frieder

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
