Return-path: <mchehab@pedra>
Received: from 5571f1ba.dsl.concepts.nl ([85.113.241.186]:53325 "EHLO
	his10.thuis.hoogenraad.info" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755594Ab1FJLdT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 07:33:19 -0400
Received: from his10.thuis.hoogenraad.info (unknown [IPv6:::1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by his10.thuis.hoogenraad.info (Postfix) with ESMTPS id CF24034E1338
	for <linux-media@vger.kernel.org>; Fri, 10 Jun 2011 13:24:54 +0200 (CEST)
Message-ID: <4DF1FF06.4050502@hoogenraad.net>
Date: Fri, 10 Jun 2011 13:24:54 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Media_build does not compile due to errors in cx18-driver.h, cx18-driver.c
 and dvbdev.c /rc-main.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans, Mauro:

I have tried to compile the sources at git://linuxtv.org/media_build.git,
using build.sh

At
cx18-driver.h:659:
     struct workqueue_struct *out_work_queue;
     char out_workq_name[12]; /* "cx18-NN-out" */

     struct workqueue_struct *out_work_queue;
     char out_workq_name[12]; /* "cx18-NN-out" */


cx18-driver.c:718
a similar problem occurs: the following code block is repeated:

static int __devinit cx18_create_out_workq(struct cx18 *cx)
{
     snprintf(cx->out_workq_name, sizeof(cx->out_workq_name), "%s-out",
          cx->v4l2_dev.name);
     cx->out_work_queue = create_workqueue(cx->out_workq_name);
     if (cx->out_work_queue == NULL) {
         CX18_ERR("Unable to create outgoing mailbox handler threads\n");
         return -ENOMEM;
     }
     return 0;
}

static int __devinit cx18_create_out_workq(struct cx18 *cx)
{
     snprintf(cx->out_workq_name, sizeof(cx->out_workq_name), "%s-out",
          cx->v4l2_dev.name);
     cx->out_work_queue = create_workqueue(cx->out_workq_name);
     if (cx->out_work_queue == NULL) {
         CX18_ERR("Unable to create outgoing mailbox handler threads\n");
         return -ENOMEM;
     }
     return 0;
}

Furthermore, there is an error that is present in three sources:
At
./v4l/dvbdev.c:466: twice:
the escape sequence \\" sould be replaced with \"

./rc-main.c:1131: twice:
the escape sequence \\" sould be replaced with \"

./v4l/v4l2-dev.c:782: twice:
the escape sequence \\" sould be replaced with \"


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht


