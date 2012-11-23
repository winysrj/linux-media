Return-path: <linux-media-owner@vger.kernel.org>
Received: from [216.32.181.181] ([216.32.181.181]:31324 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756621Ab2KWWG0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 17:06:26 -0500
Message-ID: <50AFF304.20802@convergeddevices.net>
Date: Fri, 23 Nov 2012 14:04:52 -0800
From: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <mchehab@redhat.com>, <sameo@linux.intel.com>,
	<broonie@opensource.wolfsonmicro.com>, <perex@perex.cz>,
	<tiwai@suse.de>, <linux-media@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 5/6] Add a V4L2 driver for SI476X MFD
References: <1351017872-32488-1-git-send-email-andrey.smirnov@convergeddevices.net> <1351017872-32488-6-git-send-email-andrey.smirnov@convergeddevices.net> <201211161602.31416.hverkuil@xs4all.nl>
In-Reply-To: <201211161602.31416.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/16/2012 07:02 AM, Hans Verkuil wrote:
> Hi Andrey,
>
> Some more comments...
>
> On Tue October 23 2012 20:44:31 Andrey Smirnov wrote:
>> This commit adds a driver that exposes all the radio related
>> functionality of the Si476x series of chips via the V4L2 subsystem.
>>
>> Signed-off-by: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
>> ---
>>  drivers/media/radio/Kconfig        |   17 +
>>  drivers/media/radio/Makefile       |    1 +
>>  drivers/media/radio/radio-si476x.c | 1549 ++++++++++++++++++++++++++++++++++++
>>  3 files changed, 1567 insertions(+)
>>  create mode 100644 drivers/media/radio/radio-si476x.c
>>
> <cut>
>
>> diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
>> new file mode 100644
>> index 0000000..c8fa90f
>> --- /dev/null
>> +++ b/drivers/media/radio/radio-si476x.c
>> @@ -0,0 +1,1549 @@
>> +#include <linux/module.h>
>> +#include <linux/delay.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/slab.h>
>> +#include <linux/atomic.h>
>> +#include <linux/videodev2.h>
>> +#include <linux/mutex.h>
>> +#include <linux/debugfs.h>
>> +#include <media/v4l2-common.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-event.h>
>> +#include <media/v4l2-device.h>
>> +
>> +
>> +#include <linux/mfd/si476x-core.h>
>> +
>> +#define FM_FREQ_RANGE_LOW   64000000
>> +#define FM_FREQ_RANGE_HIGH 108000000
>> +
>> +#define AM_FREQ_RANGE_LOW    520000
>> +#define AM_FREQ_RANGE_HIGH 30000000
>> +
>> +#define PWRLINEFLTR (1 << 8)
>> +
>> +#define FREQ_MUL (10000000 / 625)
>> +
>> +#define SI476X_PHDIV_STATUS_LINK_LOCKED(status) (0b10000000 & (status))
>> +
>> +#define DRIVER_NAME "si476x-radio"
>> +#define DRIVER_CARD "SI476x AM/FM Receiver"
>> +
>> +enum si476x_freq_bands {
>> +	SI476X_BAND_FM,
>> +	SI476X_BAND_AM,
>> +};
>> +
>> +static const struct v4l2_frequency_band si476x_bands[] = {
>> +	[SI476X_BAND_FM] = {
>> +		.type		= V4L2_TUNER_RADIO,
>> +		.index		= SI476X_BAND_FM,
>> +		.capability	= V4L2_TUNER_CAP_LOW
>> +		| V4L2_TUNER_CAP_STEREO
>> +		| V4L2_TUNER_CAP_RDS
>> +		| V4L2_TUNER_CAP_RDS_BLOCK_IO
>> +		| V4L2_TUNER_CAP_FREQ_BANDS,
>> +		.rangelow	=  64 * FREQ_MUL,
>> +		.rangehigh	= 108 * FREQ_MUL,
>> +		.modulation	= V4L2_BAND_MODULATION_FM,
>> +	},
>> +	[SI476X_BAND_AM] = {
>> +		.type		= V4L2_TUNER_RADIO,
>> +		.index		= SI476X_BAND_AM,
>> +		.capability	= V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS,
>> +		.rangelow	= 0.52 * FREQ_MUL,
>> +		.rangehigh	= 30 * FREQ_MUL,
>> +		.modulation	= V4L2_BAND_MODULATION_AM,
>> +	},
>> +};
>> +
>> +static inline bool si476x_radio_freq_is_inside_of_the_band(u32 freq, int band)
>> +{
>> +	return freq >= si476x_bands[band].rangelow &&
>> +		freq <= si476x_bands[band].rangehigh;
>> +}
>> +
>> +static inline bool si476x_radio_range_is_inside_of_the_band(u32 low, u32 high, int band)
>> +{
>> +	return low  >= si476x_bands[band].rangelow &&
>> +		high <= si476x_bands[band].rangehigh;
>> +}
>> +
>> +#define PRIVATE_CTL_IDX(x) (x - V4L2_CID_PRIVATE_BASE)
> No. The new control IDs need to be added to include/uapi/linux/v4l2-controls.h
> with unique IDs. V4L2_CID_PRIVATE_BASE must not be used anymore for new controls.
>
> Since Halli Manjunatha hasn't worked on a new version of his patch with the new
> fm controls it might be something you want to take on (I'm referring to the FM RX
> control class).

Should I move all controls there, even chip specific ones, like
SI476X_CID_HARMONICS_COUNT or SI476X_CID_DIVERSITY_MODE?


