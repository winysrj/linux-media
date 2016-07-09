Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46235
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbcGIAva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 20:51:30 -0400
Date: Fri, 8 Jul 2016 21:51:24 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Vinson Lee <vlee@freedesktop.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <kamil@wypas.org>, k.debski@samsung.com,
	linux-media@vger.kernel.org
Subject: Re: linux-next build error "cec-adap.c:141: error: unknown field
 =?UTF-8?B?4oCYbG9zdF9tc2dz4oCZ?= specified in initializer"
Message-ID: <20160708215124.39c1b0ee@recife.lan>
In-Reply-To: <CACKvgLEOdetneSdhwmdayYzu+eadYy4hoAT1nBo3U37pSJWCPg@mail.gmail.com>
References: <CACKvgLEOdetneSdhwmdayYzu+eadYy4hoAT1nBo3U37pSJWCPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 8 Jul 2016 15:55:44 -0700
Vinson Lee <vlee@freedesktop.org> escreveu:

> Hi.
> 
> Commit 9881fe0ca187 "[media] cec: add HDMI CEC framework (adapter)"
> introduced this build error with GCC 4.4.
> 
>   CC [M]  drivers/staging/media/cec/cec-adap.o
> drivers/staging/media/cec/cec-adap.c: In function ‘cec_queue_msg_fh’:
> drivers/staging/media/cec/cec-adap.c:141: error: unknown field
> ‘lost_msgs’ specified in initializer
> 
> Cheers,
> Vinson

Hmm... 4.4 is old ;)

Could you please check if this quick hack solves the issue?


diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 7df61870473c..ebb30e656d99 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -138,7 +138,7 @@ static void cec_queue_msg_fh(struct cec_fh *fh, const struct cec_msg *msg)
 {
 	static const struct cec_event ev_lost_msg = {
 		.event = CEC_EVENT_LOST_MSGS,
-		.lost_msgs.lost_msgs = 1,
+		.lost_msgs = { .lost_msgs = 1 },
 	};
 	struct cec_msg_entry *entry;
 


Thanks,
Mauro
