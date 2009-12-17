Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:38018 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbZLQOmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2009 09:42:20 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Alexey Klimov <klimov.linux@gmail.com>,
	"santiago.nunez@ridgerun.com" <santiago.nunez@ridgerun.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>,
	"diego.dompe@ridgerun.com" <diego.dompe@ridgerun.com>,
	"todd.fischer@ridgerun.com" <todd.fischer@ridgerun.com>,
	"Grosen, Mark" <mgrosen@ti.com>
Date: Thu, 17 Dec 2009 08:42:07 -0600
Subject: RE: [PATCH 3/4 v12] TVP7002 driver for DM365
Message-ID: <A69FA2915331DC488A831521EAE36FE401625D11E1@dlee06.ent.ti.com>
References: <1260999122-28318-1-git-send-email-santiago.nunez@ridgerun.com>
 <208cbae30912170612n49292be6i35e8a7d98c440d80@mail.gmail.com>
In-Reply-To: <208cbae30912170612n49292be6i35e8a7d98c440d80@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Santiago,

>> +
>> +/* Struct list for digital video presets */
>> +static const struct tvp7002_preset_definition tvp7002_presets[] = {
>> +       {
>> +               V4L2_DV_720P60,
>> +               tvp7002_parms_720P60,
>> +               V4L2_COLORSPACE_REC709,
>> +               V4L2_FIELD_SEQ_TB,
Why don't we set this to V4L2_FIELD_NONE? That is what we used in
internal releases and is the requirement. Same for all of Progressive
frame formats below.
>> +               1,
>> +               0x2EE,
>> +               135,
>> +               153
>> +       },
>> +       {
>> +               V4L2_DV_1080I60,
>> +               tvp7002_parms_1080I60,
>> +               V4L2_COLORSPACE_REC709,
>> +               V4L2_FIELD_INTERLACED,
>> +               0,
>> +               0x465,
>> +               181,
>> +               205
>> +       },
>> +       {
>> +               V4L2_DV_1080I50,
>> +               tvp7002_parms_1080I50,
>> +               V4L2_COLORSPACE_REC709,
>> +               V4L2_FIELD_INTERLACED,
>> +               0,
>> +               0x465,
>> +               217,
>> +               245
>> +       },
>> +       {
>> +               V4L2_DV_720P50,
>> +               tvp7002_parms_720P50,
>> +               V4L2_COLORSPACE_REC709,
>> +               V4L2_FIELD_SEQ_TB,
>> +               1,
>> +               0x2EE,
>> +               163,
>> +               183
>> +       },
>> +       {
>> +               V4L2_DV_1080P60,
>> +               tvp7002_parms_1080P60,
>> +               V4L2_COLORSPACE_REC709,
>> +               V4L2_FIELD_SEQ_TB,
>> +               1,
>> +               0x465,
>> +               90,
>> +               102
>> +       },
>> +       {
>> +               V4L2_DV_480P59_94,
>> +               tvp7002_parms_480P,
>> +               V4L2_COLORSPACE_SMPTE170M,
>> +               V4L2_FIELD_SEQ_TB,
>> +               1,
>> +               0x20D,
>> +               0xffff,
>> +               0xffff
>> +       },
>> +       {
>> +               V4L2_DV_576P50,
>> +               tvp7002_parms_576P,
>> +               V4L2_COLORSPACE_SMPTE170M,
>> +               V4L2_FIELD_SEQ_TB,
>> +               1,
>> +               0x271,
>> +               0xffff,
>> +               0xffff
>> +       }
>> +};
>> +

Murali
