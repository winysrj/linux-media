Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14132 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483AbbIVJN4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 05:13:56 -0400
Subject: Re: [PATCH 00/38] Fixes related to incorrect usage of unsigned types
To: David Howells <dhowells@redhat.com>
References: <1442842450-29769-1-git-send-email-a.hajda@samsung.com>
 <17571.1442842945@warthog.procyon.org.uk>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-kernel@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	devel@driverdev.osuosl.org, dev@openvswitch.org,
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
	linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-cachefs@redhat.com, linux-clk@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@linux-mips.org, linux-mm@kvack.org,
	linux-omap@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-serial@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	lustre-devel@lists.lustre.org, netdev@vger.kernel.org,
	rtc-linux@googlegroups.com
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <56011BB9.5030004@samsung.com>
Date: Tue, 22 Sep 2015 11:13:29 +0200
MIME-version: 1.0
In-reply-to: <17571.1442842945@warthog.procyon.org.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/21/2015 03:42 PM, David Howells wrote:
> Andrzej Hajda <a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
> 
>> Semantic patch finds comparisons of types:
>>     unsigned < 0
>>     unsigned >= 0
>> The former is always false, the latter is always true.
>> Such comparisons are useless, so theoretically they could be
>> safely removed, but their presence quite often indicates bugs.
> 
> Or someone has left them in because they don't matter and there's the
> possibility that the type being tested might be or become signed under some
> circumstances.  If the comparison is useless, I'd expect the compiler to just
> discard it - for such cases your patch is pointless.
> 
> If I have, for example:
> 
> 	unsigned x;
> 
> 	if (x == 0 || x > 27)
> 		give_a_range_error();
> 
> I will write this as:
> 
> 	unsigned x;
> 
> 	if (x <= 0 || x > 27)
> 		give_a_range_error();
> 
> because it that gives a way to handle x being changed to signed at some point
> in the future for no cost.  In which case, your changing the <= to an ==
> "because the < part of the case is useless" is arguably wrong.

This is why I have not checked for such cases - I have skipped checks of type
	unsigned <= 0
exactly for the reasons above.

However I have left two other checks as they seems to me more suspicious - they
are always true or false. But as Dmitry and Andrew pointed out Linus have quite
strong opinion against removing range checks in such cases as he finds it
clearer. I think it applies to patches 29-36. I am not sure about patches 26-28,37.

Regards
Andrzej

> 
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

