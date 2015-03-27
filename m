Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42358 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbbC0MNd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 08:13:33 -0400
Message-ID: <5515496A.4050600@iki.fi>
Date: Fri, 27 Mar 2015 14:13:30 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>,
	Olli Salonen <olli.salonen@iki.fi>
CC: Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 5/5] saa7164: Hauppauge HVR-2205 and HVR-2215 DVB-C/T/T2
 tuners
References: <1427457439-1493-1-git-send-email-olli.salonen@iki.fi>	<1427457439-1493-5-git-send-email-olli.salonen@iki.fi> <CALzAhNX+covLWsgpUdW5sOfHtka6B93wK6y8o6A2+qt6PGkWug@mail.gmail.com>
In-Reply-To: <CALzAhNX+covLWsgpUdW5sOfHtka6B93wK6y8o6A2+qt6PGkWug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/27/2015 02:08 PM, Steven Toth wrote:
>> I know there's parallel activity ongoing regarding these devices, but I
>> thought I'll submit my own version here as well. The maintainers of each
>> module can then make the call what to merge.
>
> http://git.linuxtv.org/cgit.cgi/stoth/media_tree.git/log/?h=saa7164-dev
>
> As mentioned previously, I've added support for the HVR2205 and
> HVR2255. I moved those patches from bitbucket.org into linuxtv.org a
> couple of days ago pending a pull request. It took a couple of days to
> get my git.linuxtv.org account back up and running.
>
> You've seen and commented on the patches when they were in bitbucket
> earlier this week, so your need to push our your own patches only
> confuses and concerns me.
>
> I did not require any 2168/2157 driver changes to make these devices
> work. (Antti please note).

There seems to be only minor TS config change (which is not even needed 
if you set that bit to existing TS mode config value) for 
gapped/variable length TS clock (which is in my understanding to leave 
TS valid line unconnected).

> I plan to issue a pull request for my tree shortly.
>
> - Steve
>

Antti
-- 
http://palosaari.fi/
