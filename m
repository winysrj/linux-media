Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbZJYImE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Oct 2009 04:42:04 -0400
Message-ID: <4AE40794.4010009@hhs.nl>
Date: Sun, 25 Oct 2009 09:08:52 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: libv4l release: 0.6.3: time to retire some v4l1 drivers
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I'm very happy to announce the release of libv4l-0.6.3

The main change this release is support for decompression of w9968cf
JPEG and stv0680 raw bayer formats, together with the new gspca
support for these bridges, this will allow us to retire the w9968cf
and stv680 v4l1 drivers.

This release also adds 4 new laptops in the list of laptops
whose camera modules are known to be mounted upside down in
the frame. So it looks like the rate of adding new upside down cams
is slowing somewhat, which is good.

libv4l-0.6.3
-------------
* Add more laptop models to the upside down devices table
* Improved mr97310a decompression
* Add support for decompressing yuv420 planar JPEG (one component per SOS,
   3 SOS per frame), this is needed for w9968cf based cams
* Add support for STV0680 raw bayer data

Note new URL! Get it here:
http://people.fedoraproject.org/~jwrdegoede/libv4l-0.6.3.tar.gz

Regards,

Hans

