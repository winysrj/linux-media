Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:56237 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbaCGWdi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Mar 2014 17:33:38 -0500
Received: from [192.168.178.28] ([134.3.109.71]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0MTBLi-1WmyO6225u-00SBPz for
 <linux-media@vger.kernel.org>; Fri, 07 Mar 2014 23:33:36 +0100
Message-ID: <531A4940.6020403@pinguin74.gmx.com>
Date: Fri, 07 Mar 2014 23:33:36 +0100
From: pinguin74 <pinguin74@gmx.com>
MIME-Version: 1.0
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: sound dropouts with DVB
References: <5318ED33.4040009@pinguin74.gmx.com>	<CA+O4pCJ4OPGEC3_RUoxjPfScgL9vEGPbUOCefjNgFOrRcYvgMw@mail.gmail.com>	<53190270.80407@pinguin74.gmx.com> <CA+O4pC+R8ZXZ_wYfa2y82TPwCD4q_fUh96pgbYu2VUhVyGPGvQ@mail.gmail.com>
In-Reply-To: <CA+O4pC+R8ZXZ_wYfa2y82TPwCD4q_fUh96pgbYu2VUhVyGPGvQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> The mediaplayer is using a codec for decoding/unpacking the compressed
> digital stream.

Oh, I just see my TV provider sends two video streams for each channel,
a H264 encoded video stream and an MPEG2 video stream, both in each
channel.

No matter if a channel is HD or not, there is always a H264 stream and
an MPEG2 video stream.

But I have no clue how to tell Xine or VLC to play either the H264
stream or the MPEG2 stream....

Thanks

