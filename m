Return-path: <mchehab@pedra>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:47644 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab1DLWyA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 18:54:00 -0400
Received: by eyf5 with SMTP id 5so13301eyf.29
        for <linux-media@vger.kernel.org>; Tue, 12 Apr 2011 15:53:58 -0700 (PDT)
MIME-Version: 1.0
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Tue, 12 Apr 2011 17:53:38 -0500
Message-ID: <BANLkTikQ=z+ggR0XR5Ej-=X4MezJ7sOwjA@mail.gmail.com>
Subject: [soc_camera] Dynamic crop window change while streaming (Zoom case)?
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

I was wondering what's the stand on allowing soc_camera host drivers to have
internal scalers...

It looks possible, but however I see one important blocker for being able to
change window rectangle while streaming (for example, when attempting to do
zoom in/out during streaming). See here:

in soc_camera.c::soc_camera_s_crop()

...
	/* If get_crop fails, we'll let host and / or client drivers decide */
	ret = ici->ops->get_crop(icd, &current_crop);

	/* Prohibit window size change with initialised buffers */
	if (ret < 0) {
		dev_err(&icd->dev,
			"S_CROP denied: getting current crop failed\n");
	} else if (icd->vb_vidq.bufs[0] &&
		   (a->c.width != current_crop.c.width ||
		    a->c.height != current_crop.c.height)) {
		dev_err(&icd->dev,
			"S_CROP denied: queue initialised and sizes differ\n");
		ret = -EBUSY;
	} else {
		ret = ici->ops->set_crop(icd, a);
	}
...

Now, I don't want to move just yet to a Media Controller implementation in my
omap4 camera driver, since I don't intend yet to exploit the full HW, which
is easly 2x more complicated than omap3. But I want to start with a simplistic
driver which Pandaboard community can take (which don't need any advanced
features, just being able to receive frames.) and i just want to know how
complicated is to just offer the scaler functionality still.

Regards,
Sergio
