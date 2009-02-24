Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1O76D3T013565
	for <video4linux-list@redhat.com>; Tue, 24 Feb 2009 02:06:13 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1O75w0f023691
	for <video4linux-list@redhat.com>; Tue, 24 Feb 2009 02:05:59 -0500
Received: by fg-out-1718.google.com with SMTP id 19so50221fgg.7
	for <video4linux-list@redhat.com>; Mon, 23 Feb 2009 23:05:58 -0800 (PST)
Date: Tue, 24 Feb 2009 16:06:42 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: V4L <video4linux-list@redhat.com>
Message-ID: <20090224160642.2200eb25@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: new tuner
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

Hi All.

How I can add new type of tuner to video4linux??

I add new definition into  linux/include/media/tuner.h
#define TUNER_PHILIPS_FM1216MK5		79

add some data to
/linux/drivers/media/common/tuners/tuner-types.c

/* ------------ TUNER_PHILIPS_FM1216MK5 - Philips PAL ------------ */

static struct tuner_range tuner_fm1216mk5_pal_ranges[] = {
	{ 16 * 158.00 /*MHz*/, 0x8e, 0x01, },
	{ 16 * 442.00 /*MHz*/, 0x8e, 0x02, },
	{ 16 * 999.99        , 0x8e, 0x04, },
};

static struct tuner_params tuner_fm1216mk5_params[] = {
	{
		.type   = TUNER_PARAM_TYPE_PAL,
		.ranges = tuner_fm1216mk5_pal_ranges,
		.count  = ARRAY_SIZE(tuner_fm1216mk5_pal_ranges),
 		.cb_first_if_lower_freq = 1,
 		.has_tda9887 = 1,
 		.port1_active = 1,
 		.initdata = tua603x_agc112,
 		.sleepdata = (u8[]){ 4, 0x9c, 0x60, 0x85, 0x54 },
 	},
		[TUNER_PHILIPS_FM1216MK5] = { /* Philips PAL */
		.name   = "Philips PAL/SECAM multi (FM1216 MK5)",
		.params = tuner_fm1216mk5_params,
		.count  = ARRAY_SIZE(tuner_fm1216mk5_params),
	},

But when I change type of tuner to new model build exit with error. Incorrect tuner name.

What is wrong??

With my best regards, Dmitry.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
