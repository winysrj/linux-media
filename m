Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:44053 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbZCXXSf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 19:18:35 -0400
Message-ID: <49C96A37.4020905@gmail.com>
Date: Wed, 25 Mar 2009 03:18:15 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
CC: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
 	and BER from HVR 4000 Lite
References: <49B9BC93.8060906@nav6.org>	 <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>	 <20090319101601.2eba0397@pedra.chehab.org>	 <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>	 <Pine.LNX.4.58.0903191457580.28292@shell2.speakeasy.net>	 <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com>	 <49C2D4DB.6060509@gmail.com> <49C33DE7.1050906@gmail.com>	 <1237689919.3298.179.camel@palomino.walls.org>	 <412bdbff0903221800j2f9e1137u7776191e2e75d9d2@mail.gmail.com> <412bdbff0903241439u472be49mbc2588abfc1d675d@mail.gmail.com>
In-Reply-To: <412bdbff0903241439u472be49mbc2588abfc1d675d@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000102060300000201090801"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000102060300000201090801
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Devin Heitmueller wrote:
> On Sun, Mar 22, 2009 at 9:00 PM, Devin Heitmueller
> <devin.heitmueller@gmail.com> wrote:
>> Wow, well this literally kept me up all night pondering the various options.
>>
>> Manu's idea has alot of merit - providing a completely new API that
>> provides the "raw data without translation" as well as a way to query
>> for what that format is for the raw data, provides a great deal more
>> flexibility for applications that want to perform advanced analysis
>> and interpretation of the data.
>>
>> That said, the solution takes the approach of "revolutionary" as
>> opposed to "evolutionary", which always worries me.  While providing a
>> much more powerful interface, it also means all of the applications
>> will have to properly support all of the various possible
>> representations of the data, increasing the responsibility in userland
>> considerably.

Not necessarily, the application can simply chose to support what
the driver provides as is, thereby doing no translations at all.

The change to the application is rather quite small, as you can see
from the quick patch and a modified femon.

>From what you see, it should be that simple.

>> Let me ask this rhetorical question: if we did nothing more than just
>> normalize the SNR to provide a consistent value in dB, and did nothing
>> more than normalize the existing strength field to be 0-100%, leaving
>> it up to the driver author to decide the actual heuristic, what
>> percentage of user's needs would be fulfilled?
>>
>> I bet the answer would be something like 99%.

You can really scale values to dB only if it is in some dB scale.
Looking at the drivers there are hardly a few drivers that do in dB.


If it were to be standardized in to "one standard format" i would
rather prefer to have the format what the API currently suggests:
That is to have a floor - ceiling value, without any units, rather
than one which forces all drivers to dB (in this case the drivers
which do not will be considered broken), the reason being this
hardly helps a few drivers, while the reverse holds true for all.

Regards,
Manu

--------------000102060300000201090801
Content-Type: text/x-patch;
 name="statistics.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="statistics.diff"

diff -r 421de709288e linux/drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Wed Mar 18 23:42:34 2009 +0400
+++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Wed Mar 25 01:22:31 2009 +0400
 -1607,6 +1607,13 @@
 		break;
 	}

+	case FE_STATISTICS_CAPS: {
+		struct fecap_statistics *stats_cap = parg;
+		memcpy(stats_cap, &fe->ops.statistics_caps, sizeof (struct fecap_statistics));
+		err = 0;
+		break;
+	}
+
 	case FE_READ_STATUS: {
 		fe_status_t* status = parg;

 -1622,6 +1629,17 @@
 			err = fe->ops.read_status(fe, status);
 		break;
 	}
+
+	case FE_SIGNAL_LEVEL:
+		if (fe->ops.read_level)
+			err = fe->ops.read_level(fe, (__u32 *) parg);
+		break;
+
+	case FE_SIGNAL_STATS:
+		if (fe->ops.read_stats)
+			err = fe->ops.read_stats(fe, (struct fesignal_stat *) parg);
+		break;
+
 	case FE_READ_BER:
 		if (fe->ops.read_ber)
 			err = fe->ops.read_ber(fe, (__u32*) parg);
