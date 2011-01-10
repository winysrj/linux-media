Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35482 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab1AJKpd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 05:45:33 -0500
Received: by gxk9 with SMTP id 9so4871606gxk.19
        for <linux-media@vger.kernel.org>; Mon, 10 Jan 2011 02:45:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110109095540.21fcd9e4@bike.lwn.net>
References: <1294484508-14820-1-git-send-email-hverkuil@xs4all.nl>
	<20110109095540.21fcd9e4@bike.lwn.net>
Date: Mon, 10 Jan 2011 10:45:32 +0000
Message-ID: <AANLkTi=9jZPTin=0TCrfPeiO9koE69pQLkqFjHOhLMZA@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 0/5] Use control framework in cafe_ccic and s_config removal
From: Daniel Drake <dsd@laptop.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

>> Another reason why s_config is a bad idea.

Thanks a lot for working on this. I had a quick look and don't have
any objections.

>> This has been extensively tested on my humble OLPC laptop (and it took me 4-5
>> hours just to get the damn thing up and running with these drivers).

In future, come into irc.oftc.net #olpc-devel and talk to me (dsd) or
cjb (Chris Ball), we'll get you up and running in less time!

I'll test the via-camera patch unless Jon beats me too it, but won't
be immediately. If you are ever interested in doing more in-depth work
on that driver, please drop me a mail and we will send you a XO-1.5.

Also, perhaps you are interested in working on this bug, which is
probably reproducible with cafe_ccic too:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg23841.html

Thanks!
Daniel
