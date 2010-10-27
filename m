Return-path: <mchehab@pedra>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:59588 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481Ab0J0Oho (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 10:37:44 -0400
Message-ID: <4CC83934.1000009@arcor.de>
Date: Wed, 27 Oct 2010 16:37:40 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: tm6000 problems with picture
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

  Hello Mauro,

I have actually problems with my terratec cinergy hybrid xe (tm6010). 
Today as I test with last git update, it don't work with my stick, but a 
few weeks before it has work (black/white picture; bottom position). But 
I found the worried points.


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

@@ -1030,10 +1030,11 @@ static int vidioc_s_std (struct file *file, void 
*priv, v4l2_std_id *norm)
  {
      int rc=0;
      struct tm6000_fh   *fh=priv;
      struct tm6000_core *dev = fh->dev;

+    dev->norm = *norm;
      rc = tm6000_init_analog_mode(dev);

      fh->width  = dev->width;
      fh->height = dev->height;



