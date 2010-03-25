Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f176.google.com ([209.85.223.176]:40886 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab0CYBGW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 21:06:22 -0400
Received: by iwn6 with SMTP id 6so3136991iwn.4
        for <linux-media@vger.kernel.org>; Wed, 24 Mar 2010 18:06:21 -0700 (PDT)
Message-ID: <4BAAB706.5050507@gmail.com>
Date: Wed, 24 Mar 2010 22:06:14 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
CC: Serge Pontejos <jeepster.goons@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Which of my 3 video capture devices will work best with my PC?
References: <dfbf38831003241545s48e717c6i366599fd705c221c@mail.gmail.com> <1269471975.6885.54.camel@pc07.localdom.local>
In-Reply-To: <1269471975.6885.54.camel@pc07.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>> --This one recognizes and I can display video but if I try to record
>> in either xawtv or Kdenlive the program crashes.

Try to use/adapt this script at v4l-utils git tree(http://git.linuxtv.org/v4l-utils.git)
	contrib/v4l_rec.pl

It basically uses either mencoder or ffmpeg to generate an mpeg encoded stream
from a video analog capture device.

-- 

Cheers,
Mauro
