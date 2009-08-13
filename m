Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:49059 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055AbZHMVDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2009 17:03:45 -0400
Received: by ewy10 with SMTP id 10so1092592ewy.37
        for <linux-media@vger.kernel.org>; Thu, 13 Aug 2009 14:03:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E1Mauhe-0003WS-E6@mail.linuxtv.org>
References: <E1Mauhe-0003WS-E6@mail.linuxtv.org>
Date: Thu, 13 Aug 2009 17:03:45 -0400
Message-ID: <37219a840908131403v5d336c4dof316f562e465c6f4@mail.gmail.com>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] sms1xxx: restore GPIO
	functionality for all Hauppauge devices
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

This changeset is not in your git tree for Linus, but it fixes a
regression in the 2.6.31 kernel -- can you push this to Linus as well?

Thanks & regards,

Mike

On Tue, Aug 11, 2009 at 1:00 PM, Patch from Michael
Krufky<hg-commit@linuxtv.org> wrote:
> The patch number 12446 was added via Michael Krufky <mkrufky@kernellabs.com>
> to http://linuxtv.org/hg/v4l-dvb master development tree.
>
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
>
> If anyone has any objections, please let us know by sending a message to:
>        Linux Media Mailing List <linux-media@vger.kernel.org>
>
> ------
>
> From: Michael Krufky  <mkrufky@kernellabs.com>
> sms1xxx: restore GPIO functionality for all Hauppauge devices
>
>
> Previous changesets broke Hauppauge devices and their GPIO configurations.
>
> This changeset restores the LED & LNA functionality.
>
> Priority: high
>
> Signed-off-by: Michael Krufky <mkrufky@kernellabs.com>
>
>
> ---
>
>  linux/drivers/media/dvb/siano/smsdvb.c |   44 +++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
>
> diff -r 70c2efcd6b4a -r f2deba9c23d6 linux/drivers/media/dvb/siano/smsdvb.c
> --- a/linux/drivers/media/dvb/siano/smsdvb.c    Sun Jul 12 17:25:45 2009 -0400
> +++ b/linux/drivers/media/dvb/siano/smsdvb.c    Sun Jul 12 22:30:14 2009 -0400
> @@ -325,6 +325,16 @@
>                                                0 : -ETIME;
>  }
>
> +static inline int led_feedback(struct smsdvb_client_t *client)
> +{
> +       if (client->fe_status & FE_HAS_LOCK)
> +               return sms_board_led_feedback(client->coredev,
> +                       (client->sms_stat_dvb.ReceptionData.BER
> +                       == 0) ? SMS_LED_HI : SMS_LED_LO);
> +       else
> +               return sms_board_led_feedback(client->coredev, SMS_LED_OFF);
> +}
> +
>  static int smsdvb_read_status(struct dvb_frontend *fe, fe_status_t *stat)
>  {
>        struct smsdvb_client_t *client;
> @@ -332,6 +342,8 @@
>
>        *stat = client->fe_status;
>
> +       led_feedback(client);
> +
>        return 0;
>  }
>
> @@ -342,6 +354,8 @@
>
>        *ber = client->sms_stat_dvb.ReceptionData.BER;
>
> +       led_feedback(client);
> +
>        return 0;
>  }
>
> @@ -359,6 +373,8 @@
>                                (client->sms_stat_dvb.ReceptionData.InBandPwr
>                                + 95) * 3 / 2;
>
> +       led_feedback(client);
> +
>        return 0;
>  }
>
> @@ -369,6 +385,8 @@
>
>        *snr = client->sms_stat_dvb.ReceptionData.SNR;
>
> +       led_feedback(client);
> +
>        return 0;
>  }
>
> @@ -379,6 +397,8 @@
>
>        *ucblocks = client->sms_stat_dvb.ReceptionData.ErrorTSPackets;
>
> +       led_feedback(client);
> +
>        return 0;
>  }
>
> @@ -404,6 +424,8 @@
>                u32             Data[3];
>        } Msg;
>
> +       int ret;
> +
>        client->fe_status = FE_HAS_SIGNAL;
>        client->event_fe_state = -1;
>        client->event_unc_state = -1;
> @@ -429,6 +451,23 @@
>        case BANDWIDTH_AUTO: return -EOPNOTSUPP;
>        default: return -EINVAL;
>        }
> +       /* Disable LNA, if any. An error is returned if no LNA is present */
> +       ret = sms_board_lna_control(client->coredev, 0);
> +       if (ret == 0) {
> +               fe_status_t status;
> +
> +               /* tune with LNA off at first */
> +               ret = smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
> +                                                 &client->tune_done);
> +
> +               smsdvb_read_status(fe, &status);
> +
> +               if (status & FE_HAS_LOCK)
> +                       return ret;
> +
> +               /* previous tune didnt lock - enable LNA and tune again */
> +               sms_board_lna_control(client->coredev, 1);
> +       }
>
>        return smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
>                                           &client->tune_done);
> @@ -454,6 +493,8 @@
>        struct smsdvb_client_t *client =
>                container_of(fe, struct smsdvb_client_t, frontend);
>
> +       sms_board_power(client->coredev, 1);
> +
>        sms_board_dvb3_event(client, DVB3_EVENT_INIT);
>        return 0;
>  }
> @@ -463,6 +504,9 @@
>        struct smsdvb_client_t *client =
>                container_of(fe, struct smsdvb_client_t, frontend);
>
> +       sms_board_led_feedback(client->coredev, SMS_LED_OFF);
> +       sms_board_power(client->coredev, 0);
> +
>        sms_board_dvb3_event(client, DVB3_EVENT_SLEEP);
>
>        return 0;
>
>
> ---
>
> Patch is available at: http://linuxtv.org/hg/v4l-dvb/rev/f2deba9c23d68c9b46812c76b5aebee189f36b20
>
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
>