diff -r 421de709288e linux/drivers/media/dvb/dvb-core/dvb_frontend.h
--- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.h	Wed Mar 18 23:42:34 2009 +0400
+++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.h	Wed Mar 25 01:22:31 2009 +0400
 -252,6 +252,7 @@
 struct dvb_frontend_ops {

 	struct dvb_frontend_info info;
+	struct fecap_statistics statistics_caps;

 	void (*release)(struct dvb_frontend* fe);
 	void (*release_sec)(struct dvb_frontend* fe);
 -298,6 +299,9 @@
 	 */
 	enum dvbfe_search (*search)(struct dvb_frontend *fe, struct dvb_frontend_parameters *p);
 	int (*track)(struct dvb_frontend *fe, struct dvb_frontend_parameters *p);
+
+	int (*read_level)(struct dvb_frontend *fe, u32 *signal); /* Raw AGC level */
+	int (*read_stats)(struct dvb_frontend *fe, struct fesignal_stat *stat);

 	struct dvb_tuner_ops tuner_ops;
 	struct analog_demod_ops analog_ops;
diff -r 421de709288e linux/drivers/media/dvb/frontends/stb0899_drv.c
--- a/linux/drivers/media/dvb/frontends/stb0899_drv.c	Wed Mar 18 23:42:34 2009 +0400
+++ b/linux/drivers/media/dvb/frontends/stb0899_drv.c	Wed Mar 25 01:22:31 2009 +0400
 -1226,6 +1226,29 @@
 	return 0;
 }

+static int stb0899_read_level(struct dvb_frontend *fe, u32 *signal)
+{
+	/* TODO! */
+	return 0;
+}
+
+static int stb0899_read_stats(struct dvb_frontend *fe, struct fesignal_stat *stats)
+{
+	u16 snr, strength;
+	u32 ber;
+
+	stb0899_read_snr(fe, &snr);
+	stb0899_read_signal_strength(fe, &strength);
+	stb0899_read_ber(fe, &ber);
+
+	stats->quality = snr;
+	stats->strength = strength;
+	stats->error = ber;
+	stats->unc = 0;
+
+	return 0;
+}
+
 static int stb0899_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
 {
 	struct stb0899_state *state = fe->demodulator_priv;
 -1917,6 +1940,27 @@
 					  FE_CAN_QPSK
 	},

+	.statistics_caps = {
+		.quality = {
+			.params		= FE_QUALITY_CNR,
+			.scale		= FE_SCALE_dB,
+			.exponent	= -4,
+		},
+
+		.strength = {
+			.params		= FE_SCALE_dB,
+			.exponent	= -4,
+		},
+
+		.error = {
+			.params		= FE_ERROR_BER,
+			.exponent	= 7,
+		},
+
+		.unc = FE_UNC_UNKNOWN,
+
+	},
+
 	.release			= stb0899_release,
 	.init				= stb0899_init,
 	.sleep				= stb0899_sleep,
 -1934,6 +1978,9 @@
 	.read_snr			= stb0899_read_snr,
 	.read_signal_strength		= stb0899_read_signal_strength,
 	.read_ber			= stb0899_read_ber,
+
+	.read_level			= stb0899_read_level,
+	.read_stats			= stb0899_read_stats,

 	.set_voltage			= stb0899_set_voltage,
 	.set_tone			= stb0899_set_tone,
diff -r 421de709288e linux/include/linux/dvb/frontend.h
--- a/linux/include/linux/dvb/frontend.h	Wed Mar 18 23:42:34 2009 +0400
+++ b/linux/include/linux/dvb/frontend.h	Wed Mar 25 01:22:31 2009 +0400
 -413,4 +413,120 @@

 #define FE_DISHNETWORK_SEND_LEGACY_CMD _IO('o', 80) /* unsigned int */

