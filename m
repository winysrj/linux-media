Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:49955 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbbKTO0B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 09:26:01 -0500
Subject: Re: PID filter testing
To: =?UTF-8?Q?Honza_Petrou=c5=a1?= <jpetrous@gmail.com>
References: <564EFD40.8050504@southpole.se>
 <CAJbz7-2=-ufqdE0YyPUAhV+UybMsmEv7=FuFhrn6o9G7yvXZOg@mail.gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Benjamin Larsson <benjamin@southpole.se>
Message-ID: <564F2D77.9080301@southpole.se>
Date: Fri, 20 Nov 2015 15:25:59 +0100
MIME-Version: 1.0
In-Reply-To: <CAJbz7-2=-ufqdE0YyPUAhV+UybMsmEv7=FuFhrn6o9G7yvXZOg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/20/2015 02:27 PM, Honza Petrouš wrote:
> 2015-11-20 12:00 GMT+01:00 Benjamin Larsson <benjamin@southpole.se>:
>> Hi, what tools can I use to test pid filter support in the drivers ?
>
> Zap utility from dvbapps seems to be some simpler way - you can pass them
> the fixed pids and record filtered data by simple command.
>
> See at:
> http://www.linuxtv.org/wiki/index.php/Zap
>
> /Honza

Hi, can you elaborate with a command line example ? To start with I want 
only the 0x1fff pid from a random dvb-c mux.

MvH
Benjamin Larsson


