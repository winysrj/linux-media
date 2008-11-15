Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1L1LH5-0006Do-9i
	for linux-dvb@linuxtv.org; Sat, 15 Nov 2008 14:33:20 +0100
Message-ID: <491ECF8B.6060009@iki.fi>
Date: Sat, 15 Nov 2008 15:32:59 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Rasjid Wilcox <rasjidw@gmail.com>
References: <bf82ea70811110306v345c9061sc6d49f6a961647c@mail.gmail.com>	<bf82ea70811110312y487610d8v9656c3e76bf44e0@mail.gmail.com>	<49199510.6040809@iki.fi>
	<bf82ea70811150303p4d6517b2qce1345dd707a315c@mail.gmail.com>
In-Reply-To: <bf82ea70811150303p4d6517b2qce1345dd707a315c@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DigitalNow TinyTwin second tuner support
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

Rasjid Wilcox wrote:
> 2008/11/12 Antti Palosaari <crope@iki.fi>:
>> I disabled 2nd tuner by default due to bad performance I faced up with my
>> hardware. Anyhow, you can enable it by module param, use modprobe
>> dvb-usb-af9015 dual_mode=1 . Test it and please report.
> 
> I have enabled dual mode, and now have an extra adaptor in /dev/dvb.
> 
> However, when I try to set the new card up in the Myth backend in
> Capture Card Setup, I get an error on the Frontend ID: "Could not get
> card info for the card #1", and for Subtype: Unknown error.
> 
> dmesg also has an error message:
> 
> af9015: firmware copy to 2nd frontend failed, will disable it
> 
> Any suggestions?

Did you re-plug stick?

> 
> Cheers,
> 
> Rasjid.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
