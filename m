Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:60865 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966200AbZLHVqI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2009 16:46:08 -0500
Received: by fxm5 with SMTP id 5so6778445fxm.28
        for <linux-media@vger.kernel.org>; Tue, 08 Dec 2009 13:46:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B1E532C.9040903@redhat.com>
References: <4B1E1974.6000207@jusst.de> <4B1E532C.9040903@redhat.com>
Date: Wed, 9 Dec 2009 01:46:12 +0400
Message-ID: <1a297b360912081346k45b7844bg5d408d47a38da5b4@mail.gmail.com>
Subject: Re: New DVB-Statistics API
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Julian Scheel <julian@jusst.de>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 8, 2009 at 5:22 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Hi Julian,
>
> Let me add some corrections to your technical analysis.
>
> Julian Scheel wrote:
>> Hello together,
>>
>> after the last thread which asked about signal statistics details
>> degenerated into a discussion about the technical possibilites for
>> implementing an entirely new API, which lead to nothing so far, I wanted
>> to open a new thread to bring this forward. Maybe some more people can
>> give their votes for the different options
>>
>> Actually Manu did propose a new API for fetching enhanced statistics. It
>> uses new IOCTL to directly fetch the statistical data in one go from the
>> frontend. This propose was so far rejected by Mauro who wants to use the
>> S2API get/set calls instead.
>>
>> Now to give everyone a quick overview about the advantages and
>> disadvantages of both approaches I will try to summarize it up:
>>
>> 1st approach: Introduce new IOCTL
>>
>> Pros:
>> - Allows a quick fetch of the entire dataset, which ensures that:
>>  1. all values are fetched in one go (as long as possible) from the
>> frontend, so that they can be treated as one united and be valued in
>> conjunction
>>  2. the requested values arrive the caller in an almost constant
>> timeframe, as the ioctl is directly executed by the driver
>> - It does not interfere with the existing statistics API, which has to
>> be kept alive as it is in use for a long time already. (unifying it's
>> data is not the approach of this new API)
>>
>> Cons:
>> - Forces the application developers to interact with two APIs. The S2API
>> for tuning on the one hand and the Statistics API for reading signal
>> values on the other hand.
>>
>> 2nd approach: Set up S2API calls for reading statistics
>>
>> Pros:
>> - Continous unification of the linuxtv API, allowing all calls to be
>> made through one API. -> easy for application developers
>
> - Scaling values can be retrieved/negotiated (if we implement the set
> mode) before requesting the stats, using the same API;
>
> - API can be easily extended to support other statistics that may be needed
> by newer DTV standards.
>
>>
>> Cons:
>> - Due to the key/value pairs used for S2API getters the statistical
>> values can't be read as a unique block, so we loose the guarantee, that
>> all of the values can be treatend as one unit expressing the signals
>> state at a concrete time.
>
> You missed the point here. The proposal patch groups all S2API
> pairs into a _single_ call into the driver:
>
>> +             for (i = 0; i < tvps->num; i++)
>> +                     need_get_ops += dtv_property_prepare_get_stats(fe,
>> +                                                      tvp + i, inode, file);
>> +
>> +             if (!fe->dtv_property_cache.need_stats) {
>> +                     need_get_ops++;
>> +             } else {
>> +                     if (fe->ops.get_stats) {
>> +                             err = fe->ops.get_stats(fe);
>> +                             if (err < 0)
>> +                                     return err;
>> +                     }
>> +             }
>
> The dtv_property_prepare_get_stats will generate a bitmap field (need_stats) that
> will describe all value pairs that userspace is expecting. After doing it,
> a single call is done to get_stats() callback.
>
> All the driver need to do is to fill all values at dtv_property_cache. If the driver
> fills more values than requested by the user, the extra values will simply be discarded.
>
> In order to reduce latency, the driver may opt to not read the register values for the
> data that aren't requested by the user, like I did on cx24123 driver.
>
> Those values will all be returned at the same time to userspace by a single copy_to_user()
> operation.
>
>> - Due to the general architecture of the S2API the delay between
>> requesting and receiving the actual data could become too big to allow
>> realtime interpretation of the data (as it is needed for applications
>> like satellite finders, etc.)
>
> Not true. As pointed at the previous answer, the difference between a new ioctl
> and S2API is basically the code at dtv_property_prepare_get_stats() and
> dtv_property_process_get(). This is a pure code that uses a continuous struct
> that will likely be at L3 cache, inside the CPU chip. So, this code will run
> really quickly.



