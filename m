Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46246 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbZKOJjg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2009 04:39:36 -0500
Received: by bwz27 with SMTP id 27so4734595bwz.21
        for <linux-media@vger.kernel.org>; Sun, 15 Nov 2009 01:39:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091115094342.759cee65@tele>
References: <880dece00911140735n14f79fb6k6e854a5a852ff6fe@mail.gmail.com>
	 <20091115094342.759cee65@tele>
Date: Sun, 15 Nov 2009 11:39:40 +0200
Message-ID: <880dece00911150139v22f2bdf5nc201f44546e62ce5@mail.gmail.com>
Subject: Re: MSI StarCam 370i: The right way?
From: Dotan Cohen <dotancohen@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> In the kernel you have (2.6.31) two drivers may try to handle your
> webcam: gspca_sonixj and sn9c102. If both are generated, the active
> driver changes at each webcam unplug/replug (you may know which driver
> is active looking at the last lines of 'dmesg').
>
> If the driver gspca_sonixj does not work, you may try its last version
> from LinuxTv.org (many bugs have been found since kernel 2.6.31).
>

Thank you Jean-Francois. Is unplug/replug the only way to switch
drivers? Apparently neither driver works, where is a good place to get
the snc102 driver to try as well? Googling "snc102 linux driver" did
not lead me to any place to download it.

Thanks!


-- 
Dotan Cohen

http://what-is-what.com
http://gibberish.co.il
