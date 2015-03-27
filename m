Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:34230 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbbC0MIk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 08:08:40 -0400
Received: by qcay5 with SMTP id y5so14186919qca.1
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2015 05:08:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1427457439-1493-5-git-send-email-olli.salonen@iki.fi>
References: <1427457439-1493-1-git-send-email-olli.salonen@iki.fi>
	<1427457439-1493-5-git-send-email-olli.salonen@iki.fi>
Date: Fri, 27 Mar 2015 08:08:39 -0400
Message-ID: <CALzAhNX+covLWsgpUdW5sOfHtka6B93wK6y8o6A2+qt6PGkWug@mail.gmail.com>
Subject: Re: [PATCH 5/5] saa7164: Hauppauge HVR-2205 and HVR-2215 DVB-C/T/T2 tuners
From: Steven Toth <stoth@kernellabs.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: Linux-Media <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I know there's parallel activity ongoing regarding these devices, but I
> thought I'll submit my own version here as well. The maintainers of each
> module can then make the call what to merge.

http://git.linuxtv.org/cgit.cgi/stoth/media_tree.git/log/?h=saa7164-dev

As mentioned previously, I've added support for the HVR2205 and
HVR2255. I moved those patches from bitbucket.org into linuxtv.org a
couple of days ago pending a pull request. It took a couple of days to
get my git.linuxtv.org account back up and running.

You've seen and commented on the patches when they were in bitbucket
earlier this week, so your need to push our your own patches only
confuses and concerns me.

I did not require any 2168/2157 driver changes to make these devices
work. (Antti please note).

I plan to issue a pull request for my tree shortly.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