AFAIK, cache eviction occurs with syscalls: where content in the
caches near the CPU cores is pushed to the outer cores, resulting in
cache misses. Not all CPU's are equipped with L3 caches. Continuous
syscalls can result in TLB cache misses from what i understand, which
is expensive.


These are the numbers Intel lists for a Pentium M:

    To    	Cycles
    Register 	<= 1
    L1d 	~3
    L2 	~14
    Main Memory 	~240



> As current CPU's runs at the order of Teraflops (as the CPU clocks are at gigahertz
> order, and CPU's can handle multiple instructions per clock cycle), the added delay
> is in de order of nanosseconds.


Consider STB's where DVB is generally deployed rather than the small
segment of home users running a stack on a generic PC.


> On the other hand, a simple read of a value from an i2c device is in the order
> of milisseconds, since I2C serial bus, speed is slow (typically operating at
> 100 Kbps).
>
> So, the delay is determined by the number of I2C calls you have at the code.


Hardware I/O is the most expensive operation involved. The number of
I2C calls is not a ground for comparison, see the latter part of the
mail.


> With the new ioctl proposal, as you need to read all data from I2C (even the ones
> that userspace don't need), you'll have two situations:
>        - if you use S2API call to request all data provided by ioctl approach,
> the delay will be the same;
>        - if you use S2API call to request less stats, the S2API delay will
> be shorter.
>
> For example, with cx24123, the S2API delay it will be 6 times shorter than the
> ioctl, if you request just the signal strength - as just one read is needed
> to get signal strength, while you need to do 6 reads to get all 3 stats.
>
> So, if you want to do some realtime usage and delay is determinant, a call
> via S2API containing just the values you need will be better than the new
> ioctl call.

Case #1: The ioctl approach


+struct fecap_statistics {
+       struct fecap_quality            quality;
+       struct fecap_strength           strength;
+       struct fecap_error              error;
+       enum fecap_unc_params           unc;
+};

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
+#define FE_SIGNAL_STATS                        _IOR('o', 86, struct
fesignal_stat)

+	case FE_SIGNAL_STATS:
+		if (fe->ops.read_stats)
+			err = fe->ops.read_stats(fe, (struct fesignal_stat *) parg);
+		break;



+static int stb0899_read_stats(struct dvb_frontend *fe, struct
fesignal_stat *stats)
+{
+}

This is as simple as it can get






Now Case #2: based on s2api

struct dtv_property {
	__u32 cmd;
	__u32 reserved[3];
	union {
		__u32 data;
		struct {
			__u8 data[32];
			__u32 len;
			__u32 reserved1[3];
			void *reserved2;
		} buffer;
	} u;
	int result;
} __attribute__ ((packed));

struct dtv_properties {
	__u32 num;
	struct dtv_property *props;
};

#define FE_GET_PROPERTY		   _IOR('o', 83, struct dtv_properties)


#define _DTV_CMD(n, s, b) \
[n] = { \
	.name = #n, \
	.cmd  = n, \
	.set  = s,\
	.buffer = b \
}

static int dtv_property_process_get(struct dvb_frontend *fe,
				    struct dtv_property *tvp,
				    struct inode *inode, struct file *file)
{
	int r = 0;

	dtv_property_dump(tvp);

	/* Allow the frontend to validate incoming properties */
	if (fe->ops.get_property)
		r = fe->ops.get_property(fe, tvp);

	if (r < 0)
		return r;

