Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51308 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab0HEXtn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Aug 2010 19:49:43 -0400
Received: by iwn33 with SMTP id 33so625365iwn.19
        for <linux-media@vger.kernel.org>; Thu, 05 Aug 2010 16:49:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1280843299.1492.127.camel@gagarin>
References: <AANLkTimD-BCmN+3YUykUCH0fdNagw=wcUu1g+Z87N_5W@mail.gmail.com>
	<1280741544.1361.17.camel@gagarin>
	<AANLkTinHK8mVwrCnOZTUMsHVGTykj8bNdkKwcbMQ8LK_@mail.gmail.com>
	<AANLkTi=M2wVY3vL8nGBg-YqUtRidBahpE5OXbjr5k96X@mail.gmail.com>
	<1280750394.1361.87.camel@gagarin>
	<AANLkTi=V3eKuJ1jXPcBuSxUy6djCoK4q2pR-V0zo_cMS@mail.gmail.com>
	<1280843299.1492.127.camel@gagarin>
Date: Fri, 6 Aug 2010 11:49:41 +1200
Message-ID: <AANLkTik0UZmf5b4nTi1AgFiKQAGkvU47_dN0gUSw3urs@mail.gmail.com>
Subject: Re: Fwd: No audio in HW Compressed MPEG2 container on HVR-1300
From: Shane Harrison <shane.harrison@paragon.co.nz>
To: lawrence rust <lawrence@softsystem.co.uk>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 4, 2010 at 1:48 AM, lawrence rust <lawrence@softsystem.co.uk> wrote:
[snip}
>>
>> Still to try the patch - will let you know.  Unfortunately our
>> HVR-1300 is in the process of being swapped out since the supplier
>> wanted to try swapping boards first :-(
>
> Let us know how you get on.
>
> -- Lawrence Rust

Well still no luck this end.  Have done the following:
1) Swapped boards - no change
2) Applied the patch - no change (we were detecting the WM8775 OK
anyway and the other changes were either non HVR-1300 or we had
already tried them so probably not too surprising
3) Made sure I2SINPUT is enabled - no change

So still have the following strange observations:
1) Repeatedly swapping between inputs eventually gives us audio
2) Once fixed it survives a warm reboot but not power cycle
3) Putting a scope on the I2S line out of the CX2388x shows noise when
TV input selected and no noise for Composite (unless inject a tone).
However MPEG-2 audio always contains hiss or hiss plus injected tone.

So looks like two issues to me.  I'll try and modify the driver so
that when switching inputs we only config the WM8775 or the CX2388x or
the MPEG encoder and see if I can determine which item has the
configuration issue.

Cheers
Shane
