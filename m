Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:37657 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab3L3P4w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 10:56:52 -0500
Date: Mon, 30 Dec 2013 16:56:25 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: hdegoede@redhat.com, m.chehab@samsung.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: question about drivers/media/usb/gspca/kinect.c
Message-Id: <20131230165625.814796d9e041d2261e1d078a@studenti.unina.it>
In-Reply-To: <alpine.DEB.2.02.1312251956490.2020@localhost6.localdomain6>
References: <alpine.DEB.2.02.1312251956490.2020@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 25 Dec 2013 20:00:34 +0100 (CET)
Julia Lawall <julia.lawall@lip6.fr> wrote:

> The following code, in the function send_cmd, looks too concise:
> 
>         do {
>                 actual_len = kinect_read(udev, ibuf, 0x200);
>         } while (actual_len == 0);
>         PDEBUG(D_USBO, "Control reply: %d", res);
>         if (actual_len < sizeof(*rhdr)) {
>                 pr_err("send_cmd: Input control transfer failed (%d)\n", res);
>                 return res;
>         }
> 
> It seems that actual_len might be less than sizeof(*rhdr) either because 
> an error code is returned by the call to kinect_read or because a shorter 
> length is returned than the desired one.  In the error code case, I would 
> guess that one would want to return the error code, but I don't know what 
> on would want to return in the other case.  In any case, res is not 
> defined by this code, so what is returned is whatever the result of the 
> previous call to kinect_write happened to be.
> 
> How should the code be changed?
>

Thanks Julia,

some other drivers return -EIO when the actual transfer length does not
match the requested one[1], and from Documentation/usb/error-codes.txt
[2] it looks like -EREMOTEIO is also used to represent partial
transfers in some cases. So I'd say either one of the two is OK.

The interested code is almost the same used in libfreenect[3], so I'd
stay with a minimal change here:

diff --git a/drivers/media/usb/gspca/kinect.c b/drivers/media/usb/gspca/kinect.c
index 3773a8a..48084736 100644
--- a/drivers/media/usb/gspca/kinect.c
+++ b/drivers/media/usb/gspca/kinect.c
@@ -158,7 +158,7 @@ static int send_cmd(struct gspca_dev *gspca_dev, uint16_t cmd, void *cmdbuf,
        PDEBUG(D_USBO, "Control reply: %d", res);
        if (actual_len < sizeof(*rhdr)) {
                pr_err("send_cmd: Input control transfer failed (%d)\n", res);
-               return res;
+               return actual_len < 0 ? actual_len : -EREMOTEIO;
        }
        actual_len -= sizeof(*rhdr);

Proper patches on their way, to libfreenect too.

Thanks again,
   Antonio

[1]
http://lxr.linux.no/#linux+v3.12.6/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c#L37
[2]
http://lxr.linux.no/#linux+v3.12.6/Documentation/usb/error-codes.txt#L134
[3]
https://github.com/OpenKinect/libfreenect/blob/master/src/flags.c#L87

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
