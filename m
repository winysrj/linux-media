Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:48402 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbZFHQbh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 12:31:37 -0400
Received: from coriolanus.eng.cam.ac.uk ([129.169.154.144]:57146)
	by ppsw-0.csi.cam.ac.uk (smtp.hermes.cam.ac.uk [131.111.8.150]:25)
	with esmtpsa (PLAIN:jic23) (TLSv1:DHE-RSA-AES256-SHA:256)
	id 1MDhl5-0004aQ-0v (Exim 4.70) for linux-media@vger.kernel.org
	(return-path <jic23@cam.ac.uk>); Mon, 08 Jun 2009 17:31:39 +0100
Message-ID: <4A2D3CFF.9010303@cam.ac.uk>
Date: Mon, 08 Jun 2009 16:31:59 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: soc-camera: Why are exposure and gain handled via special cases?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

Whilst working on merging the various ov7670 drivers posted
recently, I came across the following in soc-camera:

static int soc_camera_g_ctrl(struct file *file, void *priv,
			     struct v4l2_control *ctrl)
{
	struct soc_camera_file *icf = file->private_data;
	struct soc_camera_device *icd = icf->icd;
	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);

	WARN_ON(priv != file->private_data);

	switch (ctrl->id) {
	case V4L2_CID_GAIN:
		if (icd->gain == (unsigned short)~0)
			return -EINVAL;
		ctrl->value = icd->gain;
		return 0;
	case V4L2_CID_EXPOSURE:
		if (icd->exposure == (unsigned short)~0)
			return -EINVAL;
		ctrl->value = icd->exposure;
		return 0;
	}

	return v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, core, g_ctrl, ctrl);
}

Why are these two cases and only these two handled by soc-camera rather than being passed
on to the drivers?

Thanks,

Jonathan
