Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab0AQSrA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 13:47:00 -0500
Message-ID: <4B5345D2.7020409@hhs.nl>
Date: Sun, 17 Jan 2010 18:16:02 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: libv4l release: 0.6.4: time to retire some (more) v4l1 drivers
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I'm very happy to announce the release of libv4l-0.6.4

The main change this release is support for decompression of
cpia1 "compressed" yuv, together with the new gspca
support for these bridges, this will allow us to retire the cpia1
v4l1 driver.

This release also adds a large number of laptops to the list of
laptops whose camera modules are known to be mounted upside down in
the frame.

Last are some improvements to mr97310a support.

libv4l-0.6.4
-------------
* Add more laptop models to the upside down devices table
* Add error checking to mr97310a decompression
* Increase mr97310a minimum clockdiv upon 3 consecutive decoding errors
* Add support for decompressing CPIA1 compressed YUV
* Speed up autogain algorithm

http://people.fedoraproject.org/~jwrdegoede/libv4l-0.6.4.tar.gz

Regards,

Hans

