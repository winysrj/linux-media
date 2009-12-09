Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758667AbZLIXiw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2009 18:38:52 -0500
Message-ID: <4B20350B.2050006@redhat.com>
Date: Wed, 09 Dec 2009 21:38:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Julian Scheel <julian@jusst.de>
CC: Manu Abraham <abraham.manu@gmail.com>, linux-media@vger.kernel.org
Subject: Re: New DVB-Statistics API
References: <4B1E1974.6000207@jusst.de> <4B1E532C.9040903@redhat.com>	 <1a297b360912081346k45b7844bg5d408d47a38da5b4@mail.gmail.com>	 <4B1EE49A.8030701@redhat.com> <1a297b360912090342r3c73496x3abe8ccba62b701@mail.gmail.com> <4B1F9FD0.4020702@redhat.com> <4B2020BD.709@jusst.de>
In-Reply-To: <4B2020BD.709@jusst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Julian Scheel wrote:
> Am 09.12.09 14:02, schrieb Mauro Carvalho Chehab:
>> Manu Abraham wrote:

> I don't think you can just take the average IPC rates into account for
> this. When doing a syscall the processors TLB cache will be cleared,
> which will force the CPU to go to the whole instruction pipeline before
> the first syscall instruction is actually executed. This will introduce
> a delay for each syscall you make. I'm not exactly sure about the length
> of the delay, but I think it should be something like 2 clock cycles.

True, but this delay is common to both S2API and struct.

>> To get all data that the ioctl approach struct has, the delay for
>> S2API will be equal.
>> To get less data, S2API will have a small delay.
>>    
> Imho the S2API would be slower when reading all data the ioctl fetches,
> due to the way the instructions would be handled.
> 
> Correct me, if I'm wrong with any of this.

Not sure if I understood your question.

On both cases, just one function call will go to the driver, with one struct
(struct fe, the case of S2API) or two structs (struct fe and the
stats-specific struct(s)) in the case of a new ioctl(s).

As drivers are free to implement any logic, the driver can implement exactly
the same logic with both API calls. So, the delay to get the info will be
equal on both cases.

In a practical case, this will take at least a few milisseconds to retrieve all
data. It may take even more, since, on some drivers, you may need to wait for
some condition to happen before start measuring, in order to be sure that you'll
be getting atomic and accurate values.

After the function return, with an struct, you can just return, while, with S2API,
you'll need to put the data into the proper payload fields, but this will add
a delay in the order of nanoseconds.

Let's say that, to get all data, the routine needs 10 milisseconds.

The difference between new ioctl or S2API will be of about 0,00063 milliseconds
on a Pentium MMX. On a machine with 1GHz of clock, 2 IPC, the difference will
be 0,0000315 milliseconds.

Considering that the Linux kernel is preemptive, and an interrupt or the scheduler
could be called during the 10 milliseconds time, I doubt you'll be able to
notice that difference on any practical use case.

On the other hand, if you need for example just the strength of the signal at the AGC,
if you call via struct, you'll still be consuming the same 10 ms, while, with S2API,
you can do it, let's say, on 1 ms (the real numbers will depend, of course, on how
much I/O is needed on hardware, and on how many time do you need to wait there to 
get an stable value).

So, if you want to do things like moving a rotor, S2API will give better results.
If you want all stats, it will give the same result as a new ioctl.

While I don't think that 0,0000315 milliseconds is worth enough to cause any troubles,
With a simple change like the one bellow, this time can be reduced to 0,0000105 milisseconds
with a patch like that (the patch were simplified to change just quality, but, of course,
such approach needs to be done on the other fields to get this result):


Index: master/linux/drivers/media/dvb/dvb-core/dvb_frontend.c
===================================================================
--- master.orig/linux/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ master/linux/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1220,6 +1220,7 @@ static int dtv_property_prepare_get_stat
 	switch (tvp->cmd) {
 	case DTV_FE_QUALITY:
 		fe->dtv_property_cache.need_stats |= FE_NEED_QUALITY;
+		fe->dtv_property_cache.quality = &tvp->u.data;
 		break;
 	case DTV_FE_QUALITY_UNIT:
 		fe->dtv_property_cache.need_stats |= FE_NEED_QUALITY_UNIT;
@@ -1384,9 +1385,6 @@ static int dtv_property_process_get(stru
 		break;

	/* Quality measures */
-	case DTV_FE_QUALITY:
-		tvp->u.data = fe->dtv_property_cache.quality;
-		break;
 	case DTV_FE_QUALITY_UNIT:
 		tvp->u.data = fe->dtv_property_cache.quality_unit;
 		break;
@@ -1696,10 +1697,12 @@ static int dvb_frontend_ioctl_properties
 			}
 		}
 
-		for (i = 0; i < tvps->num; i++) {
-			(tvp + i)->result = dtv_property_process_get(fe,
-					tvp + i, inode, file, need_get_ops);
-			err |= (tvp + i)->result;
+		if (need_get_ops) {
+			for (i = 0; i < tvps->num; i++) {
+				(tvp + i)->result = dtv_property_process_get(fe,
+						tvp + i, inode, file, need_get_ops);
+				err |= (tvp + i)->result;
+			}
 		}
 
 		if (copy_to_user(tvps->props, tvp, tvps->num * sizeof(struct dtv_property))) {
Index: master/linux/drivers/media/dvb/dvb-core/dvb_frontend.h
===================================================================
--- master.orig/linux/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ master/linux/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -374,7 +374,7 @@ struct dtv_frontend_properties {
 #define FE_NEED_SIGNAL_UNIT	(1 << 7)
 	int			need_stats;
 
-	u32			quality;
+	u32			*quality;
 	u32			strength;
 	u32			error;
 	u32			unc;

and, on the drivers, instead of doing:

	prop->quality = <some calculus>

doing
	*prop->quality = <some calculus>

Cheers,
Mauro.
