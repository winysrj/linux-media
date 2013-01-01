Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab3AAPBS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 10:01:18 -0500
Date: Tue, 1 Jan 2013 13:00:41 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
Subject: Re: [PATCH RFCv3] dvb: Add DVBv5 properties for quality parameters
Message-ID: <20130101130041.52dee65f@redhat.com>
In-Reply-To: <CAGoCfix=2-pXmTE149XvwT+f7j1F29L3Q-dse0y_Rc-3LKucsQ@mail.gmail.com>
References: <1356739006-22111-1-git-send-email-mchehab@redhat.com>
	<CAGoCfix=2-pXmTE149XvwT+f7j1F29L3Q-dse0y_Rc-3LKucsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 29 Dec 2012 11:36:16 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> On Fri, Dec 28, 2012 at 6:56 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > The DVBv3 quality parameters are limited on several ways:
> >         - Doesn't provide any way to indicate the used measure;
> >         - Userspace need to guess how to calculate the measure;
> >         - Only a limited set of stats are supported;
> >         - Doesn't provide QoS measure for the OFDM TPS/TMCC
> >           carriers, used to detect the network parameters for
> >           DVB-T/ISDB-T;
> >         - Can't be called in a way to require them to be filled
> >           all at once (atomic reads from the hardware), with may
> >           cause troubles on interpreting them on userspace;
> >         - On some OFDM delivery systems, the carriers can be
> >           independently modulated, having different properties.
> >           Currently, there's no way to report per-layer stats;
> > This RFC adds the header definitions meant to solve that issues.
> > After discussed, I'll write a patch for the DocBook and add support
> > for it on some demods. Support for dvbv5-zap and dvbv5-scan tools
> > will also have support for those features.
> 
> Hi Mauro,
<...>
> You have a units field which is "decibels", but in what unit?  1 dB /
> unit?  0.1 db / unit?  1/255 db / unit?  This particular issue is why
> the current snr field varies across even demods where we have the
> datasheets.  Many demods reported in 0.1 dB increments, while others
> reported in 1/255 dB increments.

There was min/max values there to allow userspace to calculate the scale,
but it seems simpler to just define a 0.1dB step.
<...>
> This needs to be defined *in the spec*,

Sure. After we agree on the API we'll be using, I'll write the spec bits
and add the logic on a driver. I did that in the past, but as the discussions
were long and no consensus was reached. So, I opted to just write the changes
at the frontend.h for the discussons.
<...>

Ok, I decided to post a version 4, removing the things that I won't be using
(that got inherited by a previous proposal from another developer sent to
the ML a few years ago).

This version defines 4 types of statistics: signal, SNR, BER, error count
at the TMCC/TPS carrier. There are just 2 possible ranges:
	dB (actually 0.1 dB);
	percentage, from 0 to 100%.

There's a third "range" type that means that a given parameter is not
available. I didn't add any bits to indicate why, as the reason may not
be relevant to userspace. It might make sense to have different types, one
for temporary unavailability and another one for permanent unavailability.

There's also one parameter to enumerate what QoS parameters are supported by
the driver. 

Regards,
Mauro

-

[RFCv4] dvb: Add DVBv5 properties for quality parameters

The DVBv3 quality parameters are limited on several ways:
	- Doesn't provide any way to indicate the used measure;
	- Userspace need to guess how to calculate the measure;
	- Only a limited set of stats are supported;
	- Doesn't provide QoS measure for the OFDM TPS/TMCC
	  carriers, used to detect the network parameters for
	  DVB-T/ISDB-T;
	- Can't be called in a way to require them to be filled
	  all at once (atomic reads from the hardware), with may
	  cause troubles on interpreting them on userspace;
	- On some OFDM delivery systems, the carriers can be
	  independently modulated, having different properties.
	  Currently, there's no way to report per-layer stats;
