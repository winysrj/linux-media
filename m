Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:22065 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbZCIBmF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2009 21:42:05 -0400
Received: by rv-out-0506.google.com with SMTP id g37so1405614rvb.1
        for <linux-media@vger.kernel.org>; Sun, 08 Mar 2009 18:42:03 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 9 Mar 2009 10:42:03 +0900
Message-ID: <5e9665e10903081842h2c8a7185lc9a7e2a6d0f63a2a@mail.gmail.com>
Subject: Is there any reference for v4l2-subdev?
From: Dongsoo Nathaniel Kim <dongsoo.kim@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

I've been working on camera device based on v4l2-int-device until now,
but to follow latest work of yours I decided to make my driver in v4l2
subdev before I send patch to the list.
So I'm trying to find any passable driver to reference but I haven't
found any one yet.
Only thing I could find was v4l2-framework.txt for now. Am I missing something?
I've not look into every single repository in hg yet, but which one
could be the right one I am looking for?
Please give me a guideline if there are some further work besides
v4l2-framework.txt.
Cheers,

Nate

-- 
========================================================
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
