Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:16097
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251Ab3LYTAi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Dec 2013 14:00:38 -0500
Date: Wed, 25 Dec 2013 20:00:34 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: hdegoede@redhat.com, m.chehab@samsung.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: question about drivers/media/usb/gspca/kinect.c
Message-ID: <alpine.DEB.2.02.1312251956490.2020@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
