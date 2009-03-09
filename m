Return-path: <linux-media-owner@vger.kernel.org>
Received: from host170-142-static.86-94-b.business.telecomitalia.it ([94.86.142.170]:50572
	"EHLO zini-associati.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbZCIJmR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 05:42:17 -0400
Received: from zini-associati.it (localhost.localdomain [127.0.0.1])
	by zini-associati.it (Postfix) with ESMTP id 8B1D2D1225
	for <linux-media@vger.kernel.org>; Mon,  9 Mar 2009 10:42:14 +0100 (CET)
Received: from [192.168.0.10] (unknown [192.168.0.10])
	by zini-associati.it (Postfix) with ESMTP id 58DB2D1222
	for <linux-media@vger.kernel.org>; Mon,  9 Mar 2009 10:42:14 +0100 (CET)
Message-ID: <49B4E472.9070401@zini-associati.it>
Date: Mon, 09 Mar 2009 10:42:10 +0100
From: vic <vic@zini-associati.it>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: lifeview NOT LV3H not working
References: <49AC472B.90202@zini-associati.it>
In-Reply-To: <49AC472B.90202@zini-associati.it>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ciencio ha scritto:
[cut]
> So I downloaded the v4l tree from HG, compiled and installed it, but 
> this time was the firmware that was missing. I followed the instruction 
> to get the firmware for the xc3028  from here
> 
>>  http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip
> 
> and everything seemed to be perfect... but the tuner wasn't able to 
> detect anything.

Some news from my LV3H

1) after rebuilding the v4l from the main tree the analog tuner seems to 
be working, What I mean is thata tvtime is able to scan channels and to 
find them.

2) unfortunately there's no audio, in any way. If I connect the audio 
out to the audio of my sblive! I only get noise. If I try to send the 
output of the connexant audio device to the sblive! I always get only noise.

3) no news for the zl10353 driver, which keeps on giving the same error

>> [ 4982.520836] zl10353: write to reg 6c failed (err = -6)!


I don't know if anyone is interested in this report and I don't even 
know if I'm writing to the right mailing list.

Please let me know what I shoul post to get help,  if it is possible to 
get help :-)

-- 
Vic
