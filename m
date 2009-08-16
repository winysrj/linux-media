Return-path: <linux-media-owner@vger.kernel.org>
Received: from mp1-smtp-2.eutelia.it ([62.94.10.162]:52416 "EHLO
	smtp.eutelia.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752383AbZHPJYI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Aug 2009 05:24:08 -0400
Received: from [192.168.1.170] (ip-173-192.sn3.eutelia.it [213.136.173.192])
	by smtp.eutelia.it (Eutelia) with ESMTP id 717F4C1C42
	for <linux-media@vger.kernel.org>; Sun, 16 Aug 2009 11:24:04 +0200 (CEST)
Message-ID: <4A87D018.7070607@email.it>
Date: Sun, 16 Aug 2009 11:23:36 +0200
From: xwang1976@email.it
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Using two different usb devices (at least not at the same time).
References: <4A79EC82.4050902@email.it> <4A7AE0B0.20507@email.it>	 <829197380908060717ua009e78nc045f2940c7fc76e@mail.gmail.com>	 <20090806112317.21240b9c@gmail.com> <4A7AF3CF.3060803@email.it> <829197380908060821x6cfb60f0jd73e5f9b30c21569@mail.gmail.com> <4A7B0333.1010901@email.it> <4A81D38A.2050201@email.it>
In-Reply-To: <4A81D38A.2050201@email.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi to all!
As you probably know from my previous mails, I own two usb hybrid devices:
1) Empire Dual Pen
2) Dikom DK-300
There are still some problems with them (which I hope I can help solving 
with my testing) and I would like to know if I can use one of them and 
then the other without the need of module removal or if it is better to 
manually rmmod the em28xx modules after the removal of the first device 
and before the insertion of the second one.
Thank you,
Xwang
