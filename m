Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:17527 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab3KCUVm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 15:21:42 -0500
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21110.45135.982014.774220@morden.metzler>
Date: Sun, 3 Nov 2013 21:21:35 +0100
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: DVB-C2
In-Reply-To: <52767C57.1050509@iki.fi>
References: <1382462076-29121-1-git-send-email-guest@puma.are.ma>
	<21095.747.879743.551447@morden.metzler>
	<20131103093155.50b59b45@samsung.com>
	<52767C57.1050509@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari writes:
 > On 03.11.2013 13:31, Mauro Carvalho Chehab wrote:
 > > Em Wed, 23 Oct 2013 00:57:47 +0200
 > > Ralph Metzler <rjkm@metzlerbros.de> escreveu:
 > >> I am wondering if anybody looked into API extensions for DVB-C2 yet?
 > >> Obviously, we need some more modulations, guard intervals, etc.
 > >> even if the demod I use does not actually let me set those (only auto).
 > >>
 > >> But I do need to set the PLP and slice ID.
 > >> I currently set them (8 bit each) by combining them into the 32 bit
 > >> stream_id (DTV_STREAM_ID parameter).
 > >
 > > I don't like the idea of combining them into a single field. One of the
 > > reasons is that we may have endianness issues.
 > >
 > > So, IMHO, the better is to add a new property for slice ID.
 > 
 > I tried to understand what that data slice is. So what I understand, it 
 > is layer to group PLPs, in order to get one wide OFDM channel as OFDM is 
 > more efficient when channel bw increases.
 > 
 > So, in order to tune "stream" channel on DVB-C2 system, you *must* know 
 > (in a order from radio channel to upper layers):
 > frequency
 > bandwidth
 > slice ID
 > PLP ID
 > 
 > Is that right?

Yes, if you do not want to parse L1 data you need the frequency of the slice,
bandwidth, slice ID and PLP ID.
If you parse L1 data, you do not need the slice ID because the PLP should be
unique in one channel. 

 > I wonder if PLP IDs are defined so that there could not be overlapping 
 > PLP IDs in a system... But if not, then defining slice ID is likely 
 > needed. And if and when slice ID is needed to know before PLP ID, it is 
 > even impossible to resolve slice ID from PLP ID.

See above, you can resolve it, but then you need to get the L1 data. 
But PLPs can even be spread over several slices to get higher bandwidth 
for one PLP. This is probably not used for broadcast TV though. You will
also need one tuner/demod per slice then.

So, basically you only need any frequency for the "channel" (can be spread over 
up to 450MHz, but avoid notches) and the bandwith.
Tune until a L1 lock, get L1 data from demod (up to 4 KB), parse for the PLP
id you want, get the corresponding slice (or slices), tune to the slice frequency
with slice ID set and PLP id set and wait for a full lock ...


Regards,
Ralph
 
