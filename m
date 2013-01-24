Return-path: <linux-media-owner@vger.kernel.org>
Received: from umlaeute.mur.at ([89.106.215.196]:43264 "EHLO umlaeute.mur.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab3AXQX0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 11:23:26 -0500
Received: from inf190.kug.ac.at ([193.170.191.190] helo=[192.168.171.180])
	by umlaeute.mur.at with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <zmoelnig@umlaeute.mur.at>)
	id 1TyP9Y-0004ZW-Cc
	for linux-media@vger.kernel.org; Thu, 24 Jan 2013 16:55:48 +0100
Message-ID: <51015A68.50808@umlaeute.mur.at>
Date: Thu, 24 Jan 2013 16:59:36 +0100
From: =?ISO-8859-15?Q?forum=3A=3Af=FCr=3A=3Auml=E4ute?=
	<zmoelnig@umlaeute.mur.at>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: v4l2loopback and kernel-3.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi all,

i'm currently maintainer of the "v4l2loopback" device [1], a virtual
video device that allows applications to share video-streams via the
v4l2 API (each device being V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT).

now (unfortunately for someone maintaining a driver) i have not been
following development of the linux-kernel very closely (mainly using
debian unstable kernels myself), but some of my users do.
it seems that with newer kernel-versions the functionality for
video-output modules have been somehow removed from the kernel (3.7.1
has been confirmed to make troubles, whereas 3.6.10 still works).

i'd like to inquire, what happened in/to the mainstream kernel, and
what's the supposed way to proceed for a virtual video device like mine.
(i naively ask the question here, as i'm a bit afraid of kernel-dev
mailing list :-))

what's more, if the v4l2-taskforce would be interested to take over a
kernel-module that - to my knowledge - is currently the only feasible
way on linux to exchange live video streams between applications, we
might talk about that :-)

fgasdmr
IOhannes




[1] https://github.com/umlaeute/v4l2loopback/
