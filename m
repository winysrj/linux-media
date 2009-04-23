Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:10620 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840AbZDWKPQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2009 06:15:16 -0400
Received: by wf-out-1314.google.com with SMTP id 26so404085wfd.4
        for <linux-media@vger.kernel.org>; Thu, 23 Apr 2009 03:15:14 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 23 Apr 2009 19:15:14 +0900
Message-ID: <5e9665e10904230315o46ef5f95o8c393a9148976880@mail.gmail.com>
Subject: About using VIDIOC_REQBUFS
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

Is it an ordinary way to use twice reqbuf without closing and
re-opening between them?

I mean like this,

1. Open device
2. VIDIOC_REQBUFS
     <snip>
3. VIDIOC_STREAMON
     <snip>
4. VIDIOC_STREAMOFF
5. VIDIOC_REQBUFS
     <snip>
6. VIDIOC_STREAMON

I suppose there should be a strict order for this. That order seems to
be wrong but necessary when we do capturing a JPEG data which size
(not resolution) is bigger than the preview data size. (Assuming that
user is using mmap)
Please let me know the right way for that kind of case. Just close and
re-open with big enough size for JPEG? or mmap with big enough size in
the first place?
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
