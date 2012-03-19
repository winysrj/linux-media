Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47168 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161167Ab2CSQ1G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 12:27:06 -0400
Received: by iagz16 with SMTP id z16so9645129iag.19
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2012 09:27:06 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 19 Mar 2012 17:27:06 +0100
Message-ID: <CACKLOr28ECqBhTkMsd=6vSOMPZk2DgbRFWZOZXH39omQRP0fcA@mail.gmail.com>
Subject: [Q] ov7670: green line in VGA resolution
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org, corbet@lwn.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I am currently testing an ov7670 sensor against my mx2_camera.c
soc-camera driver. Everything works as expected with the exception of
a green vertical line of about 6-7 pixels width that appears on the
left side of the image.

I suspect the problem is related to the fact that this sensor has an
array of 656 x 488 pixels but only 640 x 480 are active. The datasheet
available from Omnivision (Version 1.4, August 21, 2006) is not clear
about how to configure the sensor not to show non active pixels but I
could find the following patch which addresses a similar problem for
QVGA:

http://kernel.ubuntu.com/git?p=bradf/backup.ubuntu-maverick/.git;a=commitdiff;h=e4182762eaf3c80b2f5c8d1d373409d7c2843579;hp=e770cc1e35a3f11cffd1f38f52060e3e38b4fbf7

But I don't know how these values can be extrapolated to the VGA case.
Has anybody found the same issue?

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
