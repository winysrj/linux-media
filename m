Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:13731 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZDVGbg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2009 02:31:36 -0400
Received: by wf-out-1314.google.com with SMTP id 26so125552wfd.4
        for <linux-media@vger.kernel.org>; Tue, 21 Apr 2009 23:31:36 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 22 Apr 2009 15:31:35 +0900
Message-ID: <5e9665e10904212331x421eb6yb09a3e4acd198e1f@mail.gmail.com>
Subject: JPEG sync with OMAP3 camera interface
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>,
	dongsoo45.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm working on OMAP3 with external camera module which has JPEG
encoder feature and connected to parallel interface.
I tried to sync JPEG data like the instruction on OMAP3 user manual
but don't even know what to check to sync JPEG data properly.
I'm using Sakari's camera interface which seems to not considering
about JPEG yet.
Anybody knows about what to check and how to sync JPEG data? I don't
have any clue. ;-(
Cheers,

Nate

-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
