Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:54961 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab2DNGze (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Apr 2012 02:55:34 -0400
Received: from mfilter12-d.gandi.net (mfilter12-d.gandi.net [217.70.178.129])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id 1A30BA80A6
	for <linux-media@vger.kernel.org>; Sat, 14 Apr 2012 08:55:33 +0200 (CEST)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter12-d.gandi.net (mfilter12-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id Ok7lmJPftauA for <linux-media@vger.kernel.org>;
	Sat, 14 Apr 2012 08:55:31 +0200 (CEST)
Received: from [192.168.2.33] (80.42.93.79.rev.sfr.net [79.93.42.80])
	(Authenticated sender: daniel@berthereau.net)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 9FEDDA8086
	for <linux-media@vger.kernel.org>; Sat, 14 Apr 2012 08:55:31 +0200 (CEST)
Message-ID: <4F891F54.6030802@Berthereau.net>
Date: Sat, 14 Apr 2012 08:55:16 +0200
From: Daniel <daniel.videodvb@berthereau.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Add a new usb id for Elgato EyeTV DTT
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've got an Elgato EyeTV for Mac and PC 
(http://www.linuxtv.org/wiki/index.php/Elgato_EyeTV_DTT). It is given as 
compatible since Linux 2.6.31, but the usb id can be not only 0fd9:0021, 
but 0fd9:003f too. This id is currently not recognized...

Some pages explain how to change the id (see 
http://ubuntuforums.org/archive/index.php/t-1510188.html, 
http://ubuntuforums.org/archive/index.php/t-1756828.html and 
https://sites.google.com/site/slackwarestuff/home/elgato-eyetv).

Why this id is not included by default? When will it be included in the 
code?

Sincerely,

-- 
Daniel

