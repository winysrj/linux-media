Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56973 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500AbZJAL5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2009 07:57:41 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n91BvjNC002567
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 1 Oct 2009 06:57:45 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id n91Bvjfw004990
	for <linux-media@vger.kernel.org>; Thu, 1 Oct 2009 06:57:45 -0500 (CDT)
Received: from dlee75.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id n91BvjvX002110
	for <linux-media@vger.kernel.org>; Thu, 1 Oct 2009 06:57:45 -0500 (CDT)
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Thu, 1 Oct 2009 06:56:19 -0500
Subject: dqbuf in blocking mode
Message-ID: <A24693684029E5489D1D202277BE89444C9C902B@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I was wondering how acceptable is to requeue a buffer in a dqbuf call
if the videbuf_dqbuf returns error?

See, here's our current omap3 camera dqbuf function code:

static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
{
	struct omap34xxcam_fh *ofh = fh;
	int rval;

videobuf_dqbuf_again:
	rval = videobuf_dqbuf(&ofh->vbq, b, file->f_flags & O_NONBLOCK);

	/*
	 * This is a hack. We don't want to show -EIO to the user
	 * space. Requeue the buffer and try again if we're not doing
	 * this in non-blocking mode.
	 */
	if (rval == -EIO) {
		videobuf_qbuf(&ofh->vbq, b);
		if (!(file->f_flags & O_NONBLOCK))
			goto videobuf_dqbuf_again;
		/*
		 * We don't have a videobuf_buffer now --- maybe next
		 * time...
		 */
		rval = -EAGAIN;
	}

	return rval;
}

Is anything wrong with doing this? Or perhaphs something better to do?

Regards,
Sergio