Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:48196 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755770Ab1FJMee (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 08:34:34 -0400
References: <4DF1FF06.4050502@hoogenraad.net>
In-Reply-To: <4DF1FF06.4050502@hoogenraad.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Media_build does not compile due to errors in cx18-driver.h, cx18-driver.c and dvbdev.c /rc-main.c
From: Andy Walls <awalls@md.metrocast.net>
Date: Fri, 10 Jun 2011 08:34:41 -0400
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	linux-media@vger.kernel.org
Message-ID: <3e84c07f-83ff-4f83-9f8f-f52631259f05@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Jan Hoogenraad <jan-conceptronic@hoogenraad.net> wrote:

>Hans, Mauro:
>
>I have tried to compile the sources at
>git://linuxtv.org/media_build.git,
>using build.sh
>
>At
>cx18-driver.h:659:
>     struct workqueue_struct *out_work_queue;
>     char out_workq_name[12]; /* "cx18-NN-out" */
>
>     struct workqueue_struct *out_work_queue;
>     char out_workq_name[12]; /* "cx18-NN-out" */
>
>
>cx18-driver.c:718
>a similar problem occurs: the following code block is repeated:
>
>static int __devinit cx18_create_out_workq(struct cx18 *cx)
>{
>     snprintf(cx->out_workq_name, sizeof(cx->out_workq_name), "%s-out",
>          cx->v4l2_dev.name);
>     cx->out_work_queue = create_workqueue(cx->out_workq_name);
>     if (cx->out_work_queue == NULL) {
>       CX18_ERR("Unable to create outgoing mailbox handler threads\n");
>         return -ENOMEM;
>     }
>     return 0;
>}
>
>static int __devinit cx18_create_out_workq(struct cx18 *cx)
>{
>     snprintf(cx->out_workq_name, sizeof(cx->out_workq_name), "%s-out",
>          cx->v4l2_dev.name);
>     cx->out_work_queue = create_workqueue(cx->out_workq_name);
>     if (cx->out_work_queue == NULL) {
>       CX18_ERR("Unable to create outgoing mailbox handler threads\n");
>         return -ENOMEM;
>     }
>     return 0;
>}
>
>Furthermore, there is an error that is present in three sources:
>At
>./v4l/dvbdev.c:466: twice:
>the escape sequence \\" sould be replaced with \"
>
>./rc-main.c:1131: twice:
>the escape sequence \\" sould be replaced with \"
>
>./v4l/v4l2-dev.c:782: twice:
>the escape sequence \\" sould be replaced with \"
>
>
>-- 
>Jan Hoogenraad
>Hoogenraad Interface Services
>Postbus 2717
>3500 GS Utrecht
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

What are the error messages?

Tejun Heo made quite a number of workqueue changes, and the cx18 driver got dragged forward with them.  So did ivtv for that matter.

Just disable the cx18 driver if you don't need it for an older kernel.

Regards,
Andy
