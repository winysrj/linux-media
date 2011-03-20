Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39746 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1CTA4I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Mar 2011 20:56:08 -0400
Received: by ywj3 with SMTP id 3so2011170ywj.19
        for <linux-media@vger.kernel.org>; Sat, 19 Mar 2011 17:56:07 -0700 (PDT)
Message-ID: <4D8550A3.5010604@aapt.net.au>
Date: Sun, 20 Mar 2011 11:56:03 +1100
From: Andrew Goff <goffa72@gmail.com>
Reply-To: goffa72@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Leadtek Winfast 1800H FM Tuner
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi, I hope someone may be able to help me solve a problem or point me in 
the right direction.

I have been using a Leadtek Winfast DTV1800H card (﻿Xceive xc3028 tuner) 
for a while now without any issues (DTV & Radio have been working well), 
I recently decided to get another tuner card, Leadtek Winfast DTV2000DS 
(Tuner: NXP TDA18211, but detected as TDA18271 by V4L drivers, Chipset: 
AF9015 + AF9013 ) and had to compile and install the V4L drivers to get 
it working. Now DTV on both cards work well but there is a problem with 
the radio tuner on the 1800H card.

After installing the more recent V4L drivers the radio frequency is 
2.7MHz out, so if I want to listen to 104.9 I need to tune the radio to 
107.6. Now I could just change all my preset stations but I can not 
listen to my preferred stations as I need to set the frequency above 108MHz.

Andrew
