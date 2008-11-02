Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA21BtsL010777
	for <video4linux-list@redhat.com>; Sat, 1 Nov 2008 21:11:55 -0400
Received: from mail-in-14.arcor-online.net (mail-in-14.arcor-online.net
	[151.189.21.54])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA21Be7U010653
	for <video4linux-list@redhat.com>; Sat, 1 Nov 2008 21:11:40 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: =?ISO-8859-1?Q?M=E1rcio?= Pedroso <sarrafocapoeira@gmail.com>
In-Reply-To: <c931de3d0810291317h742a2f28i9e44400f80abf624@mail.gmail.com>
References: <c931de3d0810291317h742a2f28i9e44400f80abf624@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Sun, 02 Nov 2008 02:11:09 +0100
Message-Id: <1225588269.2642.21.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: card =?iso-8859-1?q?n=BA?= for AOP V8001 philips
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

Hi Marcio,

Am Mittwoch, den 29.10.2008, 18:17 -0200 schrieb Márcio Pedroso:
> I am struggling to find the number of cards referring to this card any tips
> 
> 00:13.0 Multimedia controller: Philips Semiconductors SAA7130 Video
> Broadcast Decoder (rev 01)
> 
> chipset saa7130hl

we have lots of saa7130 cards, which are clones of previously known
ones, but they also often have no eeprom with specific PCI subvendor and
subdevice IDs stored there and can't be identified.

The absolute minimum is to provide relevant "dmesg" output on loading
the driver and setting the tuner type.

See also here.
http://linuxtv.org/v4lwiki/index.php/Development:_How_to_add_support_for_a_device

Just saa7130 and AOP V8001 Philips means nothing so far.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
