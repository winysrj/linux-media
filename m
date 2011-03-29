Return-path: <mchehab@pedra>
Received: from smtp2.sms.unimo.it ([155.185.44.12]:51359 "EHLO
	smtp2.sms.unimo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab1C2RH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 13:07:26 -0400
Received: from mail-fx0-f51.google.com ([209.85.161.51]:49542)
	by smtp2.sms.unimo.it with esmtps (TLS1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.69)
	(envelope-from <76466@studenti.unimore.it>)
	id 1Q4boq-0001rf-Pg
	for linux-media@vger.kernel.org; Tue, 29 Mar 2011 18:31:00 +0200
Received: by fxm5 with SMTP id 5so472345fxm.24
        for <linux-media@vger.kernel.org>; Tue, 29 Mar 2011 09:31:00 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 29 Mar 2011 11:30:53 -0500
Message-ID: <AANLkTinVP6CePBY6g9Dn2aKXM0ovwmpqMd5G4ucz44EH@mail.gmail.com>
Subject: soc_camera dynamically cropping and scaling
From: Paolo Santinelli <paolo.santinelli@unimore.it>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

I am using a PXA270 board running linux 2.6.37 equipped with an ov9655
Image sensor. I am able to use the cropping and scaling capabilities
V4L2 driver.
The question is :

Is it possible dynamically change the cropping and scaling values
without close and re-open  the camera every time ?

Now I am using the streaming I/O memory mapping and to dynamically
change the cropping and scaling values I do :

1) stop capturing using VIDIOC_STREAMOFF;
2) unmap all the buffers;
3) close the device;
4) open the device;
5) init the device: VIDIOC_CROPCAP and VIDIOC_S_CROP in order to set
the cropping parameters. VIDIOC_G_FMT and VIDIOC_S_FMT in order to set
the target image width and height, (scaling).
6) Mapping the buffers: VIDIOC_REQBUFS in order to request buffers and
mmap each buffer using VIDIOC_QUERYBUF and mmap():

this procedure works but take 400 ms.

If I omit steps 3) and 4)  (close and re-open the device) I get this errors:

camera 0-0: S_CROP denied: queue initialised and sizes differ
camera 0-0: S_FMT denied: queue initialised
VIDIOC_S_FMT error 16, Device or resource busy
pxa27x-camera pxa27x-camera.0: PXA Camera driver detached from camera 0

Do you have some Idea regarding why I have to close and reopen the
device and regarding a way to speed up these change?

Thanks in advance

Paolo Santinelli

-- 
--------------------------------------------------
Paolo Santinelli
ImageLab Computer Vision and Pattern Recognition Lab
Dipartimento di Ingegneria dell'Informazione
Universita' di Modena e Reggio Emilia
via Vignolese 905/B, 41125, Modena, Italy

Cell. +39 3472953357,  Office +39 059 2056270, Fax +39 059 2056129
email:  <mailto:paolo.santinelli@unimore.it> paolo.santinelli@unimore.it
URL:  <http://imagelab.ing.unimo.it/> http://imagelab.ing.unimo.it
--------------------------------------------------
