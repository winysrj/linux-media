Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nA8Mej92005681
	for <video4linux-list@redhat.com>; Sun, 8 Nov 2009 17:40:45 -0500
Received: from mail-in-04.arcor-online.net (mail-in-04.arcor-online.net
	[151.189.21.44])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nA8Meic2012192
	for <video4linux-list@redhat.com>; Sun, 8 Nov 2009 17:40:44 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Pavle Predic <pavle.predic@yahoo.co.uk>
In-Reply-To: <163605.48700.qm@web28403.mail.ukl.yahoo.com>
References: <163605.48700.qm@web28403.mail.ukl.yahoo.com>
Content-Type: text/plain
Date: Sun, 08 Nov 2009 23:35:08 +0100
Message-Id: <1257719708.3249.27.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Leadtek Winfast TV2100
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Pavle,

Am Sonntag, den 08.11.2009, 17:11 +0000 schrieb Pavle Predic:
> Did anyone manage to get this card working on Linux? I got the picture out of the box, but it's impossible to get any sound from the damned thing. The card is not on CARDLIST.saa7134, but I assume a similar card/tuner combination can be used. But which? By the way, I got the speakers connected directly to card output, I'm not even trying to get it working with my sound card. I can hear clicks when loading/unloading modules, so it's alive but not set up properly.
> 
> Any info would be greatly appreciated. Perhaps someone knows of another card that is similar to this one?
> 
> Card info:
> Chipset: saa7134
> Tuner: Tvision TVF88T5-B/DFF
> Card numbers that produce picture (modprobe saa7134 card=$n): 3, 7, 10, 16, 34, 35, 45, 46, 47, 48, 51, 63, 64, 68

that is not enough information yet.

The correct tuner for this one is tuner=69.

Only with this one you will have also radio support.

Since you mail from an UK mail provider, this tuner is not expected to
work with PAL-I TV stereo sound there, but radio would work.

Else, if neither amux = TV nor amux = LINE1 or LINE2 (LINE inputs for TV
sound are only found on saa7130 chips, except there is also an extra TV
mono section directly from the tuner)  work for TV sound, most often an
external audio mux is in the way and needs to be configured correctly
with saa7134 gpio pins. Looking also at the minor chips on the card with
more than 3 pins can reveal such a mux.

There is also a software test on such hardware, succeeding in most
cases.

By default, external analog audio input is looped through to analog
audio out, on which you are listening, if the driver is unloaded.

On a saa7134 chip, on saa7130 are some known specials, you should hear
the incoming sound directly on your headphones or what else you might be
using directly connected to your card, trying on LINE1 and LINE2 for
that.

If not, you can expect that such a mux chip needs to be treated
correctly.

The DScaler (deinterlace.sf.net) regspy.exe often can help to identify
such gpios in use, else you must trace lines and resistors on it.

In general, an absolute minimum is to provide related "dmesg" after
loading the driver _without_ having tried on other cards previously.

Please read more on the linuxtv.org wiki about adding support for a new
card.

Cheers,
Hermann






--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
