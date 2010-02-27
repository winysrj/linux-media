Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpq3.gn.mail.iss.as9143.net ([212.54.34.166]:58569 "EHLO
	smtpq3.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933277Ab0B0V0i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 16:26:38 -0500
Received: from [212.54.34.143] (helo=smtp12.gn.mail.iss.as9143.net)
	by smtpq3.gn.mail.iss.as9143.net with esmtp (Exim 4.69)
	(envelope-from <roalt.dvb-t@roalt.com>)
	id 1NlTkQ-0004gx-7K
	for linux-media@vger.kernel.org; Sat, 27 Feb 2010 21:58:50 +0100
Received: from 5357bb59.cable.casema.nl ([83.87.187.89] helo=[10.0.0.201])
	by smtp12.gn.mail.iss.as9143.net with esmtp (Exim 4.69)
	(envelope-from <roalt.dvb-t@roalt.com>)
	id 1NlTkO-0006Ig-Hd
	for linux-media@vger.kernel.org; Sat, 27 Feb 2010 21:58:48 +0100
Message-ID: <4B898788.9070106@roalt.com>
Date: Sat, 27 Feb 2010 21:58:48 +0100
From: Roalt <roalt.dvb-t@roalt.com>
Reply-To: roalt.dvb-t@roalt.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: No any working frequency/transponder with conceptronic ctvdigrcu
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm new to DVB-T as I just bought a Conceptronic CTVDIGRCU v3.0 (usb
dvb-t device), so I hope I do not ask a stupid question, but I do not
get any results when executing:

./w_scan -ft -c NL

It returns (after a long list of frequency/time logging):

ERROR: Sorry - i couldn't get any working frequency/transponder
Nothing to scan!!

I first tried the stock dvb-v4l in Ubuntu Karmic 2.6.31-19-generic and
the w_scan from the repostory and after that the
one from

hg clone http://linuxtv.org/hg/v4l-dvb/

and w_scan from:

wget "http://wirbel.htpc-forum.de/w_scan/w_scan-20091230.tar.bz2

... but with the same result. My Windows 7 with media center does work 
with the antenna in exactly the same position.

I do get some errors in dmesg but I'm not sure if they harmful:

Feb 27 16:34:51 spock kernel: [  111.934075] tda18271: performing RF 
tracking filter calibration
Feb 27 16:34:53 spock kernel: [  113.733475] af9013: I2C read failed 
reg:d417
Feb 27 16:34:53 spock kernel: [  113.733496] tda18271: RF tracking 
filter calibration failed!
Feb 27 16:36:37 spock kernel: [  217.485162] tda18271: performing RF 
tracking filter calibration
Feb 27 16:36:40 spock kernel: [  220.636388] tda18271: RF tracking 
filter calibration complete
Feb 27 16:43:05 spock kernel: [  605.802390] af9013: I2C read failed 
reg:d417
Feb 27 16:43:05 spock kernel: [  605.802639] af9013: I2C write failed 
reg:d3c0 len:1

Can somebody help me or point me to the right direction?

Roalt


|

