Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48262 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaJJWmt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Oct 2014 18:42:49 -0400
Received: by mail-wi0-f169.google.com with SMTP id cc10so5498622wib.0
        for <linux-media@vger.kernel.org>; Fri, 10 Oct 2014 15:42:48 -0700 (PDT)
Received: from [192.168.20.30] (optiplexnetworks.plus.com. [212.159.80.17])
        by mx.google.com with ESMTPSA id om1sm8361754wjc.42.2014.10.10.15.42.47
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Oct 2014 15:42:47 -0700 (PDT)
Message-ID: <543860E6.4070802@gmail.com>
Date: Fri, 10 Oct 2014 23:42:46 +0100
From: Kaya Saman <kayasaman@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Composite input seems cropped using Hauppauge WinTV-HVR 1900?
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

got a weird issue here.....

Trying to run my satellite box through my media center and all is good.

Slight issue when viewing though is that the capture stream seems to 
crop the height of the input? Basically the bottom of what's shown using 
the capture device is not the same as direct output from the satellite box.


It's almost like taking a 800x600 screen size yet only displaying 
800x550 or so?? Not sure if the horizontal is cropping too but vertical 
is definitely doing so.


Is there a v4l2-ctl command to get round it?


Basically what I'm doing is:

v4l2-ctl --set-input=1 (Composite)
mplayer /dev/video0 -fs


Could anyone help?


Thanks.


Kaya
