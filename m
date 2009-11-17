Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51682 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbZKQTrS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 14:47:18 -0500
Message-ID: <4B02FDA4.5030508@infradead.org>
Date: Tue, 17 Nov 2009 17:46:44 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Details about DVB frontend API
References: <20091022211330.6e84c6e7@hyperion.delvare>	 <20091023051025.597c05f4@caramujo.chehab.org> <1a297b360910221329o4b832f4ewaee08872120bfea0@mail.gmail.com>
In-Reply-To: <1a297b360910221329o4b832f4ewaee08872120bfea0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham escreveu:
> On Fri, Oct 23, 2009 at 12:10 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
>> Em Thu, 22 Oct 2009 21:13:30 +0200
>> Jean Delvare <khali@linux-fr.org> escreveu:
>>
>>> Hi folks,
>>>
>>> I am looking for details regarding the DVB frontend API. I've read
>>> linux-dvb-api-1.0.0.pdf, it roughly explains what the FE_READ_BER,
>>> FE_READ_SNR, FE_READ_SIGNAL_STRENGTH and FE_READ_UNCORRECTED_BLOCKS
>>> commands return, however it does not give any information about how the
>>> returned values should be interpreted (or, seen from the other end, how
>>> the frontend kernel drivers should encode these values.) If there
>>> documentation available that would explain this?
>>>
>>> For example, the signal strength. All I know so far is that this is a
>>> 16-bit value. But then what? Do greater values represent stronger
>>> signal or weaker signal? Are 0x0000 and 0xffff special values? Is the
>>> returned value meaningful even when FE_HAS_SIGNAL is 0? When
>>> FE_HAS_LOCK is 0? Is the scale linear, or do some values have
>>> well-defined meanings, or is it arbitrary and each driver can have its
>>> own scale? What are the typical use cases by user-space application for
>>> this value?
>>>
>>> That's the kind of details I'd like to know, not only for the signal
>>> strength, but also for the SNR, BER and UB. Without this information,
>>> it seems a little difficult to have consistent frontend drivers.
>> We all want to know about that ;)
>>
>> Seriously, the lack of a description of the meaning of the ranges for those
>> read values were already widely discussed at LMML and at the legacy dvb ML.
>> We should return this discussion again and decide what would be the better
>> way to describe those values.
>>
>> My suggestion is that someone summarize the proposals we had and give some time
>> for people vote. After that, we just commit the most voted one, and commit the
>> patches for it. A pending question that should also be discussed is what we will
>> do with those dvb devices where we simply don't know what scale it uses. There
>> are several of them.
> 
> 
> Sometime back, (some time in April) i proposed a patch which addressed
> the issue to scale "even those devices which have a weird scale or
> none". Though based on an older tree of mine, here is the patch again.
> If it looks good enough, i can port the patch to accomodate other
> devices as well.
> 
> 
> Regards,
> Manu
> 

Manu,

Sorry for not answering earlier. Due to my travels, I had a very big backlog here
to handle.

I prefer a solution like you've proposed of creating a new set of API calls for
it, instead of re-defining the current calls.

Yet, I have a few comments:

diff -r b5505a985f24 linux/include/linux/dvb/frontend.h
--- a/linux/include/linux/dvb/frontend.h	Sat Feb 21 01:12:09 2009 +0400
+++ b/linux/include/linux/dvb/frontend.h	Tue Apr 07 18:19:22 2009 +0400
@@ -645,4 +645,118 @@
 };
 #define DVBFE_GET_EVENT			_IOR('o', 86, struct dvbfe_event)
 
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

I don't like the idea of creating structs grouping those parameters. While for
certain devices this may mean a more direct approach, for others, this may
not make sense, due to the way their API's were implemented (for example,
devices with firmware may need several calls to get all those info).

+#define FE_STATISTICS_CAPS		_IOR('o', 84, struct fecap_statistics)
+#define FE_SIGNAL_LEVEL			_IOR('o', 85, __u32)
+#define FE_SIGNAL_STATS			_IOR('o', 86, struct fesignal_stat)

Instead of defining 3 new ioctls, the better is to use the DVBS2API, maybe extending it to allow
receiving more than one parameter at the same time (with an approach similar to what we did
with V4L extended CTRLs API).

We are already redefining some existing ioctls there, so it would be clearer for the
userspace developers what would be the new way to retrieve frontend stats, as we can
simply say that DVBS2API features superseeds the equivalent DVB v3 ioctls.

Comments?

Cheers,
Mauro.
