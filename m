Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ysangkok@gmail.com>) id 1JjGet-0003sN-KY
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 18:26:58 +0200
Received: by nf-out-0910.google.com with SMTP id d21so865711nfb.11
	for <linux-dvb@linuxtv.org>; Tue, 08 Apr 2008 09:26:52 -0700 (PDT)
Message-ID: <15a344380804080926q2336343bsa5dddff401c3647e@mail.gmail.com>
Date: Tue, 8 Apr 2008 18:26:51 +0200
From: Ysangkok <ysangkok@gmail.com>
To: "Benoit Paquin" <benoitpaquindk@gmail.com>
In-Reply-To: <47FA6C32.4060100@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <7dd90a210804071143j704ea174tb81c06cda02ab8b7@mail.gmail.com>
	<47FA6C32.4060100@iki.fi>
Cc: Antti Palosaari <crope@iki.fi>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Sandberg dvb-t stick now working with your latest
	version
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

Hello people,

It works!

[ 2515.625003] usb 1-4: new high speed USB device using ehci_hcd and address 7
[ 2515.762432] usb 1-4: configuration #1 chosen from 1 choice
[ 2515.762854] af9015_usb_probe: interface:0
[ 2515.763154] af9015_identify_state: reply:02
[ 2515.763159] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in
warm state.
[ 2515.763235] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[ 2515.763561] DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 stick)
[ 2515.763932] af9015_eeprom_dump:
[ 2515.787389] 00: 2c 47 97 0b 00 00 00 00 a4 15 16 90 00 02 01 02
[ 2515.809721] 10: 03 80 00 fa fa 10 40 ef 01 30 31 30 31 30 38 32
[ 2515.831951] 20: 30 30 37 30 30 32 42 43 ff ff ff ff ff ff ff ff
[ 2515.854813] 30: 00 00 3a 01 00 08 02 00 1d 8d c4 04 82 ff ff ff
[ 2515.877532] 40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
[ 2515.900010] 50: ff ff ff ff ff 24 00 00 04 03 09 04 10 03 41 00
[ 2515.922493] 60: 66 00 61 00 74 00 65 00 63 00 68 00 0c 03 44 00
[ 2515.944449] 70: 56 00 42 00 2d 00 54 00 20 03 30 00 31 00 30 00
[ 2515.966674] 80: 31 00 30 00 31 00 30 00 31 00 30 00 36 00 30 00
[ 2515.988649] 90: 30 00 30 00 30 00 31 00 00 ff ff ff ff ff ff ff
[ 2516.010645] a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 2516.032603] b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 2516.054705] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 2516.076805] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 2516.098905] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 2516.120881] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 2516.122259] af9015_read_config: xtal:2 set adc_clock:28000
[ 2516.125003] af9015_read_config: IF1:36125
[ 2516.127750] af9015_read_config: MT2060 IF1:1220
[ 2516.129132] af9015_read_config: tuner id1:130
[ 2516.130499] af9015_read_config: spectral inversion:0
[ 2516.147737] af9013: firmware version:4.95.0
[ 2516.147760] DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
[ 2516.147861] af9015_tuner_attach:
[ 2516.147866] af9015_set_gpio: gpio:3 gpioval:03
[ 2516.169484] MT2060: successfully identified (IF1 = 1220)
[ 2516.635455] dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully
initialized and connected.
[ 2516.635464] af9015_init:
[ 2516.635467] af9015_init_endpoint: USB speed:3
[ 2516.639572] af9015_download_ir_table:
[ 2516.689738] input: Afatech DVB-T as /class/input/input10
[ 2516.689930] input: USB HID v1.01 Keyboard [Afatech DVB-T] on
usb-0000:00:10.4-4
[ 2559.501813] af9015_pid_filter_ctrl: onoff:0


My Hauppauge WinTV Nova-T USB2 stick does still not work, but I am
pretty happy though. I finally got something to work. :P

Regards,
Janus

On Mon, Apr 7, 2008 at 8:47 PM, Antti Palosaari <crope@iki.fi> wrote:
> thanx for feedback
>  I am just working for PID-filter support (USB1.1 support) and hope that in
> few hours it is ready. This is first time I am adding PID-filter so it is
> little bit learning also.
>
>  /antti
>
>
>
>  Benoit Paquin wrote:
>
> > Antti,
> >
> > You new driver is working! I can not copy the linux-dvb list as I am not a
> member yet (I need to enroll).
> > Good work!
> > If you want me to test a USB 1.1 version, I will be glad to do so. I have
> a neat Lex-light machine (no fan, Via C3 cpu) running Ubuntu!
> >
> > Thanks,
> > Benoit
> >
> > Janus: Can you check the new driver if you have time? I did:
> > hg clone http://linuxtv.org/hg/~anttip/af9015/
> > cd af9015
> > make
> > sudo make install
> > (add the line dvb-usb-af9015 in /etc/modules)
> > reboot
> > plug stick
> > check dmesg
> >
> > If you are in Copenhagen, Kanal-Kbh has a strong signal that the mini
> antenna can take:
> > dvbstream -f 586000 -o -ps 4001 4002 >test.mpg
> > mplayer test.mpg
> >
> >
>
>
>  --
>  http://palosaari.fi/
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
