Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:36073 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751052AbeBJQDR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Feb 2018 11:03:17 -0500
To: mchehab@s-opensource.com, linux-media@vger.kernel.org
References: <50428a71afb3edb25444c0a9259f758ef5029d34.1518264808.git.mchehab@s-opensource.com>
Subject: Re: [PATCH] media: m88ds3103: don\t call a non-initalized function
From: "rwarsow@gmx.de" <rwarsow@gmx.de>
Message-ID: <1d04f19f-7e0e-1f44-e69d-85686c272a3a@gmx.de>
Date: Sat, 10 Feb 2018 17:03:12 +0100
MIME-Version: 1.0
In-Reply-To: <50428a71afb3edb25444c0a9259f758ef5029d34.1518264808.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hallo

OOPS'es also happen with correct chip ID's.

see:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg125726.html

currently I can't provide any info, cause I send my device back to the 
seller.

I tested
- vanilla kernel 4.15.2, 4.1.49
- distro kernel 4.14.16-300.fc27.x86_64, 4.2.3-300.fc23.x86_64


-- 

Greeting

Ronald
