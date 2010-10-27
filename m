Return-path: <mchehab@pedra>
Received: from gateway07.websitewelcome.com ([67.18.81.23]:60778 "HELO
	gateway07.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752282Ab0J0JAL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 05:00:11 -0400
Received: from [209.85.216.46] (port=63879 helo=mail-qw0-f46.google.com)
	by gator1121.hostgator.com with esmtpsa (TLSv1:RC4-MD5:128)
	(Exim 4.69)
	(envelope-from <demiurg@femtolinux.com>)
	id 1PB1iD-0003pI-Oc
	for linux-media@vger.kernel.org; Wed, 27 Oct 2010 03:50:30 -0500
Received: by qwk3 with SMTP id 3so447863qwk.19
        for <linux-media@vger.kernel.org>; Wed, 27 Oct 2010 01:50:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <93671.67811.qm@web25407.mail.ukl.yahoo.com>
References: <AANLkTint2Xw3bJuGh2voUpncWderrbUgbeOaPdp1-yNm@mail.gmail.com>
	<201010242055.30799.albin.kauffmann@gmail.com>
	<AANLkTinwb_7ErteoWcO2VC1nu9uNqUwu6N+HEhrDwwg-@mail.gmail.com>
	<AANLkTinVas23b2ZMuBxzdY6PUP-4JEMchNup9nSpxsf3@mail.gmail.com>
	<130335.5569.qm@web25404.mail.ukl.yahoo.com>
	<AANLkTi=na1Rs6GmKzVUPZ9FrqVt8F-H-gi=JO0+7WW6K@mail.gmail.com>
	<575680.5975.qm@web25406.mail.ukl.yahoo.com>
	<AANLkTimf5Y6GybqDiEDdVo7OJ_f2X0Rxz1HxFEk7kHxj@mail.gmail.com>
	<AANLkTi=FtLUinJ_pmGK-Ygr=_ZOTZrcatXzg2zOq+LSz@mail.gmail.com>
	<355911.61281.qm@web25403.mail.ukl.yahoo.com>
	<AANLkTinJJkcQCBpD=3Q-ji+UOvXFmDrnDOgK+LZw1GEA@mail.gmail.com>
	<93671.67811.qm@web25407.mail.ukl.yahoo.com>
Date: Wed, 27 Oct 2010 10:50:26 +0200
Message-ID: <AANLkTi=fNmjiGfYhXCJtdCE_KWciT3hFU5RH2tbLL0iq@mail.gmail.com>
Subject: Re: Wintv-HVR-1120 woes
From: Sasha Sirotkin <demiurg@femtolinux.com>
To: fabio tirapelle <ftirapelle@yahoo.it>
Cc: Albin Kauffmann <albin.kauffmann@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Oct 26, 2010 at 9:07 PM, fabio tirapelle <ftirapelle@yahoo.it> wrote:
> I have tried again.
>
> rm -i dvb-fe-tda10048-1.0.fw
> cp dvb-fe-tda10046.fw dvb-fe-tda10048-1.0.fw
>
> Now shutdown and boot
>
> dmesg
>
> [   47.724011] tda18271: RF tracking filter calibration complete
> [   47.780018] tda829x 8-004b: type set to tda8290+18271
> [   52.756163] saa7133[0]: registered device video0 [v4l2]
> [   52.756260] saa7133[0]: registered device vbi0
> [   52.756312] saa7133[0]: registered device radio0
> [   52.774804] saa7134 ALSA driver for DMA sound loaded
> [   52.774818] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> [   52.774837] saa7133[0]/alsa: saa7133[0] at 0xfcfff800 irq 16 registered as
> card -2
> [   52.826225] dvb_init() allocating 1 frontend
> [   53.176016] tda829x 8-004b: type set to tda8290
> [   53.216128] tda18271 8-0060: attaching existing instance
> [   53.216133] DVB: registering new adapter (saa7133[0])
> [   53.216137] DVB: registering adapter 3 frontend 0 (NXP TDA10048HN DVB-T)...
> [   53.744012] tda10048_firmware_upload: waiting for firmware upload
> (dvb-fe-tda10048-1.0.fw)...
> [   53.744470] saa7134 0000:01:06.0: firmware: requesting dvb-fe-tda10048-1.0.fw
> [   53.789956] tda10048_firmware_upload: firmware read 24478 bytes.
> [   53.789959] tda10048_firmware_upload: firmware incorrect size
> [   53.789963] tda10048_firmware_upload: firmware upload failed
> [   55.240026] tda18271_read_regs: ERROR: i2c_transfer returned: -5
> [   55.852518] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer
> returned: -5
> [   55.852526] tda18271_set_analog_params: error -5 on line 1041
> [   91.004017] Clocksource tsc unstable (delta = -308694953 ns)
> [  810.460024] tda10048_firmware_upload: waiting for firmware upload
> (dvb-fe-tda10048-1.0.fw)...
> [  810.460039] saa7134 0000:01:06.0: firmware: requesting dvb-fe-tda10048-1.0.fw
> [  810.463999] tda10048_firmware_upload: firmware read 24478 bytes.
> [  810.464081] tda10048_firmware_upload: firmware incorrect size
> [  810.464091] tda10048_firmware_upload: firmware upload failed
>
>
> now my WinTv-1120 works

When you say works, what exactly do you mean? Can you try to run w_scan ?

>
>
>
> ----- Messaggio originale -----
>> Da: Sasha Sirotkin <demiurg@femtolinux.com>
>> A: fabio tirapelle <ftirapelle@yahoo.it>
>> Cc: Albin Kauffmann <albin.kauffmann@gmail.com>; linux-media@vger.kernel.org
>> Inviato: Lun 25 ottobre 2010, 18:39:59
>> Oggetto: Re: Wintv-HVR-1120 woes
>>
>> On Mon, Oct 25, 2010 at 1:51 PM, fabio tirapelle <ftirapelle@yahoo.it>  wrote:
>> >
>> >
>> >> Da: Albin Kauffmann <albin.kauffmann@gmail.com>
>> >>  A: Sasha Sirotkin <demiurg@femtolinux.com>
>> >>  Cc: fabio tirapelle <ftirapelle@yahoo.it>; linux-media@vger.kernel.org
>> >>  Inviato: Lun 25 ottobre 2010, 13:20:13
>> >> Oggetto: Re: Wintv-HVR-1120  woes
>> >>
>> >> On Mon, Oct 25, 2010 at 9:46 AM, Sasha Sirotkin  <demiurg@femtolinux.com>
>> >>wrote:
>> >>  > On Mon, Oct 25, 2010 at 9:24 AM, fabio tirapelle <ftirapelle@yahoo.it>
>> >>wrote:
>> >>  >>
>> >> >>
>> >> >>> Da: Sasha Sirotkin  <demiurg@femtolinux.com>
>> >>  >>>  A: fabio tirapelle <ftirapelle@yahoo.it>
>> >>  >>>  Cc: Albin Kauffmann <albin.kauffmann@gmail.com>;
>> >>linux-media@vger.kernel.org
>> >>  >>>  Inviato: Lun 25 ottobre 2010, 09:18:28
>> >> >>>  Oggetto: Re:  Wintv-HVR-1120 woes
>> >> >>>
>> >>  >>> On Mon, Oct 25, 2010 at 8:16  AM, fabio tirapelle
> <ftirapelle@yahoo.it>
>> >>wrote:
>> >>  >>> > My  WinTV-HVR-1120 works if I delete  dvb-fe-tda10048-1.0.fw  and
>> >> >>> > rename  dvb-fe-tda10046.fw in   dvb-fe-tda10048-1.0.fw
>> >> >>> > (see cf "Hauppauge    WinTV-HVR-1120  on Unbuntu 10.04" thread).
>> >> >>> > After  reboot my  WinTV-HVR-1120  works. Ubuntu recognizes that  the
>> >>firmware
>> >> >>>isn't
>> >> >>>   > correct  and doesn't load the firmware.
>> >>  >>>
>> >> >>> How  come it works without the firmware !?   Is it possible that you
>> >> >>>  booted into Windows before  that and there is a  correct firmware
>> >> >>>  already running  in the card ?
>> >> >>
>> >> >> No my mediacenter works   only on Ubuntu
>> >> >
>> >> > This is weird. I will try this  workaround  tonight.
>> >>
>> >> Actually, I think that the  dvb-fe-tda10048-1.0.fw firmware is  still
>> >> loaded in the TV card and  that this scenario has not changed  anything.
>> >>
>> >> Fabio,  have you tried to reboot several times in order to see  if the
>> >>  problem is really fixed?
>> >> And are you still getting some ERROR   messages in `dmesg`? If not, this
>> >> is good but I don't understand   :)
>> >
>> > Yes, if "several times" means 3 times. But I think this  isn't a good
>>practice.
>> > So I have bought another card (NOVA-T-Stick) and  I wait for a real
> solution.
>> >
>> > As I have written, the WinTV-1120  did work correctly with Ubunt 9.10. I
>>haven't
>> > had problems with this  version of Ubuntu. But the linux-firmware-nonfree
>>package
>> >
>> > for  Ubuntu 9.10 (karmic) didn't contain the dvb-fe-tda10048-1.0.fw
>> > (see http://packages.ubuntu.com/karmic/all/linux-firmware-nonfree/filelist)
>> >  The dvb-fe-tda10048-1.0.fw was introduced with lucid
>> > (see http://packages.ubuntu.com/lucid/all/linux-firmware-nonfree/filelist).
>> >  And now the question. Why without dvb-fe-tda10048-1.0.fw I haven't had
>>problems
>> > and now with Ubuntu 10.04 I have problem exactly with this  firmware?
>> >
>> > So I have renamed the dvb-fe-tda10046.fw in   dvb-fe-tda10048-1.0.fw but
>> > I have seen that Ubuntu checks if the  firmware is consistent.
>>
>> I did the same and it did not help me much - I  get the same errors and
>> DVB scan does not work.
>>
>> >
>> > In the  next two days I cannot post my dmesg, as I cannot access to my
>> >  mediacenter. Tuesday night I will post it.
>> >
>> > What you think about  my consideration about Ubuntu 9.10 and  10.04?
>> >
>> >
>> >>
>> >> Cheers,
>> >>
>> >>  --
>> >> Albin Kauffmann
>> >>
>> >
>> >
>> >
>> >
>>
>
>
>
>