	switch(tvp->cmd) {
	case DTV_FREQUENCY:
		tvp->u.data = fe->dtv_property_cache.frequency;
		break;
	case DTV_MODULATION:
		tvp->u.data = fe->dtv_property_cache.modulation;
		break;
	case DTV_BANDWIDTH_HZ:
		tvp->u.data = fe->dtv_property_cache.bandwidth_hz;
		break;
	case DTV_INVERSION:
		tvp->u.data = fe->dtv_property_cache.inversion;
		break;
	case DTV_SYMBOL_RATE:
		tvp->u.data = fe->dtv_property_cache.symbol_rate;
		break;
	case DTV_INNER_FEC:
		tvp->u.data = fe->dtv_property_cache.fec_inner;
		break;
	case DTV_PILOT:
		tvp->u.data = fe->dtv_property_cache.pilot;
		break;
	case DTV_ROLLOFF:
		tvp->u.data = fe->dtv_property_cache.rolloff;
		break;
	case DTV_DELIVERY_SYSTEM:
		tvp->u.data = fe->dtv_property_cache.delivery_system;
		break;
	case DTV_VOLTAGE:
		tvp->u.data = fe->dtv_property_cache.voltage;
		break;
	case DTV_TONE:
		tvp->u.data = fe->dtv_property_cache.sectone;
		break;
	case DTV_API_VERSION:
		tvp->u.data = (DVB_API_VERSION << 8) | DVB_API_VERSION_MINOR;
		break;
	case DTV_CODE_RATE_HP:
		tvp->u.data = fe->dtv_property_cache.code_rate_HP;
		break;
	case DTV_CODE_RATE_LP:
		tvp->u.data = fe->dtv_property_cache.code_rate_LP;
		break;
	case DTV_GUARD_INTERVAL:
		tvp->u.data = fe->dtv_property_cache.guard_interval;
		break;
	case DTV_TRANSMISSION_MODE:
		tvp->u.data = fe->dtv_property_cache.transmission_mode;
		break;
	case DTV_HIERARCHY:
		tvp->u.data = fe->dtv_property_cache.hierarchy;
		break;

	/* ISDB-T Support here */
	case DTV_ISDBT_PARTIAL_RECEPTION:
		tvp->u.data = fe->dtv_property_cache.isdbt_partial_reception;
		break;
	case DTV_ISDBT_SOUND_BROADCASTING:
		tvp->u.data = fe->dtv_property_cache.isdbt_sb_mode;
		break;
	case DTV_ISDBT_SB_SUBCHANNEL_ID:
		tvp->u.data = fe->dtv_property_cache.isdbt_sb_subchannel;
		break;
	case DTV_ISDBT_SB_SEGMENT_IDX:
		tvp->u.data = fe->dtv_property_cache.isdbt_sb_segment_idx;
		break;
	case DTV_ISDBT_SB_SEGMENT_COUNT:
		tvp->u.data = fe->dtv_property_cache.isdbt_sb_segment_count;
		break;
	case DTV_ISDBT_LAYER_ENABLED:
		tvp->u.data = fe->dtv_property_cache.isdbt_layer_enabled;
		break;
	case DTV_ISDBT_LAYERA_FEC:
		tvp->u.data = fe->dtv_property_cache.layer[0].fec;
		break;
	case DTV_ISDBT_LAYERA_MODULATION:
		tvp->u.data = fe->dtv_property_cache.layer[0].modulation;
		break;
	case DTV_ISDBT_LAYERA_SEGMENT_COUNT:
		tvp->u.data = fe->dtv_property_cache.layer[0].segment_count;
		break;
	case DTV_ISDBT_LAYERA_TIME_INTERLEAVING:
		tvp->u.data = fe->dtv_property_cache.layer[0].interleaving;
		break;
	case DTV_ISDBT_LAYERB_FEC:
		tvp->u.data = fe->dtv_property_cache.layer[1].fec;
		break;
	case DTV_ISDBT_LAYERB_MODULATION:
		tvp->u.data = fe->dtv_property_cache.layer[1].modulation;
		break;
	case DTV_ISDBT_LAYERB_SEGMENT_COUNT:
		tvp->u.data = fe->dtv_property_cache.layer[1].segment_count;
		break;
	case DTV_ISDBT_LAYERB_TIME_INTERLEAVING:
		tvp->u.data = fe->dtv_property_cache.layer[1].interleaving;
		break;
	case DTV_ISDBT_LAYERC_FEC:
		tvp->u.data = fe->dtv_property_cache.layer[2].fec;
		break;
	case DTV_ISDBT_LAYERC_MODULATION:
		tvp->u.data = fe->dtv_property_cache.layer[2].modulation;
		break;
	case DTV_ISDBT_LAYERC_SEGMENT_COUNT:
		tvp->u.data = fe->dtv_property_cache.layer[2].segment_count;
		break;
	case DTV_ISDBT_LAYERC_TIME_INTERLEAVING:
		tvp->u.data = fe->dtv_property_cache.layer[2].interleaving;
		break;
	case DTV_ISDBS_TS_ID:
		tvp->u.data = fe->dtv_property_cache.isdbs_ts_id;
		break;
	default:
		r = -1;
	}

