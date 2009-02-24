Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1OC9jcF003515
	for <video4linux-list@redhat.com>; Tue, 24 Feb 2009 07:09:45 -0500
Received: from mail-in-16.arcor-online.net (mail-in-16.arcor-online.net
	[151.189.21.56])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1OC9Glj023424
	for <video4linux-list@redhat.com>; Tue, 24 Feb 2009 07:09:17 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Dmitri Belimov <d.belimov@gmail.com>
In-Reply-To: <20090224160642.2200eb25@glory.loctelecom.ru>
References: <20090224160642.2200eb25@glory.loctelecom.ru>
Content-Type: text/plain
Date: Tue, 24 Feb 2009 13:10:24 +0100
Message-Id: <1235477424.3334.15.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: new tuner
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


Hi Dmitry,

on a first look.

Am Dienstag, den 24.02.2009, 16:06 +0900 schrieb Dmitri Belimov:
> Hi All.
> 
> How I can add new type of tuner to video4linux??
> 
> I add new definition into  linux/include/media/tuner.h
> #define TUNER_PHILIPS_FM1216MK5		79
> 
> add some data to
> /linux/drivers/media/common/tuners/tuner-types.c
> 
> /* ------------ TUNER_PHILIPS_FM1216MK5 - Philips PAL ------------ */
> 
> static struct tuner_range tuner_fm1216mk5_pal_ranges[] = {
> 	{ 16 * 158.00 /*MHz*/, 0x8e, 0x01, },
> 	{ 16 * 442.00 /*MHz*/, 0x8e, 0x02, },
> 	{ 16 * 999.99        , 0x8e, 0x04, },
> };

This is wrong, since you only duplicate fm1216me_mk3_pal_ranges which
you should just use instead.

> static struct tuner_params tuner_fm1216mk5_params[] = {
> 	{
> 		.type   = TUNER_PARAM_TYPE_PAL,
> 		.ranges = tuner_fm1216mk5_pal_ranges,
> 		.count  = ARRAY_SIZE(tuner_fm1216mk5_pal_ranges),
>  		.cb_first_if_lower_freq = 1,
>  		.has_tda9887 = 1,
>  		.port1_active = 1,
>  		.initdata = tua603x_agc112,
>  		.sleepdata = (u8[]){ 4, 0x9c, 0x60, 0x85, 0x54 },
>  	},

Since you do not send a diff, I assume you are not in struct tunertype
tuners[] here. Also initdata and sleepdata should be there

> 		[TUNER_PHILIPS_FM1216MK5] = { /* Philips PAL */
> 		.name   = "Philips PAL/SECAM multi (FM1216 MK5)",
> 		.params = tuner_fm1216mk5_params,
> 		.count  = ARRAY_SIZE(tuner_fm1216mk5_params),
> 	},
> 
> But when I change type of tuner to new model build exit with error. Incorrect tuner name.
> 
> What is wrong??
> 
> With my best regards, Dmitry.
> 

You also miss to set it up for the radio mode switch in tuner-simple
and did not look into tveeprom.c, where you can see that we use the 
TUNER_PHILIPS_FM1216ME_MK3 for it since long without complaints. MK4 is
also the same.

If you don't have the detailed programming tables for every supported TV
standard and detailed instructions for radio mode, I would assume that
you reduce the quality of support for that tuner a lot with your current
attempt.

For example SECAM-L would not work without port2=0 and radio without
high sensitivity set is also very poor.

Cheers,
Hermann



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
