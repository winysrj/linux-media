Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52299 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbZHCIeW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Aug 2009 04:34:22 -0400
Message-ID: <4A76A227.20503@redhat.com>
Date: Mon, 03 Aug 2009 10:39:03 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: t.i.m@zen.co.uk
Subject: RFC: distuingishing between hardware and emulated formats
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

The gstreamer folks have asked to add an API to libv4l2 so
that they can distuingish between formats emulated by libv4l2
and formats offered raw by the hardware.

I think this is a usefull thing to do and I think this is best
done by adding a new flag for the flags field of the
v4l2_fmtdesc struct. So I would like to propose to add the
following new flag to videodev2.h :

#define V4L2_FMT_FLAG_EMULATED 0x0002

And add the necessary documentation to the spec. The emulated term
is what I've always been using in libv4l discussions for formats
which are not offered native by the hardware but are offered by
libv4l through conversion. If someone has a better name for the
flag suggestions are welcome.

If you read this and even if your only thoughts are: seems ok to me,
please reply saying so. It is very frustrating to suggest API additions
and not get any feedback.

Regards,

Hans