+
+/* Frontend General Statistics
+ * General parameters
+ * FE_*_UNKNOWN:
+ *	Parameter is unknown to the frontend and doesn't really
+ *	make any sense for an application.
+ *
+ * FE_*_RELATIVE:
+ *	Parameter is relative on the basis of a ceil - floor basis
+ *	Format is based on empirical test to determine
+ *	the floor and ceiling values. This format is exactly the
+ *	same format as the existing statistics implementation.
+ */
+enum fecap_quality_params {
+	FE_QUALITY_UNKNOWN		= 0,
+	FE_QUALITY_SNR			= (1 <<  0),
+	FE_QUALITY_CNR			= (1 <<  1),
+	FE_QUALITY_EsNo			= (1 <<  2),
+	FE_QUALITY_EbNo			= (1 <<  3),
+	FE_QUALITY_RELATIVE		= (1 << 31),
+};
+
+enum fecap_scale_params {
+	FE_SCALE_UNKNOWN		= 0,
+	FE_SCALE_dB			= (1 <<  0),
+	FE_SCALE_RELATIVE		= (1 << 31),
+};
+
+enum fecap_error_params {
+	FE_ERROR_UNKNOWN		= 0,
+	FE_ERROR_BER			= (1 <<  0),
+	FE_ERROR_PER			= (1 <<  1),
+	FE_ERROR_RELATIVE		= (1 << 31),
+};
+
+enum fecap_unc_params {
+	FE_UNC_UNKNOWN			= 0,
+	FE_UNC_RELATIVE			= (1 << 31),
+};
+
+/* General parameters
+ * width:
+ * 	Specifies the width of the field
+ *
+ * exponent:
+ *	Specifies the multiplier for the respective field
+ *	MSB:1bit indicates the signdness of the parameter
+ */
+struct fecap_quality {
+	enum fecap_quality_params	params;
+	enum fecap_scale_params		scale;
+
+	__u32				width;
+	__s32				exponent;
+};
+
+struct fecap_strength {
+	enum fecap_scale_params		params;
+	__u32				width;
+	__s32				exponent;
+};
+
+struct fecap_error {
+	enum fecap_error_params		params;
+	__u32 				width;
+	__s32 				exponent;
+};
+
+struct fecap_statistics {
+	struct fecap_quality		quality;
+	struct fecap_strength		strength;
+	struct fecap_error		error;
+	enum fecap_unc_params		unc;
+};
+
+/* FE_STATISTICS_CAPS
+ * Userspace query for frontend signal statistics capabilities
+ */
+#define FE_STATISTICS_CAPS		_IOR('o', 84, struct fecap_statistics)
+
+
+/* FE_SIGNAL_LEVEL
+ * This system call provides a direct monitor of the signal, without
+ * passing through the relevant processing chains. In many cases, it
+ * is simply considered as direct AGC1 scaled values. This parameter
+ * can generally be used to position an antenna to while looking at
+ * a peak of this value. This parameter can be read back, even when
+ * a frontend LOCK has not been achieved. Some microntroller based
+ * demodulators do not provide a direct access to the AGC on the
+ * demodulator, hence this parameter will be Unsupported for such
+ * devices.
+ */
+#define FE_SIGNAL_LEVEL			_IOR('o', 85, __u32)
+
+
+struct fesignal_stat {
+	__u32 quality;
+	__u32 strength;
+	__u32 error;
+	__u32 unc;
+};
+
+/* FE_SIGNAL_STATS
+ * This system call provides a snapshot of all the receiver system
+ * at any given point of time. System signal statistics are always
+ * computed with respect to time and is best obtained the nearest
+ * to each of the individual parameters in a time domain.
+ * Signal statistics are assumed, "at any given instance of time".
+ * It is not possible to get a snapshot at the exact single instance
+ * and hence we look at the nearest instance, in the time domain.
+ * The statistics are described by the FE_STATISTICS_CAPS ioctl,
+ * ie. based on the device capabilities.
+ */
+#define FE_SIGNAL_STATS			_IOR('o', 86, struct fesignal_stat)
+
+
 #endif /*_DVBFRONTEND_H_*/
