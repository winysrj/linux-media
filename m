Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:51180 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753856Ab2DXBAo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 21:00:44 -0400
Subject: Re: CX23102 audio; need datasheet
From: Andy Walls <awalls@md.metrocast.net>
To: "Dwayne C. Litzenberger" <dlitz@dlitz.net>
Cc: linux-media@vger.kernel.org
Date: Mon, 23 Apr 2012 21:00:38 -0400
In-Reply-To: <20120424004112.GA27441@rivest.dlitz.net>
References: <20120424004112.GA27441@rivest.dlitz.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1335229238.13891.17.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2012-04-23 at 20:41 -0400, Dwayne C. Litzenberger wrote:
> Hi there,
> 
> I'm working on adding support for another board to the cx231xx driver.  I'm 
> doing this work on my own time as a volunteer, so I don't have an existing 
> relationship with Conexant.
> 
> I bought an "AVerMedia DVD EZMaker 7" USB analog video digitizer, which is 
> a board with basically just a CX23102 and some RCA cables connected to it. 
> I have it mostly working, but the audio is silent (outputs all zeros).  
> It's probably something really simple to fix, but it's a real pain without 
> the datasheet.
> 
> This might help with other, similar boards, like the Hauppauge USB-Live2, 
> which is similar and also doesn't work according to the linuxtv wiki[1].
> 
> Could someone help me obtain a copy of the CX23102 datasheet?
>   I'm hoping 
> to get this done over the next 2 weeks on my vacation[2].

The analog section of the CX2310x chips is very similar to the analog
section of the CX2388[578] chips.  You may get somewhere without the
datasheet by examining the how the cx23885 (and cx25840) driver do
things.

Regards,
Andy

> 
> Cheers,
> - Dwayne
> 


