Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab3LZQiV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Dec 2013 11:38:21 -0500
Message-ID: <52BC5B71.5000308@redhat.com>
Date: Thu, 26 Dec 2013 17:38:09 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Julia.Lawall@lip6.fr
Subject: Fwd: question about drivers/media/usb/gspca/kinect.c
References: <alpine.DEB.2.02.1312251956490.2020@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1312251956490.2020@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Forwarding this to Antonio, the author of the kinect driver, who is
the best person to answer this.

Regards,

Hans



-------- Original Message --------
Subject: question about drivers/media/usb/gspca/kinect.c
Date: Wed, 25 Dec 2013 20:00:34 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: hdegoede@redhat.com, m.chehab@samsung.com, linux-media@vger.kernel.org,        linux-kernel@vger.kernel.org

The following code, in the function send_cmd, looks too concise:

         do {
                 actual_len = kinect_read(udev, ibuf, 0x200);
         } while (actual_len == 0);
         PDEBUG(D_USBO, "Control reply: %d", res);
         if (actual_len < sizeof(*rhdr)) {
                 pr_err("send_cmd: Input control transfer failed (%d)\n", res);
                 return res;
         }

It seems that actual_len might be less than sizeof(*rhdr) either because
an error code is returned by the call to kinect_read or because a shorter
length is returned than the desired one.  In the error code case, I would
guess that one would want to return the error code, but I don't know what
on would want to return in the other case.  In any case, res is not
defined by this code, so what is returned is whatever the result of the
previous call to kinect_write happened to be.

How should the code be changed?

thanks,
julia


