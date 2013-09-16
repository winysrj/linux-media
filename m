Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.61]:46156 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3IPTN7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Sep 2013 15:13:59 -0400
Message-ID: <52375871.8040004@sca-uk.com>
Date: Mon, 16 Sep 2013 16:13:53 -0300
From: Steve Cookson <it@sca-uk.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppauge ImpactVCB-e 01381 PCIe driver resolution.
References: <5235CED8.3080804@sca-uk.com> <CAGoCfiyuvXAhBS=n=_3bZKnCSTZYMrHFJ73MfRnoiuW44Y=zKg@mail.gmail.com> <52363EA6.7060402@sca-uk.com> <CAGoCfix7r_bp7w-6HyXYz_XOZz-zFk_SLUzA6-Br6Z-LLsTy-g@mail.gmail.com>
In-Reply-To: <CAGoCfix7r_bp7w-6HyXYz_XOZz-zFk_SLUzA6-Br6Z-LLsTy-g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/09/2013 14:38, Devin Heitmueller wrote:

 >
 > I'm not sure what other cards you've tried.  Nowadays they should all
 > deliverable comparable performance for s-video (since no chroma
 > separation is involved), if they don't then it's almost certainly a
 > Linux driver bug.
 >
 > If you have a commercial need for the device to work, we can discuss
 > offlist doing some consulting to resolve the issue.  However if not
 > then you're pretty much at the mercy of the community in terms of the
 > state of quality/support.

Well I'm not sure whether I have a commercial need yet.

What I really want is a fast, analogue RGBS 480i & 1080i capture card.

Maybe like the Epiphan VGA2USB LR (internal version), but it is sooo
expensive.

For 25% of the price I can get a Blackmagic Design Intensity Pro, but
it only does YPbPr 1080i and the decklinksrc gstreamer module is a
bit ropey.  Actually very ropey.  But it also accepts s-video.

So then I fall back on the old tried and tested s-video stuff.  I have to
accept 480i but I can still have a fast response.  Dazzle is about 100
msecs but some others, like the old ImpactVCB pci card with
3 av ports and an s-video port, has worse quality video than the Dazzle
and is slower.  I've tested another couple of PCI cards but they are all
very slow and poor video quality.

The one I'd really like, at about $100 on Amazon, is the Startech
VGA capture card, I could put a synch splitter/inverter in front of it, for
say $25, to convert RGB3 1080i to VGA HD1080.  It runs like a dream
with a fast response.  It's Linux compatible as far as I can see, that
is to say lspci should say something if you plug it in, but there is no
driver for it.  The one I saw, which was not the Startech one but a
similar one from Kato vision, was PCIe, with onboard h.264
hardware compression and a direct memory access module.  It
just screamed through that video signal.  I wasn't able to do any timer 
tests
on it, but I would guess much faster than the dazzle.  Maybe 50 msecs
latency.

Regards

Steve

 >
 > Devin
 >