--------------000102060300000201090801
Content-Type: text/x-csrc;
 name="femon-ng.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="femon-ng.c"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>

#include <sys/param.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <sys/poll.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <string.h>

#include "frontend.h"

enum fetype {
	FETYPE_DVBS,
	FETYPE_DVBC,
	FETYPE_DVBT,
	FETYPE_ATSC,
};

struct fehandle {
	int fd;
	enum fetype type;
	char *name;
};

#define MAX_LEN	256

enum feinfo_mask {
	FEINFO_LOCKSTATUS		= 0x001,
	FEINFO_FEPARAMS			= 0x002,
	FEINFO_BER			= 0x004,
	FEINFO_SIGNAL_STRENGTH		= 0x008,
	FEINFO_SNR			= 0x010,
	FEINFO_UNCORRECTED_BLOCKS	= 0x020,
	FEINFO_SIGNAL_LEVEL		= 0x040,
	FEINFO_STATISTICS_CAPS		= 0x080,
	FEINFO_STATISTICS		= 0x100,
};


enum dvbfe_spectral_inversion {
	DVBFE_INVERSION_OFF,
	DVBFE_INVERSION_ON,
	DVBFE_INVERSION_AUTO
};

enum dvbfe_code_rate {
	DVBFE_FEC_NONE,
	DVBFE_FEC_1_2,
	DVBFE_FEC_2_3,
	DVBFE_FEC_3_4,
	DVBFE_FEC_4_5,
	DVBFE_FEC_5_6,
	DVBFE_FEC_6_7,
	DVBFE_FEC_7_8,
	DVBFE_FEC_8_9,
	DVBFE_FEC_AUTO
};

enum dvbfe_dvbt_const {
	DVBFE_DVBT_CONST_QPSK,
	DVBFE_DVBT_CONST_QAM_16,
	DVBFE_DVBT_CONST_QAM_32,
	DVBFE_DVBT_CONST_QAM_64,
	DVBFE_DVBT_CONST_QAM_128,
	DVBFE_DVBT_CONST_QAM_256,
	DVBFE_DVBT_CONST_AUTO
};

enum dvbfe_dvbc_mod {
	DVBFE_DVBC_MOD_QAM_16,
	DVBFE_DVBC_MOD_QAM_32,
	DVBFE_DVBC_MOD_QAM_64,
	DVBFE_DVBC_MOD_QAM_128,
	DVBFE_DVBC_MOD_QAM_256,
	DVBFE_DVBC_MOD_AUTO,
};

enum dvbfe_atsc_mod {
	DVBFE_ATSC_MOD_QAM_64,
	DVBFE_ATSC_MOD_QAM_256,
	DVBFE_ATSC_MOD_VSB_8,
	DVBFE_ATSC_MOD_VSB_16,
	DVBFE_ATSC_MOD_AUTO
};

enum dvbfe_dvbt_transmit_mode {
	DVBFE_DVBT_TRANSMISSION_MODE_2K,
	DVBFE_DVBT_TRANSMISSION_MODE_8K,
	DVBFE_DVBT_TRANSMISSION_MODE_AUTO
};

enum dvbfe_dvbt_bandwidth {
	DVBFE_DVBT_BANDWIDTH_8_MHZ,
	DVBFE_DVBT_BANDWIDTH_7_MHZ,
	DVBFE_DVBT_BANDWIDTH_6_MHZ,
	DVBFE_DVBT_BANDWIDTH_AUTO
};

enum dvbfe_dvbt_guard_interval {
	DVBFE_DVBT_GUARD_INTERVAL_1_32,
	DVBFE_DVBT_GUARD_INTERVAL_1_16,
	DVBFE_DVBT_GUARD_INTERVAL_1_8,
	DVBFE_DVBT_GUARD_INTERVAL_1_4,
	DVBFE_DVBT_GUARD_INTERVAL_AUTO
};

