Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:63230 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3KDMKq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 07:10:46 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVQ00HMBN5XZ620@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 04 Nov 2013 07:10:45 -0500 (EST)
Date: Mon, 04 Nov 2013 10:10:41 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: DVB-C2
Message-id: <20131104101041.48c5e782@samsung.com>
In-reply-to: <21110.45135.982014.774220@morden.metzler>
References: <1382462076-29121-1-git-send-email-guest@puma.are.ma>
 <21095.747.879743.551447@morden.metzler> <20131103093155.50b59b45@samsung.com>
 <52767C57.1050509@iki.fi> <21110.45135.982014.774220@morden.metzler>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 03 Nov 2013 21:21:35 +0100
Ralph Metzler <rjkm@metzlerbros.de> escreveu:

> Antti Palosaari writes:
>  > On 03.11.2013 13:31, Mauro Carvalho Chehab wrote:
>  > > Em Wed, 23 Oct 2013 00:57:47 +0200
>  > > Ralph Metzler <rjkm@metzlerbros.de> escreveu:
>  > >> I am wondering if anybody looked into API extensions for DVB-C2 yet?
>  > >> Obviously, we need some more modulations, guard intervals, etc.
>  > >> even if the demod I use does not actually let me set those (only auto).
>  > >>
>  > >> But I do need to set the PLP and slice ID.
>  > >> I currently set them (8 bit each) by combining them into the 32 bit
>  > >> stream_id (DTV_STREAM_ID parameter).
>  > >
>  > > I don't like the idea of combining them into a single field. One of the
>  > > reasons is that we may have endianness issues.
>  > >
>  > > So, IMHO, the better is to add a new property for slice ID.
>  > 
>  > I tried to understand what that data slice is. So what I understand, it 
>  > is layer to group PLPs, in order to get one wide OFDM channel as OFDM is 
>  > more efficient when channel bw increases.
>  > 
>  > So, in order to tune "stream" channel on DVB-C2 system, you *must* know 
>  > (in a order from radio channel to upper layers):
>  > frequency
>  > bandwidth
>  > slice ID
>  > PLP ID
>  > 
>  > Is that right?
> 
> Yes, if you do not want to parse L1 data you need the frequency of the slice,
> bandwidth, slice ID and PLP ID.
> If you parse L1 data, you do not need the slice ID because the PLP should be
> unique in one channel. 
> 
>  > I wonder if PLP IDs are defined so that there could not be overlapping 
>  > PLP IDs in a system... But if not, then defining slice ID is likely 
>  > needed. And if and when slice ID is needed to know before PLP ID, it is 
>  > even impossible to resolve slice ID from PLP ID.
> 
> See above, you can resolve it, but then you need to get the L1 data. 
> But PLPs can even be spread over several slices to get higher bandwidth 
> for one PLP. This is probably not used for broadcast TV though. You will
> also need one tuner/demod per slice then.
> 
> So, basically you only need any frequency for the "channel" (can be spread over 
> up to 450MHz, but avoid notches) and the bandwith.
> Tune until a L1 lock, get L1 data from demod (up to 4 KB), parse for the PLP
> id you want, get the corresponding slice (or slices), tune to the slice frequency
> with slice ID set and PLP id set and wait for a full lock ...

Ok, then it is really better to have slice as a separate property, and to
document the above procedure to tune into a slice at a DVB-C2 section
to be added to the DocBook.

We'll need to define a value for slice to mean "don't bind to any slice".
Maybe 2^32-1.

With regards to the slice property, it would be possible to let it
have multiple values (just like we do with ENUM_DELSYS). Not sure if 
this makes sense or not.

Regards,
Mauro
