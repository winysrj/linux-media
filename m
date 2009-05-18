Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:46514 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZERXuA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 19:50:00 -0400
Received: by ey-out-2122.google.com with SMTP id 9so1116484eyd.37
        for <linux-media@vger.kernel.org>; Mon, 18 May 2009 16:50:00 -0700 (PDT)
Message-ID: <4A11F166.1050908@gmail.com>
Date: Tue, 19 May 2009 02:38:14 +0300
From: mahmut g <m.gundes@gmail.com>
MIME-Version: 1.0
CC: pwc@lists.saillard.org,
	video4linux-list <video4linux-list@redhat.com>,
	linux-media@vger.kernel.org
Subject: capture and stream
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



     Hi all,

     finally I learned some about v4l2 and pwc. I can capture frames in 
raw and yuv420 format, I think there is already not any other format 
which pwc supports. I have philips SPC 900NC webcam and I want to 
streaming captured frames on LAN. I need some advice after that point. I 
am new at this issues and need answer of some question to go on. Which 
format I must choose(raw/yuv) and how can I stream this capture to any 
LAN ip? Do I need transcode stream, encoding.. or just sending to socket 
will be fine? Quality of images are not too important for me. I just 
want to see the stream of webcam from another computer.


Thank you all
Best Regards.

Mahmut