enum dvbfe_dvbt_hierarchy {
	DVBFE_DVBT_HIERARCHY_NONE,
	DVBFE_DVBT_HIERARCHY_1,
	DVBFE_DVBT_HIERARCHY_2,
	DVBFE_DVBT_HIERARCHY_4,
	DVBFE_DVBT_HIERARCHY_AUTO
};

struct dvbfe_parameters {
	uint32_t frequency;
	enum dvbfe_spectral_inversion inversion;
	union {
		struct {
			uint32_t			symbol_rate;
			enum dvbfe_code_rate		fec_inner;
		} dvbs;

		struct {
			uint32_t			symbol_rate;
			enum dvbfe_code_rate		fec_inner;
			enum dvbfe_dvbc_mod		modulation;
		} dvbc;

		struct {
			enum dvbfe_dvbt_bandwidth	bandwidth;
			enum dvbfe_code_rate		code_rate_HP;
			enum dvbfe_code_rate		code_rate_LP;
			enum dvbfe_dvbt_const		constellation;
			enum dvbfe_dvbt_transmit_mode	transmission_mode;
			enum dvbfe_dvbt_guard_interval	guard_interval;
			enum dvbfe_dvbt_hierarchy	hierarchy_information;
		} dvbt;

		struct {
			enum dvbfe_atsc_mod		modulation;
		} atsc;
	} u;
};

struct dvbfe_info {
	enum fetype type;			/* always retrieved */
	const char *name;			/* always retrieved */
	unsigned int signal     : 1;		/* } DVBFE_INFO_LOCKSTATUS */
	unsigned int carrier    : 1;		/* } */
	unsigned int viterbi    : 1;		/* } */
	unsigned int sync       : 1;		/* } */
	unsigned int lock       : 1;		/* } */

	/* old */
	struct dvbfe_parameters feparams;	/* DVBFE_INFO_FEPARAMS */
	uint32_t ber;				/* DVBFE_INFO_BER */
	uint16_t signal_strength;		/* DVBFE_INFO_SIGNAL_STRENGTH */
	uint16_t snr;				/* DVBFE_INFO_SNR */
	uint32_t ucblocks;			/* DVBFE_INFO_UNCORRECTED_BLOCKS */

	/* extended */
	uint32_t level;				/* FEINFO_SIGNAL_LEVEL */
						/* FEINFO_STATISTICS_CAPS */
	float quality;				/* FEINFO_STATISTICS */
	float strength;
	float error;
	uint32_t unc;

	enum fecap_quality_params	qparams;
	enum fecap_scale_params		qscale;
	enum fecap_scale_params		sscale;
	enum fecap_error_params		eparams;

	/* Exponents */
	int32_t qexp;
	int32_t sexp;
	int32_t eexp;
};

static char *usage_str =
    "\nusage: femon-ng [options]\n"
    "     -a number : use given adapter (default 0)\n"
    "     -f number : use given frontend (default 0)\n"
    "     -c number : samples to take (default 0 = infinite)\n\n";

static void usage(void)
{
	fprintf(stderr, usage_str);
	exit(1);
}

