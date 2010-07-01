Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37468 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab0GALZm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Jul 2010 07:25:42 -0400
Received: by gyd12 with SMTP id 12so940654gyd.19
        for <linux-media@vger.kernel.org>; Thu, 01 Jul 2010 04:25:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20081599.48.1277920125030.JavaMail.root@ginder>
References: <4C2B33B6.90408@gmail.com>
	<20081599.48.1277920125030.JavaMail.root@ginder>
Date: Thu, 1 Jul 2010 21:25:40 +1000
Message-ID: <AANLkTin9gsrxJn8RGkkU56hyJWRJeiwiuqiTGZtyAbe0@mail.gmail.com>
Subject: Re: [linux-dvb] TeVii S470 in mythtv - diseqc problems
From: OM Ugarcina <mo.ucina@gmail.com>
To: Hans Houwaard <hans@ginder.xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

Much thanks for your advice . I have done that options setting  and it
helped with my other issues . I have just worked out this problem . It
was connected with the changing of the DVBS card that I used for years
with a new DVBS2 and Mythtv . I thought that it was the drivers issue
- but it is not . My apologies to the DVB developers ( sorry Igor for
doubting ) . The issue is that Mythtv when dealing with DVBS2 card
will need to access an additional parameter from the dtv_multiplex
table which is mod_sys . In my mod_sys column  there was only "1" ,
instead of a proper setting such as "DVB-S" . After updating the table
, mythtv was able to execute a tune properly .


Best Regards

Milorad
