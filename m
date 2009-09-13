Return-path: <linux-media-owner@vger.kernel.org>
Received: from best-of-bremen.com ([217.160.217.225]:37384 "HELO
	p15135933.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754132AbZIMOhR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 10:37:17 -0400
From: Martin Konopka <martin.konopka@mknetz.de>
To: hermann pitton <hermann-pitton@arcor.de>
Subject: Re: Pinnacle PCTV 310i active antenna
Date: Sun, 13 Sep 2009 16:37:12 +0200
Cc: linux-media@vger.kernel.org
References: <200907011701.43079.martin.konopka@mknetz.de> <200908281827.58036.martin.konopka@mknetz.de> <1251589115.26402.11.camel@pc07.localdom.local>
In-Reply-To: <1251589115.26402.11.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909131637.12483.martin.konopka@mknetz.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hermann,

thank you, the patch for the antenna power is working for me with the latest 
mercurial tree. I'm now able to receive additional weak channels. On the 
contrary a channel close by with a very strong signal disappeared. The 
stand-alone receiver with antenna power that I have can receive both channels 
at the same time.

Am Sonntag, 30. August 2009 01:38:35 schrieb hermann pitton:
> A testhack, not a clean implementation, is attached and should give you
> voltage to the active antenna when using DVB-T.
>
> BTW, the radio seems to be broken since some weeks.
> It is not by that patch here.
>
> Cheers,
> Hermann
>


Cheers,

Martin