static int dvbfe_get_info(struct fehandle *handle,
			  enum feinfo_mask mask,
			  struct dvbfe_info *result,
			  int timeout)
{
	int returnval = 0;
	struct dvb_frontend_event event;
	struct fecap_statistics caps;
	struct fesignal_stat stats;

	uint32_t signal;

	result->name = handle->name;
	result->type = handle->type;

	/* Signal level without LOCK */
	if (mask & FEINFO_SIGNAL_LEVEL) {
		if (!ioctl(handle->fd, FE_SIGNAL_LEVEL, &signal))
			return -1;

		result->level = signal;
	}

	/* Frontend Signal statistics capability */
	if (mask & FEINFO_STATISTICS_CAPS) {
		if (!ioctl(handle->fd, FE_STATISTICS_CAPS, &caps))
			return -1;

		result->qparams = caps.quality.params;
		result->qscale = caps.quality.scale;
		result->qexp = caps.quality.exponent;
		result->sscale = caps.strength.params;
		result->sexp = caps.strength.exponent;
		result->eparams = caps.error.params;
		result->eexp = caps.error.exponent;
	}

	/* Useful signal statistics after LOCK */
	if (mask & FEINFO_STATISTICS) {
		if (!ioctl(handle->fd, FE_SIGNAL_STATS, &stats))
			return -1;

		result->quality		= stats.quality;
		result->strength	= stats.strength;
		result->error		= stats.error;
		result->unc		= stats.unc;
	}

	if (mask & FEINFO_LOCKSTATUS) {
		if (!ioctl(handle->fd, FE_READ_STATUS, &event.status))
			return -1;

		result->signal		= event.status & FE_HAS_SIGNAL ? 1 : 0;
		result->carrier		= event.status & FE_HAS_CARRIER ? 1 : 0;
		result->viterbi		= event.status & FE_HAS_VITERBI ? 1 : 0;
		result->viterbi		= event.status & FE_HAS_LOCK ? 1 : 0;
	}

	if (mask & FEINFO_FEPARAMS) {
		if (!ioctl(handle->fd, FE_GET_FRONTEND, &event.parameters))
			return -1;

		result->feparams.frequency = event.parameters.frequency;
		result->feparams.inversion = event.parameters.inversion;

		switch (handle->type) {
		case FE_QPSK:
			result->feparams.u.dvbs.symbol_rate = event.parameters.u.qpsk.symbol_rate;
			result->feparams.u.dvbs.fec_inner = event.parameters.u.qpsk.fec_inner;
			break;

		case FE_QAM:
			result->feparams.u.dvbc.symbol_rate = event.parameters.u.qpsk.symbol_rate;
			result->feparams.u.dvbc.fec_inner = event.parameters.u.qam.fec_inner;
			result->feparams.u.dvbc.modulation = event.parameters.u.qam.modulation;
			break;

		case FE_OFDM:
			result->feparams.u.dvbt.bandwidth = event.parameters.u.ofdm.bandwidth;
			result->feparams.u.dvbt.code_rate_HP = event.parameters.u.ofdm.code_rate_HP;
			result->feparams.u.dvbt.code_rate_LP = event.parameters.u.ofdm.code_rate_LP;
			result->feparams.u.dvbt.constellation = event.parameters.u.ofdm.constellation;
			result->feparams.u.dvbt.transmission_mode = event.parameters.u.ofdm.transmission_mode;
			result->feparams.u.dvbt.guard_interval = event.parameters.u.ofdm.guard_interval;
			result->feparams.u.dvbt.hierarchy_information = event.parameters.u.ofdm.hierarchy_information;
			break;

		case FE_ATSC:
			result->feparams.u.atsc.modulation = event.parameters.u.vsb.modulation;
			break;
		}

	}

	if (mask & FEINFO_BER) {
		if (!ioctl(handle->fd, FE_READ_BER, &result->ber))
			return-1;
	}

	if (mask & FEINFO_SIGNAL_STRENGTH) {
		if (!ioctl(handle->fd, FE_READ_SIGNAL_STRENGTH, &result->signal_strength))
			return -1;
	}

	if (mask & FEINFO_SNR) {
		if (!ioctl(handle->fd, FE_READ_SNR, &result->snr))
			return -1;
	}

	if (mask & FEINFO_UNCORRECTED_BLOCKS) {
		if (!ioctl(handle->fd, FE_READ_UNCORRECTED_BLOCKS, &result->ucblocks))
			return -1;
	}

	return 0;
}