	return r;
}


static int dvb_frontend_ioctl_properties(struct inode *inode, struct file *file,
			unsigned int cmd, void *parg)
{
	struct dvb_device *dvbdev = file->private_data;
	struct dvb_frontend *fe = dvbdev->priv;
	int err = 0;

	struct dtv_properties *tvps = NULL;
	struct dtv_property *tvp = NULL;
	int i;

	dprintk("%s\n", __func__);

	if(cmd == FE_SET_PROPERTY) {
		tvps = (struct dtv_properties __user *)parg;

		dprintk("%s() properties.num = %d\n", __func__, tvps->num);
		dprintk("%s() properties.props = %p\n", __func__, tvps->props);

		/* Put an arbitrary limit on the number of messages that can
		 * be sent at once */
		if ((tvps->num == 0) || (tvps->num > DTV_IOCTL_MAX_MSGS))
			return -EINVAL;

		tvp = (struct dtv_property *) kmalloc(tvps->num *
			sizeof(struct dtv_property), GFP_KERNEL);
		if (!tvp) {
			err = -ENOMEM;
			goto out;
		}

		if (copy_from_user(tvp, tvps->props, tvps->num * sizeof(struct
dtv_property))) {
			err = -EFAULT;
			goto out;
		}

		for (i = 0; i < tvps->num; i++) {
			(tvp + i)->result = dtv_property_process_set(fe, tvp + i, inode, file);
			err |= (tvp + i)->result;
		}

		if(fe->dtv_property_cache.state == DTV_TUNE)
			dprintk("%s() Property cache is full, tuning\n", __func__);

	} else
	if(cmd == FE_GET_PROPERTY) {

		tvps = (struct dtv_properties __user *)parg;

		dprintk("%s() properties.num = %d\n", __func__, tvps->num);
		dprintk("%s() properties.props = %p\n", __func__, tvps->props);

		/* Put an arbitrary limit on the number of messages that can
		 * be sent at once */
		if ((tvps->num == 0) || (tvps->num > DTV_IOCTL_MAX_MSGS))
			return -EINVAL;

		tvp = (struct dtv_property *) kmalloc(tvps->num *
			sizeof(struct dtv_property), GFP_KERNEL);
		if (!tvp) {
			err = -ENOMEM;
			goto out;
		}

		if (copy_from_user(tvp, tvps->props, tvps->num * sizeof(struct
dtv_property))) {
			err = -EFAULT;
			goto out;
		}

		for (i = 0; i < tvps->num; i++) {
			(tvp + i)->result = dtv_property_process_get(fe, tvp + i, inode, file);
			err |= (tvp + i)->result;
		}

		if (copy_to_user(tvps->props, tvp, tvps->num * sizeof(struct dtv_property))) {
			err = -EFAULT;
			goto out;
		}

	} else
		err = -EOPNOTSUPP;

out:
	kfree(tvp);
	return err;
}

