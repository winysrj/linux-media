Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:35553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab1F3Kyy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2011 06:54:54 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5UAspNc006206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 30 Jun 2011 06:54:51 -0400
Message-ID: <4E0C5639.9030501@redhat.com>
Date: Thu, 30 Jun 2011 12:55:53 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [git:xawtv3/master] xawtv: reenable its usage with webcam's
References: <E1Qbdw6-0007wL-E8@www.linuxtv.org> <4E0B05F5.1000704@redhat.com> <4E0B1407.8000907@redhat.com> <4E0B199B.4010008@redhat.com> <4E0B7CA3.3010104@redhat.com>
In-Reply-To: <4E0B7CA3.3010104@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 06/29/2011 09:27 PM, Mauro Carvalho Chehab wrote:

<snip>

>
> Anyway, it is fixed. I also made scantv to force for a TV device at auto mode, as it
> doesn't sense to scan for TV channels on devices without tuner.

Thanks for fixing this, 2 remarks wrt the auto patch for
scantv:

1) This bit should be #ifdef __linux__ since we only support
auto* on linux because of the sysfs dep:

@@ -149,6 +149,9 @@ main(int argc, char **argv)

      /* parse options */
      ng_init();
+    /* Autodetect devices */
+    ng_dev.video = "auto_tv";
+
      for (;;) {
  	if (-1 == (c = getopt(argc, argv, "hsadi:n:f:o:c:C:D:")))
  	    break;

2) The added return NULL in case no device can be found lacks
printing an error message:

@@ -568,6 +569,8 @@ static void *ng_vid_open_auto(struct ng_vid_driver *drv, char *devpath)

      /* Step 2: try grabber devices and webcams */
      if (!handle) {
+	if (!allow_grabber)
+	    return NULL;
  	device = NULL;
  	while (1) {
  	    device = get_associated_device(md, device, MEDIA_V4L_VIDEO, NULL, NONE);

I propose changing the return NULL, with a goto to the error print further down.

>  From my side, I don't intend to touch on xawtv any time soon. So, maybe we can wait
> for a couple days and release version 1.101.

Assuming the 2 things mentioned above get fixed that sounds like a good plan to me.

Regards,

Hans