static int check_frontend(struct fehandle *handle, unsigned int count)
{
	struct dvbfe_info fe_info;
	unsigned int samples = 0;

	char *qparams_txt[]	= {"?", "SNR", "CNR", "Es/No", "Eb/No", "REL"};
	char *qscale_txt[]	= {"?", "dB", "%"};
	char *strength_txt[]	= {"?", "dB", "%"};
	char *error_txt[]	= {"?", "BER", "PER"};

	if (dvbfe_get_info(handle, FEINFO_STATISTICS_CAPS, &fe_info, 0)) {
		fprintf(stderr, "Extended signal operation not supported\n");
		return -1;
	}

	do {
		if (dvbfe_get_info(handle, FEINFO_STATISTICS, &fe_info, 0)) {
			fprintf(stderr, "Error retrieving statistics\n");
			return -1;
		}

		printf("Quality %d (%s) %s ^%d | Strength %d (%s) ^%d | Errors %d %s e^%d | UNC %d | FE_HAS_LOCK",
		       fe_info.quality,
		       qparams_txt[fe_info.qparams],
		       qscale_txt[fe_info.qscale],
		       fe_info.qexp,
		       fe_info.strength,
		       strength_txt[fe_info.sscale],
		       fe_info.sexp,
		       fe_info.error,
		       error_txt[fe_info.eparams],
		       fe_info.unc,
		       fe_info.eexp);

		fflush(stdout);
		usleep(1000000);
		samples++;
	} while ((!count) || (count - samples));

	return 0;
}

struct fehandle *fe_open(int adapter, int frontend, int readonly)
{
	char filename[MAX_LEN + 1];
	struct fehandle *handle;
	int fd;
	struct dvb_frontend_info info;

	/* flags */
	int flags = O_RDWR;
	if (readonly)
		flags = O_RDONLY;

	/* open */
	sprintf(filename, "/dev/dvb/adapter%i/frontend%i", adapter, frontend);
	if ((fd = open(filename, flags)) < 0)
			return NULL;

	/* determine frontend type */
	if (ioctl(fd, FE_GET_INFO, &info)) {
		close(fd);
		return NULL;
	}

	handle = (struct fehandle *) malloc(sizeof (struct fehandle));
	memset(handle, 0, sizeof (struct fehandle));
	handle->fd = fd;

	switch(info.type) {
	case FE_QPSK:
		handle->type = FETYPE_DVBS;
		break;

	case FE_QAM:
		handle->type = FETYPE_DVBC;
		break;

	case FE_OFDM:
		handle->type = FETYPE_DVBT;
		break;

	case FE_ATSC:
		handle->type = FETYPE_ATSC;
		break;
	}

	handle->name = strndup(info.name, sizeof (info.name));
	return handle;
}

void fe_close(struct fehandle *handle)
{
	close(handle->fd);
	free(handle->name);
	free(handle);
}

static int monitor(unsigned int adapter,
		   unsigned int frontend,
		   unsigned int count)
{
	int result;

	struct fehandle *handle;
	struct dvbfe_info fe_info;
	char *fe_type = "UNKNOWN";

	handle = fe_open(adapter, frontend, 1);
	if (handle == NULL) {
		perror("opening frontend failed");
		return 0;
	}

	dvbfe_get_info(handle, 0, &fe_info, 0);

	switch(fe_info.type) {
	case FETYPE_DVBS:
		fe_type = "DVBS";
		break;
	case FETYPE_DVBC:
		fe_type = "DVBC";
		break;
	case FETYPE_DVBT:
		fe_type = "DVBT";
		break;
	case FETYPE_ATSC:
		fe_type = "ATSC";
		break;
	}
	printf("FE: %s (%s)\n", fe_info.name, fe_type);
	result = check_frontend(handle, count);
	fe_close(handle);

	return result;
}

int main(int argc, char *argv[])
{
	unsigned int adapter = 0, frontend = 0, count = 0;
	int opt;

	while ((opt = getopt(argc, argv, "a:f:c")) != -1) {
		switch (opt) {
		default:
			usage();
			break;
		case 'a':
			adapter = strtoul(optarg, NULL, 0);
			break;
		case 'f':
			frontend = strtoul(optarg, NULL, 0);
			break;
		case 'c':
			count = strtoul(optarg, NULL, 0);
			break;
		}
	}

	monitor(adapter, frontend, count);

	return 0;
}

--------------000102060300000201090801--
