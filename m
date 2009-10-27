Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:50047 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbZJ0OYy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 10:24:54 -0400
Message-ID: <4AE702C3.7090501@tripleplay-services.com>
Date: Tue, 27 Oct 2009 14:25:07 +0000
From: Lou Otway <louis.otway@tripleplay-services.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Nova 500 T won't tune, kernel issue?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have 2 versions of the Hauppauge Nova 500 T dual tuner device, both 
the single and dual RF input versions.

Under kernel 2.6.23 using the latest drivers, they both tune fine.

Under kernel  2.6.28, with the same drivers, they won't tune and I see 
this message when trying to tune:

kernel: dvb-usb: could not submit URB no. 0 - get them all back

I can conclude that devices are not faulty as they work with one kernel 
version and fail with another.

Can anyone point me in the right direction?

Many thanks,

Lou

