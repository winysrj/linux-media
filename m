Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44478 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab3KURFJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Nov 2013 12:05:09 -0500
Message-ID: <528E3D41.5010508@iki.fi>
Date: Thu, 21 Nov 2013 19:05:05 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>
Subject: SDR sampling rate - control or IOCTL?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
I am adding new property for sampling rate that is ideally the only 
obligatory parameter required by SDR. It is value that could be only 
positive and bigger the better, lets say unsigned 64 bit is quite ideal. 
That value sets maximum radio frequency possible to receive (ideal SDR).

Valid values are not always in some single range from X to Y, there 
could be some multiple value ranges.

For example possible values: 1000-2000, 23459, 900001-2800000

Reading possible values from device could be nice, but not necessary. 
Reading current value is more important.

Here is what I though earlier as a requirements:

sampling rate
*  values: 1 - infinity (unit: Hz, samples per second)
      currently 500 MHz is more than enough
*  operations
      GET, inquire what HW supports
      GET, get current value
      SET, set desired value


I am not sure what is best way to implement that kind of thing.
IOCTL like frequency
V4L2 Control?
put it into stream format request?

Sampling rate is actually frequency of ADC. As there devices has almost 
always tuner too (practical SDR) there is need for tuner frequency too. 
As tuner is still own entity, is it possible to use same frequency 
parameter for both ADC and RF tuner in same device?

regards
Antti

-- 
http://palosaari.fi/
