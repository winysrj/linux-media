Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:62579 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbaCGVUB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Mar 2014 16:20:01 -0500
Received: from [192.168.178.28] ([134.3.109.71]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0McmFl-1Wdyi109XV-00Hy6f for
 <linux-media@vger.kernel.org>; Fri, 07 Mar 2014 22:20:00 +0100
Message-ID: <531A37FF.5080509@pinguin74.gmx.com>
Date: Fri, 07 Mar 2014 22:19:59 +0100
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

Am 07.03.2014 00:36, schrieb Markus Rechberger:

>> I will try with mplayer later. What does codec issue mean? I think the
>> audio stream in DVB-C is a digital stream that does not need to be
>> changed or encoded in any way? I thought DVB playback simply is a kind
>> of pass thru the digital streamt to the media player....
> 
> The mediaplayer is using a codec for decoding/unpacking the compressed
> digital stream.

Oh yes, of course. Is this not also called "demuxing"? Or is demuxing
just the splitting of the stream?

I found out this may be an issue with the snd-hda-intel module.

When I use a different model option for this module, the siutation
changes, at least the bluetooth headphone does not lose connection, but
audio still drops out.

MPlayer reports I and B frame errors, but DVB works.

I now use
modprobe snd-hda-intel model=acer-aspire align_buffer_size=128000

I will try out VLC now with DVB to see if the VLC codecs work better
than Xine/kaffeine.

Thanx.

