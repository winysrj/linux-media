Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:35279 "EHLO
        mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1426514AbdD3PIh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Apr 2017 11:08:37 -0400
Date: Sun, 30 Apr 2017 17:08:22 +0200
From: Reinhard Speyerer <rspmn@arcor.de>
To: Tino Mettler <tino.mettler+debbugs@tikei.de>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Gregor Jasny <gjasny@googlemail.com>, 859008@bugs.debian.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: dvb-tools: dvbv5-scan segfaults with DVB-T2 HD service that just
 started in Germany
Message-ID: <20170430150822.GA1384@arcor.de>
References: <149079515540.3615.11876491556658692986.reportbug@mac>
 <06f151f3-0037-dcd0-fc5a-522533f70a3e@googlemail.com>
 <20170329144227.zwrdtnnl4iuhgbkw@mac.home>
 <6bc7b007-cc0e-767d-5e2e-30e8d5bdff05@googlemail.com>
 <20170330171334.06c6135d@vento.lan>
 <20170418105452.GA10975@eazy.amigager.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170418105452.GA10975@eazy.amigager.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 18, 2017 at 12:54:52PM +0200, Tino Mettler wrote:
> On Thu, Mar 30, 2017 at 17:13:34 -0300, Mauro Carvalho Chehab wrote:
> > Hi Gregor,
> > 
> > Em Wed, 29 Mar 2017 20:45:06 +0200
> > Gregor Jasny <gjasny@googlemail.com> escreveu:
> > 
> > > Hello Mauro & list,
> > > 
> > > could you please have a look at the dvbv5-scan crash report below?
> > > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=859008
> > > 
> > > Is there anything else you need to debug this?
> > 
> > I'm able to reproduce it on a Debian machine here too, but so far,
> > I was unable to discover what's causing it. I'll try to find some time
> > to take a better look on it.
> 
> Hi,
> 
> can I help in some way to find the cause of crash?
> 
> Regards,
> Tino
> 

Hi Mauro and Tino,
with the patch below in addition to commit b514d615166bdc0901a4c71261b87db31e89f464
("libdvbv5: T2 delivery descriptor: fix wrong size of bandwidth field") applied
to v4l-utils 1.12.3 sources dvbv5-scan no longer segfaults for me.

Manually replacing PID_24 with VIDEO_PID in the created dvb_channel.conf
as described in a german DVB-T2 forum is required to make dvbv5-zap also
record the video.

Regards,
Reinhard

Subject: [PATCH] libdvbv5: fix T2 delivery descriptor parsing in dvb_desc_t2_delivery_init()

Fix T2 delivery descriptor parsing by proper use of memcpy()/bswap16()
on struct dvb_desc_t2_delivery *d, only skipping the cell_id instead of
the remaining descriptor and using the correct d->tfs_flag check
to avoid dvbv5-scan segfaults observed with the DVB-T2 HD service that 
was started in Germany.

Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
---
 lib/libdvbv5/descriptors/desc_t2_delivery.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/lib/libdvbv5/descriptors/desc_t2_delivery.c b/lib/libdvbv5/descriptors/desc_t2_delivery.c
index 56e8d43..3831ac1 100644
--- a/lib/libdvbv5/descriptors/desc_t2_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_t2_delivery.c
@@ -40,7 +40,7 @@ int dvb_desc_t2_delivery_init(struct dvb_v5_fe_parms *parms,
 		return -1;
 	}
 	if (desc_len < len2) {
-		memcpy(p, buf, len);
+		memcpy(d, buf, len);
 		bswap16(d->system_id);
 
 		if (desc_len != len)
@@ -48,19 +48,23 @@ int dvb_desc_t2_delivery_init(struct dvb_v5_fe_parms *parms,
 
 		return -2;
 	}
-	memcpy(p, buf, len2);
+	memcpy(d, buf, len2);
+	bswap16(d->system_id);
+	bswap16(d->bitfield);
 	p += len2;
 
-	len = desc_len - (p - buf);
-	memcpy(&d->centre_frequency, p, len);
-	p += len;
+	if (desc_len - (p - buf) < sizeof(uint16_t)) {
+		dvb_logwarn("T2 delivery descriptor is truncated");
+		return -2;
+	}
+	p += sizeof(uint16_t);
 
-	if (d->tfs_flag)
-		d->frequency_loop_length = 1;
-	else {
+	if (d->tfs_flag) {
 		d->frequency_loop_length = *p;
 		p++;
 	}
+	else
+		d->frequency_loop_length = 1;
 
 	d->centre_frequency = calloc(d->frequency_loop_length,
 				     sizeof(*d->centre_frequency));
