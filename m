Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+f7e041a6cf3ae700ba84+1914+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1L2ukL-0004BL-Jy
	for linux-dvb@linuxtv.org; Wed, 19 Nov 2008 22:38:01 +0100
Date: Wed, 19 Nov 2008 19:37:49 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
Message-ID: <20081119193749.49f654c9@pedra.chehab.org>
In-Reply-To: <412bdbff0811191324y67b965fcpdf57ef09bb18208c@mail.gmail.com>
References: <412bdbff0811191324y67b965fcpdf57ef09bb18208c@mail.gmail.com>
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

On Wed, 19 Nov 2008 16:24:44 -0500
"Devin Heitmueller" <devin.heitmueller@gmail.com> wrote:

> Mauro,
> 
> What do you think about removing the "card=" module option from
> em28xx?  Users who don't know any better might be inclined to try the
> various cards in the list and could burn out their hardware if they
> select a card with the wrong GPIOs.
> 
> I can submit a patch that takes it out.  Let me know what you think.

nack. This option is needed, since some cards can't be auto-detected. For
example, that device with ALC655 is a capture only device that doesn't have any
eeprom. Also, the autodetect hints think it is an Oral Camera. So, it uses the
"generic id". Of course, the generic entry doesn't work for it.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
