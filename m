Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:36427 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbbH1Mrz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 08:47:55 -0400
Received: by ioej130 with SMTP id j130so9155133ioe.3
        for <linux-media@vger.kernel.org>; Fri, 28 Aug 2015 05:47:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55E01B0B.1040704@xs4all.nl>
References: <55D730F4.80100@xs4all.nl>
	<CAPybu_2hn8LuKy-n74cpQ1UOFvxgTv8SmXka6PwPY+U1XnZeDg@mail.gmail.com>
	<55D85325.80607@xs4all.nl>
	<CALzAhNVSY=yDWFk1fZnibOuThGW3J_s0sTQNhGGN8z1_U_regw@mail.gmail.com>
	<55D86F3C.6090004@xs4all.nl>
	<CALzAhNWhu-w+3x6S-_0ToAUAzELZSuQqo7q5NmpxXfCdciY0hw@mail.gmail.com>
	<55DDBB73.5010902@xs4all.nl>
	<CALzAhNVxrWOsU72jin4_ygwazX2cnqBaMoPGZ_Kv77xgGx7KmA@mail.gmail.com>
	<55E014E6.5000801@xs4all.nl>
	<55E01B0B.1040704@xs4all.nl>
Date: Fri, 28 Aug 2015 08:47:54 -0400
Message-ID: <CALzAhNV5CDc_1heiKzN4hmjc97AUzHZ=hYgop9EfLro4O0RSCw@mail.gmail.com>
Subject: Re: [PATCH] saa7164: convert to the control framework
From: Steven Toth <stoth@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> but the default firmware with size 4919072 fails to work (image corrupt), instead
>> I need to use the firmware with size 4038864 (v4l-saa7164-1.0.3-3.fw).
>
> That's v4l-saa7164-1.0.2-3.fw, sorry for the confusion.

Right, you need to load the -02 firmware on a -02 board.

>
> Googling suggests that you have patches for this that never made it upstream.
> Can you post it?

I will. If you can confirm you have a -02 PCIe IC then I'll prep some
firmware patches for testing. To be clear, I think the current in
kernel tree is perfectly good for all -03 boards. For -02 boards
(fewer of these in the field) it may be a problem, but I'll fix.

I also plan to test the control framework changes, and the compliance
patches (thanks btw).

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
