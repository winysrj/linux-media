Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33342 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2DNKBG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Apr 2012 06:01:06 -0400
Received: by wgbdr13 with SMTP id dr13so3737884wgb.1
        for <linux-media@vger.kernel.org>; Sat, 14 Apr 2012 03:01:05 -0700 (PDT)
Message-ID: <4F894ADE.60703@gmail.com>
Date: Sat, 14 Apr 2012 12:01:02 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Daniel <daniel.videodvb@berthereau.net>
CC: linux-media@vger.kernel.org
Subject: Re: Add a new usb id for Elgato EyeTV DTT
References: <4F891F54.6030802@Berthereau.net>
In-Reply-To: <4F891F54.6030802@Berthereau.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 14/04/2012 08:55, Daniel ha scritto:
> Hi,
> 
> I've got an Elgato EyeTV for Mac and PC
> (http://www.linuxtv.org/wiki/index.php/Elgato_EyeTV_DTT). It is given as
> compatible since Linux 2.6.31, but the usb id can be not only 0fd9:0021,
> but 0fd9:003f too. This id is currently not recognized...
> 
> Some pages explain how to change the id (see
> http://ubuntuforums.org/archive/index.php/t-1510188.html,
> http://ubuntuforums.org/archive/index.php/t-1756828.html and
> https://sites.google.com/site/slackwarestuff/home/elgato-eyetv).
> 
> Why this id is not included by default? When will it be included in the
> code?
> 
> Sincerely,
> 

Hi Daniel,
new USB PIDs are added when someone reports on this list that they are
working.
That's exactly what you did, so now it's possible to add it.
If you know how to do it, you can create a patch to add the new ID.
Of course you have to define a new PID, as you cannot overwrite an
existing PID like they suggest on the Ubuntu forums.
If you don't know hot to do a patch, I can do it for you, as long as you
are willing to test it.

It would be nice to know the exact name of the new product. I see people
reporting it as a new revision of the Elgato EyeTV DTT and others as the
Elgato EyeTV Deluxe. Which one do you have exactly?

Regards,
Gianluca
