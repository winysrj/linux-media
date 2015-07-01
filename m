Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.academica.fi ([109.75.228.249]:37046 "EHLO
	smtp41.academica.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbbGAKG4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jul 2015 06:06:56 -0400
Message-ID: <5593BBBE.2060801@iki.fi>
Date: Wed, 01 Jul 2015 13:06:54 +0300
From: Jouni Karvo <Jouni.Karvo@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	=?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: cx23885 risc op code error with DvbSKY T982
References: <55870014.90902@iki.fi> <5587D8A5.70905@iki.fi> <5587DB9F.4020008@gmail.com> <55911239.4000709@iki.fi> <5593AEA6.7020901@iki.fi> <5593AF28.4030303@xs4all.nl>
In-Reply-To: <5593AF28.4030303@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

01.07.2015, 12:13, Hans Verkuil kirjoitti:
>
> Do you actually see any visual artifacts, or is it just messages in the log?
hi,

I am pretty certain that these are minor problems.  The cards seem to 
work fine after the messages, so I would not call this urgent. Some 
recordings have visual artefacts, but I do not know whether they happen 
because of these events or because of the broadcast transmission or for 
some other reason.  These occur every few hours in the log/ or a few 
times a day (with three cx23885 based cards on the PCIe bus).

I started to look at the driver as for 3.19 kernel coming with ubuntu 
(https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1451009) the cards 
seemed to crash.  For 4.0.6 and 4.1.0 the cards work, but as I was 
already looking at this, I decided to report these.

If you think these messages are not worth more effort, I am OK with it.

yours,
         Jouni
