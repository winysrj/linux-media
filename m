Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KZUPY-0001qG-UG
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 19:38:57 +0200
Message-ID: <48B985A0.7040704@gmail.com>
Date: Sat, 30 Aug 2008 21:38:40 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Sverker Abrahamsson <sverker@abrahamsson.com>
References: <483940C30C8D406C93CF3978F5371313@shrek>
In-Reply-To: <483940C30C8D406C93CF3978F5371313@shrek>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Mantis status? VP3030 questions
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

Sverker Abrahamsson wrote:
> Hi,
> what is the current status of the Mantis driver (Manu Abrahams tree)? Does it work stable with any card?
> 
> I've been trying to make it work for the Twinhan VP3030 DVB-T card but I see that the part that enables the frontend was disabled. I've enabled it and made the neccesary API changes to make it compile (such as using dvb_attach instead of calling directly to the specific frontend attach). The frontend is a ZL10353 (it is now called CE6353 after being aquired by Intel) which is supported on other cards.
> 
> In the zl10353_attach routine I see that it's trying to read CHIP_ID from i2c device 0x0f but I'm getting undefined results. Yesterday it was 0xfd, today it has been 0x00. Not 0x14 as it should be.
> 
> The only reason I can see for that is that the chip has not been reset properly. The sequence for initializing the frontend is to first power it up by setting gpio bit 0x0c on mantis to 1, then reset it by writing first 0 to gpio bit 13 for 200 ms, then 1.
> 
> One potential scenario is that the reset pin is not connected to gpio pin 13 on this board but has some other wiring, other than that I don't know what to look for.

I had the same card, also the same mentioned issue. I figured probably
it could be a hardware related issue. Maybe it is time that i check the
card again.

> 
> I tested to comment out the check for CARD_ID, then the frontend is established and it finds the tuner correctly on i2c address 0x60 but it does not work to scann, get tuning failed on all frequencies.
> 

The issue what i guess is that the frontend is not RESET or powered up.

Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
