Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f20.google.com ([209.85.217.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sparkmaul@gmail.com>) id 1KT6OZ-0001f1-Jr
	for linux-dvb@linuxtv.org; Wed, 13 Aug 2008 04:47:32 +0200
Received: by gxk13 with SMTP id 13so1076274gxk.17
	for <linux-dvb@linuxtv.org>; Tue, 12 Aug 2008 19:46:57 -0700 (PDT)
Message-ID: <8e5b27790808121946j28c2d3e9m8711fe7ff509eafa@mail.gmail.com>
Date: Tue, 12 Aug 2008 19:46:57 -0700
From: "Paul Marks" <paul@pmarks.net>
To: "oobe trouble" <oobe.trouble@gmail.com>, linux-dvb@linuxtv.org
In-Reply-To: <21aab41d0808121711i3b59de00hfb914f7987a930f0@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <8e5b27790808120058o52c4c6bcw21152364b2613c39@mail.gmail.com>
	<21aab41d0808121711i3b59de00hfb914f7987a930f0@mail.gmail.com>
Subject: Re: [linux-dvb] FusionHDTV5 IR not working.
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

On Tue, Aug 12, 2008 at 5:11 PM, oobe trouble <oobe.trouble@gmail.com> wrote:
> you can try
>
> dmesg | grep IR
>
> you should see and out put like this " input: IR-receiver inside an USB DVB
> receiver as /class/input/input5"
> the remote should appear somewhere in /dev/input if it is working

Nope.  The only "IR"s in my dmesg are about IRQs.  Plus, my card is
PCI, not USB.

Does anyone know the difference between
drivers/media/video/cx88/cx88-input.c and
drivers/media/video/ir-kbd-i2c.c ?

cx88-input.c has a cx88_ir_init function, which contains a switch
statement that does not include my board.  I could add
CX88_BOARD_DVICO_FUSIONHDTV_5_GOLD to it, but I've got no clue which
parameters to configure the IR port with, if it's even available
through GPIO at all.

As for ir-kbd-i2c.c, the changelist which appeared to be for my card
claims that there should be an IR port on i2c at address 0x6b.
Nothing's detected for me though.  Is it possible that my IR port
could be at another i2c address?  How could I ever know which one it
is?

Does documentation exist for this card, or are you guys just good at
reverse engineering?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
