Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.157])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KZEI1-0007A9-DU
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 02:26:06 +0200
Received: by fg-out-1718.google.com with SMTP id e21so674765fga.25
	for <linux-dvb@linuxtv.org>; Fri, 29 Aug 2008 17:26:02 -0700 (PDT)
Message-ID: <37219a840808291726y2f1ac6bke557c316115711c0@mail.gmail.com>
Date: Fri, 29 Aug 2008 20:26:02 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Dustin Coates" <dcoates@systemoverload.net>
In-Reply-To: <48B87FF5.9020606@systemoverload.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <e32e0e5d0808291401x39932ab6q6086882e81547f84@mail.gmail.com>
	<37219a840808291514o76704d60t63986edf391e699f@mail.gmail.com>
	<48B87FF5.9020606@systemoverload.net>
Cc: Tim Lucas <lucastim@gmail.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] cx23885 analog TV and audio support for
	HVR-1500
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Fri, Aug 29, 2008 at 7:02 PM, Dustin Coates
<dcoates@systemoverload.net> wrote:
>>>>>>
>>>>>> Steven Toth wrote:
>>>>>>
>>>>>>> http://linuxtv.org/hg/~stoth/cx23885-audio
>>>>>>>
>>>>>>> This tree contains your patch with some minor whitespace cleanups
>>>>>>> and fixes for HUNK related merge issues due to the patch wrapping at
>>>>>>> 80 cols.
>>>>>>>
>>>>>>> Please build this tree and retest in your environment to ensure I
>>>>>>> did not break anything. Does this tree still work OK for you?
>
> Could this help with the HVR-1800 Also?


Yes, this can help us to enable the DMA Audio on the HVR-1800.  Analog
video already works on the HVR1800, both raw video and hardware mpeg
encode, but audio during raw video (ie: tvtime) support was missing.

There are some differences between the cx23885 and the cx23887, but
this all does help a lot.

Give it some time, we'll get all the cx23885 cards tested and check
the '887s also.

There are a lot of big changes happening right now all at once,
especially if you look at today's mailing list traffic.

I can't promise that everything will get completed immediately, but
now everybody can see what's in progress :-)

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
