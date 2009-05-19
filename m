Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110810.mail.gq1.yahoo.com ([67.195.13.233]:44470 "HELO
	web110810.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750987AbZESRJE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 13:09:04 -0400
Message-ID: <853068.61996.qm@web110810.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 10:09:05 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: Re: [PATCH] [09051_54] Siano: remove obsolete sms_board_setup
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




--- On Tue, 5/19/09, Michael Krufky <mkrufky@linuxtv.org> wrote:

> From: Michael Krufky <mkrufky@linuxtv.org>
> Subject: Re: [PATCH] [09051_54] Siano: remove obsolete sms_board_setup
> To: "Uri Shkolnik" <urishk@yahoo.com>
> Cc: "linux-media" <linux-media@vger.kernel.org>, "Mauro Carvalho Chehab" <mchehab@infradead.org>
> Date: Tuesday, May 19, 2009, 8:02 PM
> On Tue, May 19, 2009 at 12:57 PM, Uri
> Shkolnik <urishk@yahoo.com>
> wrote:
> >
> >
> >
> > --- On Tue, 5/19/09, Michael Krufky <mkrufky@linuxtv.org>
> wrote:
> >
> >> From: Michael Krufky <mkrufky@linuxtv.org>
> >> Subject: Re: [PATCH] [09051_54] Siano: remove
> obsolete sms_board_setup
> >> To: "Uri Shkolnik" <urishk@yahoo.com>
> >> Cc: "LinuxML" <linux-media@vger.kernel.org>,
> "Mauro Carvalho Chehab" <mchehab@infradead.org>
> >> Date: Tuesday, May 19, 2009, 7:31 PM
> >> On Tue, May 19, 2009 at 12:15 PM, Uri
> >> Shkolnik <urishk@yahoo.com>
> >> wrote:
> >> >
> >> > # HG changeset patch
> >> > # User Uri Shkolnik <uris@siano-ms.com>
> >> > # Date 1242749967 -10800
> >> > # Node ID
> 0296b0c436d6deba48c710cfb510988267cea057
> >> > # Parent
>  dfcfb90798d3a27cb174019b17fffdee9ce7b2b9
> >> > [09051_54] Siano: remove obsolete
> sms_board_setup
> >> >
> >> > From: Uri Shkolnik <uris@siano-ms.com>
> >> >
> >> > Remove the target specific sms_board_setup
> from
> >> smsdvb. This
> >> > is handled now via smsdvb and sms-cards
> events.
> >> >
> >> > Priority: normal
> >> >
> >> > Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
> >> >
> >> > diff -r dfcfb90798d3 -r 0296b0c436d6
> >> linux/drivers/media/dvb/siano/sms-cards.c
> >> > ---
> a/linux/drivers/media/dvb/siano/sms-cards.c Tue
> >> May 19 19:05:02 2009 +0300
> >> > +++
> b/linux/drivers/media/dvb/siano/sms-cards.c Tue
> >> May 19 19:19:27 2009 +0300
> >> > @@ -303,28 +303,6 @@ static int
> sms_set_gpio(struct
> >> smscore_d
> >> >        return smscore_set_gpio(coredev,
> gpio,
> >> lvl);
> >> >  }
> >> >
> >> > -int sms_board_setup(struct smscore_device_t
> >> *coredev)
> >> > -{
> >> > -       int board_id =
> >> smscore_get_board_id(coredev);
> >> > -       struct sms_board *board =
> >> sms_get_board(board_id);
> >> > -
> >> > -       switch (board_id) {
> >> > -       case
> SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
> >> > -               /* turn off all LEDs
> */
> >> > -               sms_set_gpio(coredev,
> >> board->led_power, 0);
> >> > -               sms_set_gpio(coredev,
> >> board->led_hi, 0);
> >> > -               sms_set_gpio(coredev,
> >> board->led_lo, 0);
> >> > -               break;
> >> > -       case
> >> SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
> >> > -       case
> >> SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
> >> > -               /* turn off LNA */
> >> > -               sms_set_gpio(coredev,
> >> board->lna_ctrl, 0);
> >> > -               break;
> >> > -       }
> >> > -       return 0;
> >> > -}
> >> > -EXPORT_SYMBOL_GPL(sms_board_setup);
> >> > -
> >> >  int sms_board_power(struct
> smscore_device_t
> >> *coredev, int onoff)
> >> >  {
> >> >        int board_id =
> >> smscore_get_board_id(coredev);
> >> > diff -r dfcfb90798d3 -r 0296b0c436d6
> >> linux/drivers/media/dvb/siano/sms-cards.h
> >> > ---
> a/linux/drivers/media/dvb/siano/sms-cards.h Tue
> >> May 19 19:05:02 2009 +0300
> >> > +++
> b/linux/drivers/media/dvb/siano/sms-cards.h Tue
> >> May 19 19:19:27 2009 +0300
> >> > @@ -109,8 +109,6 @@ int
> sms_board_event(struct
> >> smscore_devic
> >> >  int sms_board_event(struct
> smscore_device_t
> >> *coredev,
> >> >                enum SMS_BOARD_EVENTS
> gevent);
> >> >
> >> > -int sms_board_setup(struct smscore_device_t
> >> *coredev);
> >> > -
> >> >  #define SMS_LED_OFF 0
> >> >  #define SMS_LED_LO  1
> >> >  #define SMS_LED_HI  2
> >> > diff -r dfcfb90798d3 -r 0296b0c436d6
> >> linux/drivers/media/dvb/siano/smsdvb.c
> >> > --- a/linux/drivers/media/dvb/siano/smsdvb.c
>    Tue
> >> May 19 19:05:02 2009 +0300
> >> > +++ b/linux/drivers/media/dvb/siano/smsdvb.c
>    Tue
> >> May 19 19:19:27 2009 +0300
> >> > @@ -600,7 +600,6 @@ static int
> smsdvb_hotplug(struct
> >> smscore
> >> >        sms_board_dvb3_event(client,
> >> DVB3_EVENT_HOTPLUG);
> >> >
> >> >        sms_info("success");
> >> > -       sms_board_setup(coredev);
> >> >
> >> >        return 0;
> >> >
> >> >
> >> >
> >> >
> >> >
> >> > --
> >> > To unsubscribe from this list: send the line
> >> "unsubscribe linux-media" in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >
> >>
> >>
> >>
> >> NACK.
> >>
> >>
> >> This changes the behavior of the Hauppauge
> devices.
> >> Let Uri get all
> >> his other stuff in place first, and THEN we can
> look at
> >> this
> >> separately.
> >>
> >> In addition, this changeset was merged WITHOUT my
> ack:
> >>
> >> http://linuxtv.org/hg/v4l-dvb/rev/37969546eee8 -
> Siano:
> >> smscards -
> >> assign gpio to HPG targets
> >>
> >> That changeset 37969546eee8 alone does not cause
> any change
> >> in
> >> behavior, but with Uri's patches from today it
> will change
> >> the
> >> Hauppauge device behavior.
> >>
> >> That patch should be reverted and dealt with
> separately,
> >> after Uri is
> >> finished with his other changes.
> >>
> >> -Mike
> >>
> >
> > Mike,
> >
> > Please note that the Hauppauge device behavior has
> been merged to the board_event()  **prior** to this patch.
> >
> > I did my best to follow the logic, I might be wrong
> (please check).
> >
> > This patch is remove *duplicate* led setting, etc...
> 
> Uri,
> 
> I nack'd that patch as well.  Please don't change the
> Hauppauge device
> behavior -- those changesets break the device
> functionality.
> 
> Please get all of your core changes in first, then we can
> look at
> device-specifics separately.
> 
> Regards,
> 
> Mike
> 

Mike all "core" changes are in place. After patch #58, the to-be v4l mercurial tree and the Siano subversion tree are identical regarding the code which we would like to commit.

Regards,

Uri


      
