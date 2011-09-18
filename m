Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:50995 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753004Ab1IRCaB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Sep 2011 22:30:01 -0400
References: <4E754128.6060803@gmail.com>
In-Reply-To: <4E754128.6060803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: HVR-1600 and HVR-1250
From: Andy Walls <awalls@md.metrocast.net>
Date: Sat, 17 Sep 2011 22:30:12 -0400
To: Stephen Atkins <stephen.atkins@gmail.com>,
	linux-media@vger.kernel.org
Message-ID: <ee61ab91-7731-4300-be44-6923e7a2a270@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stephen Atkins <stephen.atkins@gmail.com> wrote:

>I'm not sure if this is the right list or not but I thought I would
>give 
>it a try.
>
>I've got a HVR-1600 which works great and I can get MythTV to record an
>
>analog and digital at the same time.
>
>I decided that I needed a second tuner to record another digital
>signal. 
>  I picked up an HVR-1250 (Linux sees it as a HVR-1255).  It's one of 
>the newer cards in the 22xxx model.
>
>Once I got it setup I could record two digtal's no problem but my
>analog 
>on the 1600 lost audio.  It also won't tune above ch 13. I'm wondering 
>if there is anything I can do to get these cards to play nicely.
>
>Thanks
>Stephen
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Try blacklisting the cx18 module in /etc/modprobe.d/foo, and then have a script modprobe the cx18 module later after all the IO at boot has settled down.

-Andy
