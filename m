Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57608
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934430AbcJFRRl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2016 13:17:41 -0400
Date: Thu, 6 Oct 2016 14:17:34 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>
Cc: Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Problem with VMAP_STACK=y
Message-ID: <20161006141734.4b2e4880@vento.lan>
In-Reply-To: <CADDKRnCV7YhD5ErkvWSL8P3adymCLqzp5OePYmGp0L=9Dt_=UA@mail.gmail.com>
References: <CADDKRnB1=-zj8apQ3vBfbxVZ8Dc4DJbD1MHynC9azNpfaZeF6Q@mail.gmail.com>
        <alpine.LRH.2.00.1610041519160.1123@gjva.wvxbf.pm>
        <CADDKRnA1qjyejvmmKQ9MuxH6Dkc7Uhwq4BSFVsOS3U-eBWP9GA@mail.gmail.com>
        <alpine.LNX.2.00.1610050925470.31629@cbobk.fhfr.pm>
        <20161005093417.6e82bd97@vdr>
        <alpine.LNX.2.00.1610050947380.31629@cbobk.fhfr.pm>
        <20161005060450.1b0f2152@vento.lan>
        <20161005182945.nkpphvd6wtk6kq7h@linuxtv.org>
        <20161005155532.682258e2@vento.lan>
        <CADDKRnCV7YhD5ErkvWSL8P3adymCLqzp5OePYmGp0L=9Dt_=UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 6 Oct 2016 10:30:15 +0200
Jörg Otte <jrg.otte@gmail.com> escreveu:

> 2016-10-05 20:55 GMT+02:00 Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> > Hi Johannes,
> >
> > Em Wed, 5 Oct 2016 20:29:45 +0200
> > Johannes Stezenbach <js@linuxtv.org> escreveu:
> >  
> >> On Wed, Oct 05, 2016 at 06:04:50AM -0300, Mauro Carvalho Chehab wrote:  
> >> >  static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
> >> >  {
> >> > -   char query[] = { CINERGYT2_EP1_GET_FIRMWARE_VERSION };
> >> > -   char state[3];
> >> > +   struct dvb_usb_device *d = adap->dev;
> >> > +   struct cinergyt2_state *st = d->priv;
> >> >     int ret;
> >> >
> >> >     adap->fe_adap[0].fe = cinergyt2_fe_attach(adap->dev);
> >> >
> >> > -   ret = dvb_usb_generic_rw(adap->dev, query, sizeof(query), state,
> >> > -                           sizeof(state), 0);  
> >>
> >> it seems to miss this:
> >>
> >>       st->data[0] = CINERGYT2_EP1_GET_FIRMWARE_VERSION;
> >>  
> >> > +   ret = dvb_usb_generic_rw(d, st->data, 1, st->data, 3, 0);
> >> >     if (ret < 0) {
> >> >             deb_rc("cinergyt2_power_ctrl() Failed to retrieve sleep "
> >> >                     "state info\n");
> >> > @@ -141,13 +147,14 @@ static int repeatable_keys[] = {
> >> >  static int cinergyt2_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
> >> >  {
> >> >     struct cinergyt2_state *st = d->priv;
> >> > -   u8 key[5] = {0, 0, 0, 0, 0}, cmd = CINERGYT2_EP1_GET_RC_EVENTS;
> >> >     int i;
> >> >
> >> >     *state = REMOTE_NO_KEY_PRESSED;
> >> >
> >> > -   dvb_usb_generic_rw(d, &cmd, 1, key, sizeof(key), 0);
> >> > -   if (key[4] == 0xff) {
> >> > +   st->data[0] = CINERGYT2_EP1_SLEEP_MODE;  
> >>
> >> should probably be
> >>
> >>       st->data[0] = CINERGYT2_EP1_GET_RC_EVENTS;
> >>  
> >> > +
> >> > +   dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);  
> >>
> >>
> >> HTH,
> >> Johannes  
> >
> >
> > Thanks for the review! Yeah, you're right: both firmware and remote
> > controller logic would be broken without the above fixes.
> >
> > Just sent a version 2 of this patch to the ML with the above fixes.
> >
> > Regards,
> > Mauro  
> 
> Applied V2 of the patch. Unfortunately no progress.
> No video, no error messages.

I can't see any other obvious error on the conversion. You could try
to enable debug options at DVB core/dvb-usb and/or add some printk's to
the driver and see what's happening.


Thanks,
Mauro
