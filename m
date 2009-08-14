Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:33385 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753658AbZHNBQ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2009 21:16:26 -0400
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] sms1xxx: restore GPIO
	functionality for all Hauppauge devices
From: hermann pitton <hermann-pitton@arcor.de>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media <linux-media@vger.kernel.org>
In-Reply-To: <37219a840908131403v5d336c4dof316f562e465c6f4@mail.gmail.com>
References: <E1Mauhe-0003WS-E6@mail.linuxtv.org>
	 <37219a840908131403v5d336c4dof316f562e465c6f4@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 03:11:43 +0200
Message-Id: <1250212303.8915.5.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Donnerstag, den 13.08.2009, 17:03 -0400 schrieb Michael Krufky:
> Mauro,
> 
> This changeset is not in your git tree for Linus, but it fixes a
> regression in the 2.6.31 kernel -- can you push this to Linus as well?
> 
> Thanks & regards,
> 
> Mike

Fixes for Hauppauge/Pinnacle devices are never ignored.

http://linuxtv.org/hg/v4l-dvb/rev/f2deba9c23d6
http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-08/msg04800.html

It might be related to this.

http://lkml.indiana.edu/hypermail/linux/kernel/0908.1/02080.html

You eventually might get some noise, if there are no fixes for more than
one year, but never the other way round.

:)

Cheers,
Hermann


> 
> On Tue, Aug 11, 2009 at 1:00 PM, Patch from Michael
> Krufky<hg-commit@linuxtv.org> wrote:
> > The patch number 12446 was added via Michael Krufky <mkrufky@kernellabs.com>
> > to http://linuxtv.org/hg/v4l-dvb master development tree.
> >
> > Kernel patches in this development tree may be modified to be backward
> > compatible with older kernels. Compatibility modifications will be
> > removed before inclusion into the mainstream Kernel
> >
> > If anyone has any objections, please let us know by sending a message to:
> >        Linux Media Mailing List <linux-media@vger.kernel.org>
> >
> > ------
> >
> > From: Michael Krufky  <mkrufky@kernellabs.com>
> > sms1xxx: restore GPIO functionality for all Hauppauge devices
> >
> >
> > Previous changesets broke Hauppauge devices and their GPIO configurations.
> >
> > This changeset restores the LED & LNA functionality.
> >
> > Priority: high
> >
> > Signed-off-by: Michael Krufky <mkrufky@kernellabs.com>
> >
> >
> > ---
> >
> >  linux/drivers/media/dvb/siano/smsdvb.c |   44 +++++++++++++++++++++++++
> >  1 file changed, 44 insertions(+)
> >
> > diff -r 70c2efcd6b4a -r f2deba9c23d6 linux/drivers/media/dvb/siano/smsdvb.c
> > --- a/linux/drivers/media/dvb/siano/smsdvb.c    Sun Jul 12 17:25:45 2009 -0400
> > +++ b/linux/drivers/media/dvb/siano/smsdvb.c    Sun Jul 12 22:30:14 2009 -0400
> > @@ -325,6 +325,16 @@
> >                                                0 : -ETIME;
> >  }
> >
> > +static inline int led_feedback(struct smsdvb_client_t *client)
> > +{
> > +       if (client->fe_status & FE_HAS_LOCK)
> > +               return sms_board_led_feedback(client->coredev,
> > +                       (client->sms_stat_dvb.ReceptionData.BER
> > +                       == 0) ? SMS_LED_HI : SMS_LED_LO);
> > +       else
> > +               return sms_board_led_feedback(client->coredev, SMS_LED_OFF);
> > +}
> > +
> >  static int smsdvb_read_status(struct dvb_frontend *fe, fe_status_t *stat)
> >  {
> >        struct smsdvb_client_t *client;
> > @@ -332,6 +342,8 @@
> >
> >        *stat = client->fe_status;
> >
> > +       led_feedback(client);
> > +
> >        return 0;
> >  }
> >
> > @@ -342,6 +354,8 @@
> >
> >        *ber = client->sms_stat_dvb.ReceptionData.BER;
> >
> > +       led_feedback(client);
> > +
> >        return 0;
> >  }
> >
> > @@ -359,6 +373,8 @@
> >                                (client->sms_stat_dvb.ReceptionData.InBandPwr
> >                                + 95) * 3 / 2;
> >
> > +       led_feedback(client);
> > +
> >        return 0;
> >  }
> >
> > @@ -369,6 +385,8 @@
> >
> >        *snr = client->sms_stat_dvb.ReceptionData.SNR;
> >
> > +       led_feedback(client);
> > +
> >        return 0;
> >  }
> >
> > @@ -379,6 +397,8 @@
> >
> >        *ucblocks = client->sms_stat_dvb.ReceptionData.ErrorTSPackets;
> >
> > +       led_feedback(client);
> > +
> >        return 0;
> >  }
> >
> > @@ -404,6 +424,8 @@
> >                u32             Data[3];
> >        } Msg;
> >
> > +       int ret;
> > +
> >        client->fe_status = FE_HAS_SIGNAL;
> >        client->event_fe_state = -1;
> >        client->event_unc_state = -1;
> > @@ -429,6 +451,23 @@
> >        case BANDWIDTH_AUTO: return -EOPNOTSUPP;
> >        default: return -EINVAL;
> >        }
> > +       /* Disable LNA, if any. An error is returned if no LNA is present */
> > +       ret = sms_board_lna_control(client->coredev, 0);
> > +       if (ret == 0) {
> > +               fe_status_t status;
> > +
> > +               /* tune with LNA off at first */
> > +               ret = smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
> > +                                                 &client->tune_done);
> > +
> > +               smsdvb_read_status(fe, &status);
> > +
> > +               if (status & FE_HAS_LOCK)
> > +                       return ret;
> > +
> > +               /* previous tune didnt lock - enable LNA and tune again */
> > +               sms_board_lna_control(client->coredev, 1);
> > +       }
> >
> >        return smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
> >                                           &client->tune_done);
> > @@ -454,6 +493,8 @@
> >        struct smsdvb_client_t *client =
> >                container_of(fe, struct smsdvb_client_t, frontend);
> >
> > +       sms_board_power(client->coredev, 1);
> > +
> >        sms_board_dvb3_event(client, DVB3_EVENT_INIT);
> >        return 0;
> >  }
> > @@ -463,6 +504,9 @@
> >        struct smsdvb_client_t *client =
> >                container_of(fe, struct smsdvb_client_t, frontend);
> >
> > +       sms_board_led_feedback(client->coredev, SMS_LED_OFF);
> > +       sms_board_power(client->coredev, 0);
> > +
> >        sms_board_dvb3_event(client, DVB3_EVENT_SLEEP);
> >
> >        return 0;
> >
> >
> > ---
> >
> > Patch is available at: http://linuxtv.org/hg/v4l-dvb/rev/f2deba9c23d68c9b46812c76b5aebee189f36b20
> >