+static int dtv_property_prepare_get_stats(struct dvb_frontend *fe,
+                                   struct dtv_property *tvp,
+                                   struct inode *inode, struct file *file)
+{
+       switch (tvp->cmd) {
+       case DTV_FE_QUALITY:
+               fe->dtv_property_cache.need_stats |= FE_NEED_QUALITY;
+               break;
+       case DTV_FE_QUALITY_UNIT:
+               fe->dtv_property_cache.need_stats |= FE_NEED_QUALITY_UNIT;
+               break;
+       case DTV_FE_STRENGTH:
+               fe->dtv_property_cache.need_stats |= FE_NEED_STRENGTH;
+               break;
+       case DTV_FE_STRENGTH_UNIT:
+               fe->dtv_property_cache.need_stats |= FE_NEED_STRENGTH_UNIT;
+               break;
+       case DTV_FE_ERROR:
+               fe->dtv_property_cache.need_stats |= FE_NEED_ERROR;
+               break;
+       case DTV_FE_ERROR_UNIT:
+               fe->dtv_property_cache.need_stats |= FE_NEED_ERROR_UNIT;
+               break;
+       case DTV_FE_SIGNAL:
+               fe->dtv_property_cache.need_stats |= FE_NEED_SIGNAL;
+               break;
+       case DTV_FE_SIGNAL_UNIT:
+               fe->dtv_property_cache.need_stats |= FE_NEED_SIGNAL_UNIT;
+               break;
+       case DTV_FE_UNC:
+               fe->dtv_property_cache.need_stats |= FE_NEED_SIGNAL;
+               break;
+       case DTV_FE_UNC_UNIT:
+               fe->dtv_property_cache.need_stats |= FE_NEED_SIGNAL_UNIT;
+               break;
+       default:
+               return 1;
+       };
+
+       return 0;
+}
+
 static int dtv_property_process_get(struct dvb_frontend *fe,
                                   struct dtv_property *tvp,
-                                   struct inode *inode, struct file *file)
+                                   struct inode *inode, struct file *file,
+                                   int need_get_ops)
 {
       int r = 0;

       dtv_property_dump(tvp);

       /* Allow the frontend to validate incoming properties */
-       if (fe->ops.get_property)
+       if (fe->ops.get_property && need_get_ops)
               r = fe->ops.get_property(fe, tvp);

       if (r < 0)
@@ -1329,6 +1382,38 @@ static int dtv_property_process_get(stru
       case DTV_ISDBS_TS_ID:
               tvp->u.data = fe->dtv_property_cache.isdbs_ts_id;
               break;
+
+       /* Quality measures */
+       case DTV_FE_QUALITY:
+               tvp->u.data = fe->dtv_property_cache.quality;
+               break;
+       case DTV_FE_QUALITY_UNIT:
+               tvp->u.data = fe->dtv_property_cache.quality_unit;
+               break;
+       case DTV_FE_STRENGTH:
+               tvp->u.data = fe->dtv_property_cache.strength;
+               break;
+       case DTV_FE_STRENGTH_UNIT:
+               tvp->u.data = fe->dtv_property_cache.strength_unit;
+               break;
+       case DTV_FE_ERROR:
+               tvp->u.data = fe->dtv_property_cache.error;
+               break;
+       case DTV_FE_ERROR_UNIT:
+               tvp->u.data = fe->dtv_property_cache.error_unit;
+               break;
+       case DTV_FE_SIGNAL:
+               tvp->u.data = fe->dtv_property_cache.signal;
+               break;
+       case DTV_FE_SIGNAL_UNIT:
+               tvp->u.data = fe->dtv_property_cache.signal_unit;
+               break;
+       case DTV_FE_UNC:
+               tvp->u.data = fe->dtv_property_cache.signal;
+               break;
+       case DTV_FE_UNC_UNIT:
+               tvp->u.data = fe->dtv_property_cache.signal_unit;
+               break;
       default:
               r = -1;
       }
@@ -1527,7 +1612,7 @@ static int dvb_frontend_ioctl_properties
 {
       struct dvb_device *dvbdev = file->private_data;
       struct dvb_frontend *fe = dvbdev->priv;
-       int err = 0;
+       int err = 0, need_get_ops;

       struct dtv_properties *tvps = NULL;
       struct dtv_property *tvp = NULL;
@@ -1591,8 +1676,29 @@ static int dvb_frontend_ioctl_properties
                       goto out;
               }

+               /*
+               * Do all get operations at once, instead of handling them
+               * individually
+               */
+               need_get_ops = 0;
+               fe->dtv_property_cache.need_stats = 0;
+               for (i = 0; i < tvps->num; i++)
+                       need_get_ops += dtv_property_prepare_get_stats(fe,
+                                                        tvp + i, inode, file);
+
+               if (!fe->dtv_property_cache.need_stats) {
+                       need_get_ops++;
+               } else {
+                       if (fe->ops.get_stats) {
+                               err = fe->ops.get_stats(fe);
+                               if (err < 0)
+                                       return err;
+                       }
+               }
+
               for (i = 0; i < tvps->num; i++) {
-                       (tvp + i)->result =
dtv_property_process_get(fe, tvp + i, inode, file);
+                       (tvp + i)->result = dtv_property_process_get(fe,
+                                       tvp + i, inode, file, need_get_ops);
                       err |= (tvp + i)->result;
               }




Now that we can see the actual code flow, we can see the s2api
approach requires an unnecessary large tokenizer/serializer, involving
multiple function calls. Additionally you would require to clear the
cache similarly as in

static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
{
	int i;

	memset(&(fe->dtv_property_cache), 0,
			sizeof(struct dtv_frontend_properties));

	fe->dtv_property_cache.state = DTV_CLEAR;
	fe->dtv_property_cache.delivery_system = SYS_UNDEFINED;
	fe->dtv_property_cache.inversion = INVERSION_AUTO;
	fe->dtv_property_cache.fec_inner = FEC_AUTO;
	fe->dtv_property_cache.transmission_mode = TRANSMISSION_MODE_AUTO;
	fe->dtv_property_cache.bandwidth_hz = BANDWIDTH_AUTO;
	fe->dtv_property_cache.guard_interval = GUARD_INTERVAL_AUTO;
	fe->dtv_property_cache.hierarchy = HIERARCHY_AUTO;
	fe->dtv_property_cache.symbol_rate = QAM_AUTO;
	fe->dtv_property_cache.code_rate_HP = FEC_AUTO;
	fe->dtv_property_cache.code_rate_LP = FEC_AUTO;

	fe->dtv_property_cache.isdbt_partial_reception = -1;
	fe->dtv_property_cache.isdbt_sb_mode = -1;
	fe->dtv_property_cache.isdbt_sb_subchannel = -1;
	fe->dtv_property_cache.isdbt_sb_segment_idx = -1;
	fe->dtv_property_cache.isdbt_sb_segment_count = -1;
	fe->dtv_property_cache.isdbt_layer_enabled = 0x7;
	for (i = 0; i < 3; i++) {
		fe->dtv_property_cache.layer[i].fec = FEC_AUTO;
		fe->dtv_property_cache.layer[i].modulation = QAM_AUTO;
		fe->dtv_property_cache.layer[i].interleaving = -1;
		fe->dtv_property_cache.layer[i].segment_count = -1;
	}

	return 0;
}

Let's assume for the time being that you don't need the clear, to make
things clearer.


Aspect #1. Comparing Case #1 and Case #2, i guess anyone will agree
that case 2 has very much code overhead in terms of the serialization
and serialization set/unset.

Aspect #2, Comparing the data payload between Case #1 and Case #2, i
guess anyone can see the size of the data structure and come to a
conclusion without a second thought that case #2 has many many times
the payload size as in Case #1

Also there is no guarantee that all these function calls are going to
give you "in-sync" statistics data for real time applications.

Now: We are talking about a small system such as a STB where this is
going to run.

Signal statistics are polled continuously in many applications to
check for LNB drift etc (some of the good applications do that).
Statistics are not just used alone to display a signal graph alone.
These STB's have very small CPU's in the order of 400MHz etc, but not
as one sees in a regular PC in the order of a few GHz and teraflop
operations. There are still smaller applications, what I am pointing
out here is a large majority of the small CPU user segment.

Another example is a headless IPTV headend. Small CPU's on it too..

Another example of a continuous polling is a gyro based setup where a
rotor controls the antenna position, the position of which is based
from the RF signal in question. Syscalls rates are considerably higher
in this case.

As you can see, the serializer/tokenizer approach introduces an
unwanted/redundant additional load.

Other than that, we don't have numerous parameters that we are in need
of a serializer to handle 4 parameters. 4 x 4bytes.


Now, let me get back to your cx24123 example.

+static int cx24123_get_stats(struct dvb_frontend* fe)
+{
+       struct cx24123_state *state = fe->demodulator_priv;
+       struct dtv_frontend_properties *prop = &fe->dtv_property_cache;
+
+       if (fe->dtv_property_cache.need_stats & FE_NEED_STRENGTH) {
+               /* larger = better */
+               prop->strength = cx24123_readreg(state, 0x3b) << 8;
+                       dprintk("Signal strength = %d\n", prop->strength);
+               fe->dtv_property_cache.need_stats &= ~FE_NEED_STRENGTH;
+       }
+
+       if (fe->dtv_property_cache.need_stats & FE_NEED_STRENGTH_UNIT) {
+               /* larger = better */
+               prop->strength_unit = FE_SCALE_UNKNOWN;
+               fe->dtv_property_cache.need_stats &= ~FE_NEED_STRENGTH_UNIT;
+       }
+
+       if (fe->dtv_property_cache.need_stats & FE_NEED_ERROR) {
+               /* The true bit error rate is this value divided by
+               the window size (set as 256 * 255) */
+               prop->error = ((cx24123_readreg(state, 0x1c) & 0x3f) << 16) |
+                              (cx24123_readreg(state, 0x1d) << 8 |
+                              cx24123_readreg(state, 0x1e));
+
+               dprintk("BER = %d\n", prop->error);
+
+               fe->dtv_property_cache.need_stats &= ~FE_NEED_ERROR;
+       }
+
+       if (fe->dtv_property_cache.need_stats & FE_NEED_ERROR_UNIT) {
+               /* larger = better */
+               prop->strength_unit = FE_ERROR_BER;
+               fe->dtv_property_cache.need_stats &= ~FE_NEED_ERROR_UNIT;
+       }
+
+       if (fe->dtv_property_cache.need_stats & FE_NEED_QUALITY) {
+               /* Inverted raw Es/N0 count, totally bogus but better than the
+                  BER threshold. */
+               prop->quality = 65535 - (((u16)cx24123_readreg(state,
0x18) << 8) |
+                                         (u16)cx24123_readreg(state, 0x19));
+
+               dprintk("read S/N index = %d\n", prop->quality);
+
+               fe->dtv_property_cache.need_stats &= ~FE_NEED_QUALITY;
+       }
+
+       if (fe->dtv_property_cache.need_stats & FE_NEED_QUALITY_UNIT) {
+               /* larger = better */
+               prop->strength_unit = FE_QUALITY_EsNo;
+               fe->dtv_property_cache.need_stats &= ~FE_NEED_QUALITY_UNIT;
+       }
+
+       /* Check if userspace requested a parameter that we can't handle*/
+       if (fe->dtv_property_cache.need_stats)
+               return -EINVAL;
+
+       return 0;
+}
+

 /*
 * Configured to return the measurement of errors in blocks,
 * because no UCBLOCKS value is available, so this value doubles up
@@ -897,43 +957,30 @@ static int cx24123_read_status(struct dv
 */
 static int cx24123_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
-       struct cx24123_state *state = fe->demodulator_priv;
+       fe->dtv_property_cache.need_stats = FE_NEED_ERROR;
+       cx24123_get_stats(fe);

-       /* The true bit error rate is this value divided by
-          the window size (set as 256 * 255) */
-       *ber = ((cx24123_readreg(state, 0x1c) & 0x3f) << 16) |
-               (cx24123_readreg(state, 0x1d) << 8 |
-                cx24123_readreg(state, 0x1e));
-
-       dprintk("BER = %d\n", *ber);
-
+       *ber = fe->dtv_property_cache.error;
       return 0;
 }

 static int cx24123_read_signal_strength(struct dvb_frontend *fe,
       u16 *signal_strength)
 {
-       struct cx24123_state *state = fe->demodulator_priv;
-
-       /* larger = better */
-       *signal_strength = cx24123_readreg(state, 0x3b) << 8;
-
-       dprintk("Signal strength = %d\n", *signal_strength);
-
+       fe->dtv_property_cache.need_stats = FE_NEED_STRENGTH;
+       cx24123_get_stats(fe);
+       *signal_strength = fe->dtv_property_cache.strength;
       return 0;
 }

