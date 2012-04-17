Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.insync.za.net ([103.247.152.98]:58410 "EHLO
	mail.insync.za.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2DQAL2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 20:11:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by eragon.insync.za.net (8.14.4/8.14.4/Debian-2ubuntu2) with ESMTP id q3H02P2g019668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-media@vger.kernel.org>; Tue, 17 Apr 2012 12:02:25 +1200
Date: Tue, 17 Apr 2012 12:02:25 +1200 (NZST)
From: Pieter De Wit <pieter@insync.za.net>
To: linux-media@vger.kernel.org
Subject: v4l2 Device with H264 support
Message-ID: <alpine.DEB.2.02.1204171159380.3685@eragon.insync.za.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guys,

I would like to stream H264 from a v4l2 device that does hardware 
encoding. ffmpeg and all of those doesn't seem to understand H264, but 
v4l2 "does". If I run qv4l2, it shows that H264 is in the encoding list 
and I can preview that. Using v4l2-ctl, I can set the pixel format to H264 
and the "get-fmt" reports it correctly.

Is there any way I can get a "raw" frame dump from the v4l2 device ? I 
have used "all" the samples I can find and none seems to work.

Thanks,

Pieter
