Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873Ab0EURzO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 May 2010 13:55:14 -0400
Date: Fri, 21 May 2010 13:54:56 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Ang Way Chuang <wcang79@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: dvb-core: Fix ULE decapsulation bug when less than 4 bytes of
 ULE SNDU is packed into the remaining bytes of a MPEG2-TS frame
Message-ID: <20100521175456.GL22862@redhat.com>
References: <4BE2D7A6.30201@gmail.com>
 <20100520192213.GA19133@redhat.com>
 <4BF600B2.1080305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF600B2.1080305@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 21, 2010 at 11:40:34AM +0800, Ang Way Chuang wrote:
> Hi Jarod,
>    Thanks for the review. My answers are inlined.
> 
> Jarod Wilson wrote:
> >On Thu, May 06, 2010 at 02:52:22PM -0000, Ang Way Chuang wrote:
> >>ULE (Unidirectional Lightweight Encapsulation RFC 4326)
> >>decapsulation code has a bug that incorrectly treats ULE SNDU
> >>packed into the remaining 2 or 3 bytes of a MPEG2-TS frame as
> >>having invalid pointer field on the subsequent MPEG2-TS frame.
> >>
> >>This patch was generated and tested against v2.6.34-rc6. I
> >>suspect that this bug was introduced in kernel version 2.6.15,
> >>but had not verified it.
> >>
> >>Care has been taken not to introduce more bug by fixing this bug, but
> >>please scrutinize the code because I always produces buggy code.
...
> >>@@ -534,6 +535,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
> >>				from_where += 2;
> >>			}
> >>
> >>+			priv->ule_sndu_remain = priv->ule_sndu_len + 2;
> >>			/*
> >>			 * State of current TS:
> >>			 *   ts_remain (remaining bytes in the current TS cell)
> >
> >Is this *always* true? Your description says "...the remaining 2 or 3
> >bytes", indicating this could sometimes need to be +3. Is +0 also a
> >possibility?
> >
> 
> Not sure whether I understand your question correctly. Here is my
> attempt to answer your question. The encapsulation format always
> mandate that at least of 2 bytes of ULE SNDU (the LENGTH field) must
> be present within a MPEG2-TS frame. So, if only 1 byte of the ULE
> SNDU get packed into the remaining MPEG2-TS frame, then it is
> invalid. Of course, there is no issue regarding 0 byte as that would
> be the case of filling MPEG2-TS frame up to its boundary. New ULE
> SNDU will have to packed into the next MPEG2-TS frame in that case.
> 
> Now the problem with existing code is the interpretation of
> remainder length when 2 or 3 bytes of ULE SNDU are packed into the
> remainder of MPEG2-TS frame. In the 2 bytes case, only the LENGTH
> field is available while in the case 3 bytes, only the 1st octet of
> the 2-octets TYPE field and the LENGTH field are available. The
> ule_sndu_remain should carry the value of length of ULE SNDU
> following the the TYPE field. Technically, this would mean that
> remainder byte of ULE SNDU that need to be received is going to be:
> 
> Value(LENGTH) + 2 (We owe 2 bytes of TYPE field here) if only 2
> bytes of ULE SNDU is packed (as in the case of case 0: at line 550).
> This is addressed by adding the priv->ule_sndu_remain =
> priv->ule_sndu_len + 2;
> 
> Value(LENGTH) + 1 (We owe 1 byte of TYPE field here) if 3 bytes of
> ULE SNDU is packed (as in the case of case 1: at 545). This is
> addressed by adding priv->ule_sndu_remain--;
> 
> If complete ULE header (>= 4 bytes) is available:
> priv->ule_sndu_remain = priv->ule_sndu_len; at line 582 takes care
> of the rest and it works just fine in the existing code.
> 
> Due to the wrong interpretation of remaining length of ULE SNDU when
> 2 or 3 bytes of ULE SNDU are packed into a MPEG2-TS frame, the
> subsequent checking of payload pointer (line 455) always fails
> leading to unnecessary packet drops.
> 
> Looking back at the fix after a few months, I had trouble
> understanding how these few lines fixed the problem at first glance.

Yeah, my question was whether or not the +2 would account for both the +2
bytes and +3 bytes situations, and it seems that's handled appropriately
by the ts_remain switch. Thank you for the detailed explanation.

If you'd alter that nested check for freeing the skb and give it a quick
test, I'm happy to throw an acked-by or reviewed-by on a followup
submission.


-- 
Jarod Wilson
jarod@redhat.com

