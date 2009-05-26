Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:32210 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202AbZEZTEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 15:04:30 -0400
Received: by qw-out-2122.google.com with SMTP id 5so2583472qwd.37
        for <linux-media@vger.kernel.org>; Tue, 26 May 2009 12:04:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197380905261145u4a55a82bt309225ef0cb784f1@mail.gmail.com>
References: <B2D200D8-22B0-418C-B577-C036C1469521@gmail.com>
	 <303162d70904301855xd138162s43c550637436919a@mail.gmail.com>
	 <5B379A59-CAE7-4D20-8570-E3F2D6AB9623@gmail.com>
	 <412bdbff0904302216q4ffbdf24yb5d73956addfb8f6@mail.gmail.com>
	 <303162d70905012017x2f6a2ae7n4600ecb5bb26be89@mail.gmail.com>
	 <412bdbff0905221951l2a1dd0d5k28fe0bf8622d6461@mail.gmail.com>
	 <303162d70905251503oa18abeen7a65231125ee1ca8@mail.gmail.com>
	 <412bdbff0905251727v6d5dc6c7y72d497b302d3c032@mail.gmail.com>
	 <de1a653d0905261135u50ef4587ia6631798bd6134d5@mail.gmail.com>
	 <829197380905261145u4a55a82bt309225ef0cb784f1@mail.gmail.com>
Date: Tue, 26 May 2009 14:04:30 -0500
Message-ID: <de1a653d0905261204v46d4827dk15582985c1d32408@mail.gmail.com>
Subject: Re: [PATCH] Add QAM64 support for hvr-950q (au8522)
From: Tim Mester <ttmesterr@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Frank Dischner <phaedrus961@googlemail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 26, 2009 at 1:45 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Tue, May 26, 2009 at 2:35 PM, Tim Mester <ttmesterr@gmail.com> wrote:
>> From my experience it seems that 2 in 0x2005 resets the 8522 demod.
>> All demod register setting appear to be lost after accessing any
>> registers in the 0x2xxx range (you really, just that bit needs to be
>> set on a i2c bus access).  I am a little surprised that 0x2000 is not
>> written to the bus to for each modulation mode.
>
> Hmmm...  I would have to look closer before I could comment
> intelligently.  Resetting all the registers could be a bad idea if
> there are registers being programmed that are not in the modulation
> block (initialization parameters such as the IF setting).
>
> Devin

Yep.  Setting that rest will definitely clear out the IF registers
settings.  It would need to be one the first things done before
setting any other of the 8522 registers. (Which it almost is for VSB
right now).


  Tim