+
 static int cx24123_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
-       struct cx24123_state *state = fe->demodulator_priv;
-
       /* Inverted raw Es/N0 count, totally bogus but better than the
-          BER threshold. */
-       *snr = 65535 - (((u16)cx24123_readreg(state, 0x18) << 8) |
-                        (u16)cx24123_readreg(state, 0x19));
-
-       dprintk("read S/N index = %d\n", *snr);
-
+               BER threshold. */
+       fe->dtv_property_cache.need_stats = FE_NEED_QUALITY;
+       cx24123_get_stats(fe);
+       *snr = fe->dtv_property_cache.quality;
       return 0;
 }


Now, in any of your use cases, you are in fact using the same number
of I2C calls to get a snapshot of statistics in any event of time, as
in the case of the ioctl approach. So you don't get any benefit in
using the s2api approach for I2C operation I/O time periods.

The only additional aspect that you draw in using a serializer (when
using s2api) spread out over multiple function calls, in such a fast
call use case is that, you add in the ambiguity of the time frame in
which the completed operation is presented back to the user.

So eventually, we need to consider using timing related information
sent back to the user to compensate for an ambiguous latency involved,
which makes things even more complex, ugly and unwieldy for fast and
small applications.

> The only cons I can think is that the S2API payload for a complete retrival of all
> stats will be a little bigger.

Yeah, this is another one of the side effects of using s2api, 16 bytes
in comparison to > 300 bytes

Regards,
Manu
