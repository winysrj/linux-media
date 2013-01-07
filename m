Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490Ab3AGUFw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jan 2013 15:05:52 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r07K5qII019992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 7 Jan 2013 15:05:52 -0500
Date: Mon, 7 Jan 2013 18:05:21 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv8 2/2] dvb: the core logic to handle the DVBv5 QoS
 properties
Message-ID: <20130107180521.20aad4c6@redhat.com>
In-Reply-To: <1357584255-6500-2-git-send-email-mchehab@redhat.com>
References: <1357584255-6500-1-git-send-email-mchehab@redhat.com>
	<1357584255-6500-2-git-send-email-mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  7 Jan 2013 16:44:15 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Add the logic to poll, reset counters and report the QoS stats
> to the end user.
> 
> The idea is that the core will periodically poll the frontend for
> the stats. The frontend may return -EBUSY, if the previous collect
> didn't finish, or it may fill the cached data.
> 
> The value returned to the end user is always the cached data.
> 

It is probably better to have a routine to reset the counters, and do the
cache cleanup there, instead duplicating it on each frontend driver.

So, I'll amend the following driver on my version. I won't be posting a v9
just due to that. My intention is to post v9 together with a driver's code.

Regards,
Mauro

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index f8be7be..b8bd674 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1677,6 +1677,25 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 	return 0;
 }
 
+static int reset_qos_counters(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	/* Reset QoS cache */
+
+	memset (&c->strength, 0, sizeof(c->strength));
+	memset (&c->cnr, 0, sizeof(c->cnr));
+	memset (&c->bit_error, 0, sizeof(c->bit_error));
+	memset (&c->block_error, 0, sizeof(c->block_error));
+	memset (&c->block_count, 0, sizeof(c->block_count));
+
+	/* Call frontend reset counter method, if available */
+	if (fe->ops.reset_qos_counters)
+		return fe->ops.reset_qos_counters(fe);
+
+	return 0;
+}
+
 static int dtv_property_process_set(struct dvb_frontend *fe,
 				    struct dtv_property *tvp,
 				    struct file *file)
@@ -1736,8 +1755,8 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		break;
 	case DTV_DELIVERY_SYSTEM:
 		r = set_delivery_system(fe, tvp->u.data);
-		if (r >= 0 && fe->ops.reset_qos_counters)
-			fe->ops.reset_qos_counters(fe);
+		if (r >= 0)
+			reset_qos_counters(fe);
 		break;
 	case DTV_VOLTAGE:
 		c->voltage = tvp->u.data;
@@ -2338,8 +2357,8 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		if (err)
 			break;
 		err = dtv_set_frontend(fe);
-		if (err >= 0 && fe->ops.reset_qos_counters)
-			fe->ops.reset_qos_counters(fe);
+		if (err >= 0)
+			reset_qos_counters(fe);
 
 		break;
 	case FE_GET_EVENT:


-- 

Cheers,
Mauro
