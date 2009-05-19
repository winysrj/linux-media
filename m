Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:52843 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbZESSQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 14:16:20 -0400
Received: by ewy24 with SMTP id 24so5079622ewy.37
        for <linux-media@vger.kernel.org>; Tue, 19 May 2009 11:16:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <392953.59542.qm@web110810.mail.gq1.yahoo.com>
References: <392953.59542.qm@web110810.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 14:16:20 -0400
Message-ID: <37219a840905191116j5502f092p8ff25fdf40b26dcb@mail.gmail.com>
Subject: Re: [PATCH] [09051_47] Siano: smsdvb - add DVB v3 events
From: Michael Krufky <mkrufky@linuxtv.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 19, 2009 at 1:05 PM, Uri Shkolnik <urishk@yahoo.com> wrote:
>
>
>
> --- On Tue, 5/19/09, Michael Krufky <mkrufky@linuxtv.org> wrote:
>
>> From: Michael Krufky <mkrufky@linuxtv.org>
>> Subject: Re: [PATCH] [09051_47] Siano: smsdvb - add DVB v3 events
>> To: "Uri Shkolnik" <urishk@yahoo.com>
>> Cc: "LinuxML" <linux-media@vger.kernel.org>, "Mauro Carvalho Chehab" <mchehab@infradead.org>
>> Date: Tuesday, May 19, 2009, 7:18 PM
>> On Tue, May 19, 2009 at 11:28 AM, Uri
>> Shkolnik <urishk@yahoo.com>
>> wrote:
>> >
>> > # HG changeset patch
>> > # User Uri Shkolnik <uris@siano-ms.com>
>> > # Date 1242747164 -10800
>> > # Node ID 971d4cc0d4009650bd4752c6a9fc09755ef77baf
>> > # Parent  98895daafb42f8b0757fd608b29c53c80327520e
>> > [09051_47] Siano: smsdvb - add DVB v3 events
>> >
>> > From: Uri Shkolnik <uris@siano-ms.com>
>> >
>> > Add various DVB-API v3 events, those events will trig
>> > target (card) events.
>> >
>> > Priority: normal
>> >
>> > Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
>> >
>> > diff -r 98895daafb42 -r 971d4cc0d400
>> linux/drivers/media/dvb/siano/smsdvb.c
>> > --- a/linux/drivers/media/dvb/siano/smsdvb.c    Tue
>> May 19 18:27:38 2009 +0300
>> > +++ b/linux/drivers/media/dvb/siano/smsdvb.c    Tue
>> May 19 18:32:44 2009 +0300
>> > @@ -66,6 +66,54 @@ MODULE_PARM_DESC(debug, "set debug
>> level
>> >  /* Events that may come from DVB v3 adapter */
>> >  static void sms_board_dvb3_event(struct
>> smsdvb_client_t *client,
>> >                enum SMS_DVB3_EVENTS event) {
>> > +
>> > +       struct smscore_device_t *coredev =
>> client->coredev;
>> > +       switch (event) {
>> > +       case DVB3_EVENT_INIT:
>> > +               sms_debug("DVB3_EVENT_INIT");
>> > +               sms_board_event(coredev,
>> BOARD_EVENT_BIND);
>> > +               break;
>> > +       case DVB3_EVENT_SLEEP:
>> > +               sms_debug("DVB3_EVENT_SLEEP");
>> > +               sms_board_event(coredev,
>> BOARD_EVENT_POWER_SUSPEND);
>> > +               break;
>> > +       case DVB3_EVENT_HOTPLUG:
>> > +
>> sms_debug("DVB3_EVENT_HOTPLUG");
>> > +               sms_board_event(coredev,
>> BOARD_EVENT_POWER_INIT);
>> > +               break;
>> > +       case DVB3_EVENT_FE_LOCK:
>> > +               if (client->event_fe_state
>> != DVB3_EVENT_FE_LOCK) {
>> > +
>> client->event_fe_state = DVB3_EVENT_FE_LOCK;
>> > +
>> sms_debug("DVB3_EVENT_FE_LOCK");
>> > +
>> sms_board_event(coredev, BOARD_EVENT_FE_LOCK);
>> > +               }
>> > +               break;
>> > +       case DVB3_EVENT_FE_UNLOCK:
>> > +               if (client->event_fe_state
>> != DVB3_EVENT_FE_UNLOCK) {
>> > +
>> client->event_fe_state = DVB3_EVENT_FE_UNLOCK;
>> > +
>> sms_debug("DVB3_EVENT_FE_UNLOCK");
>> > +
>> sms_board_event(coredev, BOARD_EVENT_FE_UNLOCK);
>> > +               }
>> > +               break;
>> > +       case DVB3_EVENT_UNC_OK:
>> > +               if (client->event_unc_state
>> != DVB3_EVENT_UNC_OK) {
>> > +
>> client->event_unc_state = DVB3_EVENT_UNC_OK;
>> > +
>> sms_debug("DVB3_EVENT_UNC_OK");
>> > +
>> sms_board_event(coredev, BOARD_EVENT_MULTIPLEX_OK);
>> > +               }
>> > +               break;
>> > +       case DVB3_EVENT_UNC_ERR:
>> > +               if (client->event_unc_state
>> != DVB3_EVENT_UNC_ERR) {
>> > +
>> client->event_unc_state = DVB3_EVENT_UNC_ERR;
>> > +
>> sms_debug("DVB3_EVENT_UNC_ERR");
>> > +
>> sms_board_event(coredev, BOARD_EVENT_MULTIPLEX_ERRORS);
>> > +               }
>> > +               break;
>> > +
>> > +       default:
>> > +               sms_err("Unknown dvb3 api
>> event");
>> > +               break;
>> > +       }
>> >  }
>> >
>> >  static int smsdvb_onresponse(void *context, struct
>> smscore_buffer_t *cb)
>> >
>> >
>> >
>> >
>> > --
>> > To unsubscribe from this list: send the line
>> "unsubscribe linux-media" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>>
>>
>>
>> Uri,
>>
>> I don't understand what prompts you to call these "DVB v3
>> events" ...
>> what does this have to do with DVB API v3 at all?
>> Your idea seems to
>> be in the right direction, but this "DVBV3" nomenclature is
>> a total
>> misnomer.
>>
>> I think something along the lines of SMSBOARD_EVENT_FOO is
>> more appropriate.
>>
>> Regards,
>>
>> Mike
>>
>
> Mike,
>
> Within the DVB version 3 adapter, there is events manager, and the name we put on it is  "dvb3_event", I think its OK....
>
> Uri
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I disagree.  Your naming implies that these structures are on the
subsystem level, and they have nothing to do with DVB3 anyway -- these
are board related events.  "dvb3_event" is a total misnomer.

-Mike
