Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.versatel.nl ([62.58.50.89]:53984 "EHLO smtp2.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbZJIJLt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Oct 2009 05:11:49 -0400
Message-ID: <4ACEFDC1.1030805@hhs.nl>
Date: Fri, 09 Oct 2009 11:09:21 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: libv4l release: 0.6.2: the 3th upside down release
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I'm very happy to announce the release of libv4l-0.6.2

The main changes this release is 17 new laptops in the list of laptops
whose camera modules (mostly uvc) are known to be mounted upside down in
the frame and it will automatically correct the image for this.

(This upside down business is becoming a never ending story)

libv4l-0.6.2
-------------
* Add more laptop models to the upside down devices table
* Put usb id in controls shm segment name for USB devices, to better
   distuingish between devices plugged into the same port
* Enable software whitebalance and autogain for mr97310a cameras
* Improvements / tweaks to software autogain algorithm

Note new URL! Get it here:
http://people.fedoraproject.org/~jwrdegoede/libv4l-0.6.2.tar.gz

Regards,

Hans

