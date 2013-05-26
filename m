Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42031 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab3EZGe1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 02:34:27 -0400
Received: by mail-we0-f174.google.com with SMTP id x50so1762262wes.19
        for <linux-media@vger.kernel.org>; Sat, 25 May 2013 23:34:26 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 26 May 2013 15:34:26 +0900
Message-ID: <CACySJQX-GUYax5MPounyFCUczgncPx=SV=8O6ORd_zwfn31jkQ@mail.gmail.com>
Subject: Mistake on the colorspace page in the API doc
From: Wouter Thielen <wouter@morannon.org>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have been trying to get the colors right in the images grabbed from my
webcam, and I tried the color conversion code on
http://linuxtv.org/downloads/v4l-dvb-apis/colorspaces.html.

It turned out to be very white, so I checked out the intermediate steps,
and thought the part:

ER = clamp (r * 255); /* [ok? one should prob. limit y1,pb,pr] */
EG = clamp (g * 255);
EB = clamp (b * 255);


should be without the * 255. I tried removing *255 and that worked.

Regards,

--
Wouter Thielen
http://morannon.org/
