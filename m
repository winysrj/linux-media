Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+d24d3df50d55a41ea5c9+1915+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1L2xY2-0000Bo-SH
	for linux-dvb@linuxtv.org; Thu, 20 Nov 2008 01:37:31 +0100
Date: Wed, 19 Nov 2008 22:37:18 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
Message-ID: <20081119223718.7376c533@pedra.chehab.org>
In-Reply-To: <412bdbff0811191411n3353be1fx963d8571fba47ad1@mail.gmail.com>
References: <412bdbff0811191324y67b965fcpdf57ef09bb18208c@mail.gmail.com>
	<20081119193749.49f654c9@pedra.chehab.org>
	<412bdbff0811191411n3353be1fx963d8571fba47ad1@mail.gmail.com>
Mime-Version: 1.0
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] em28xx "card=" argument
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

On Wed, 19 Nov 2008 17:11:16 -0500
"Devin Heitmueller" <devin.heitmueller@gmail.com> wrote:

> On Wed, Nov 19, 2008 at 4:37 PM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> >> What do you think about removing the "card=" module option from
> >> em28xx?  Users who don't know any better might be inclined to try the
> >> various cards in the list and could burn out their hardware if they
> >> select a card with the wrong GPIOs.
> >>
> >> I can submit a patch that takes it out.  Let me know what you think.
> >
> > nack. This option is needed, since some cards can't be auto-detected. For
> > example, that device with ALC655 is a capture only device that doesn't have any
> > eeprom. Also, the autodetect hints think it is an Oral Camera. So, it uses the
> > "generic id". Of course, the generic entry doesn't work for it.
> 
> Also, could you send me the dmesg output for the card in question
> without the "card=" argument, so I can see the eeprom contents and
> various computed hashes.

I'll send you when I get it again. It is a borrowed board. Thanks to that
board, I discovered that the driver were broken on devices without eeprom
(9627:f3128f8e3475) when working on this board.


Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