This RFC adds the header definitions meant to solve that issues.
After discussed, I'll write a patch for the DocBook and add support
for it on some demods. Support for dvbv5-zap and dvbv5-scan tools
will also have support for those features.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---
include/uapi/linux/dvb/frontend.h | 78 ++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/dvb/frontend.h |   60 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

v3: Just update http://patchwork.linuxtv.org/patch/9578/ to current tip

v4: API simplified and addressed some issues pointed by Devin

--- patchwork.orig/include/uapi/linux/dvb/frontend.h
+++ patchwork/include/uapi/linux/dvb/frontend.h
@@ -365,7 +365,14 @@ struct dvb_frontend_event {
 #define DTV_INTERLEAVING			60
 #define DTV_LNA					61
 
-#define DTV_MAX_COMMAND				DTV_LNA
+/* Quality parameters */
+#define DTV_ENUM_QUALITY	62	/* Enumerates supported QoS parameters */
+#define DTV_FE_SIGNAL		63	/* Signal strength at the demod */
+#define DTV_QUALITY_SNR		64	/* Signal/Noise ratio */
+#define DTV_ERROR_BER		65	/* Bit error rate since signal lock */
+#define DTV_ERROR_COUNT		66	/* Monotonic error count since signal lock at TMCC or TPS carrier */
+
+#define DTV_MAX_COMMAND		DTV_ERROR_COUNT
 
 typedef enum fe_pilot {
 	PILOT_ON,
@@ -452,12 +459,63 @@ struct dtv_cmds_h {
 	__u32	reserved:30;	/* Align */
 };
 
+/**
+ * Scale types for the quality parameters.
+ * @FE_SCALE_NOT_AVAILABLE: That QoS measure is not available. That
+ *			    could indicate a temporary or a permanent
+ *			    condition.
+ * @FE_SCALE_DECIBEL: The scale is measured in 0.1 dB steps, typically
+ *		  used on signal measures.
+ * @FE_SCALE_RELATIVE: The scale is a relative percentual measure,
+ *			ranging from 0 (0%) to 0xffff (100%).
+ */
+enum fecap_scale_params {
+	FE_SCALE_NOT_AVAILABLE,
+	FE_SCALE_DECIBEL,
+	FE_SCALE_RELATIVE
+};
+
+/**
+ * struct dtv_status - Used for reading a DTV status property
+ *
+ * @value:	value of the measure. Should range from 0 to 0xffff;
+ * @scale:	Filled with enum fecap_scale_params - the scale
+ *		in usage for that parameter
+ *
+ * For most delivery systems, this will return a single value for each
+ * parameter.
+ * It should be noticed, however, that new OFDM delivery systems like
+ * ISDB can use different modulation types for each group of carriers.
+ * On such standards, up to 8 groups of statistics can be provided, one
+ * for each carrier group (called "layer" on ISDB).
+ * In order to be consistent with other delivery systems, the first
+ * value refers to the entire set of carriers ("global").
+ * dtv_status:scale should use the value FE_SCALE_NOT_AVAILABLE when
+ * the value for the entire group of carriers or from one specific layer
+ * is not provided by the hardware.
+ * In other words, for ISDB, those values should be filled like:
+ *	stat.status[0] = global statistics;
+ *	stat.scale[0] = FE_SCALE_NOT_AVAILABLE (if not available);
+ *	stat.status[1] = layer A statistics;
+ *	stat.status[2] = layer B statistics;
+ *	stat.status[3] = layer C statistics.
+ * and stat.len should be filled with the latest filled status + 1.
+ */
+struct dtv_status {
+	__u16 value;
+	__u16 scale;
+} __attribute__ ((packed));
+
 struct dtv_property {
 	__u32 cmd;
 	__u32 reserved[3];
 	union {
 		__u32 data;
 		struct {
+			__u8 len;
+			struct dtv_status status[4];
+		} stat;
+		struct {
 			__u8 data[32];
 			__u32 len;
 			__u32 reserved1[3];

> 
> Devin
> 


-- 

Cheers,
Mauro
