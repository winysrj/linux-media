Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36218 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab1IMTOc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 15:14:32 -0400
Received: by bkbzt4 with SMTP id zt4so825090bkb.19
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2011 12:14:30 -0700 (PDT)
Message-ID: <4E6FAB94.2010007@googlemail.com>
Date: Tue, 13 Sep 2011 21:14:28 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Question about USB interface index restriction in gspca
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a question about the following code in gspca.c:

in function gspca_dev_probe(...):
     ...
     /* the USB video interface must be the first one */
     if (dev->config->desc.bNumInterfaces != 1
&& intf->cur_altsetting->desc.bInterfaceNumber != 0)
             return -ENODEV;
     ...


Is there a special reason for not allowing devices with USB interface 
index > 0 for video ?
I'm experimenting with a device that has the video interface at index 3 
and two audio interfaces at index 0 and 1 (index two is missing !).
And the follow-up question: can we assume that all device handled by the 
gspca-driver have vendor specific video interfaces ?
Then we could change the code to

     ...
     /* the USB video interface must be of class vendor */
     if (intf->cur_altsetting->desc.bInterfaceClass != 
USB_CLASS_VENDOR_SPEC)
             return -ENODEV;
      ...

Regards,
Frank


