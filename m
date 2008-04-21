Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1Jnvvs-0002EO-7Q
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 15:19:45 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Amitay Isaacs <amitay@gmail.com>
In-Reply-To: <75a6c8000804210142h46304ce0w126f465bef458a0f@mail.gmail.com>
References: <919241.88594.qm@web55605.mail.re4.yahoo.com>
	<75a6c8000804210142h46304ce0w126f465bef458a0f@mail.gmail.com>
Date: Mon, 21 Apr 2008 15:19:22 +0200
Message-Id: <1208783962.3294.23.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR1200 / HVR1700 / TDA10048 support
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

Hi,

Am Montag, den 21.04.2008, 18:42 +1000 schrieb Amitay Isaacs:
> Hi Trevor,
> 
> I have the skeleton driver code ready. The driver calls
> tda10048_attach() and I am 
> getting tda10048_readreg error (ret == -5). I need to find the
> demodulator I2C address
> for TDA10048 on DTV1000S board. 
> 
> Is there any way to find out the demod_address?
> 
> Amitay.

tuner as in the logs 0xc0/0x60 and digital demod 0x10 >> 1 or 0x08.
You can try to verify it with the saa7134 i2c_scan=1 option.

It seems not to have an analog demodulator, so you would use tuner type
4, TUNER_ABSENT for the entry in saa7134-cards.c. You can also add it to
auto detection there as a saa7130 device and also add the card in
saa7134.h, but you seem to have this all already.

Cheers,
Hermann

> On Mon, Apr 21, 2008 at 3:54 PM, Trevor Boon <trevor_boon@yahoo.com>
> wrote:
>         Hi Amitay,
>         
>         Although, this is just speculation, the pcb label is
>         lr6655 which, afaik, is a Lifeview model code?
>         
>         I've had a look at the driver inf file (lr6655.inf)
>         and can only see three files being used:
>         
>         3xHybrid.sys
>         NXPMV32.dll
>         (34CoInstaller.dll) is remarked out in the lr6655.inf
>         
>         I can also see 'Proteus' reference board being listed
>         in the driver .inf file. Does this help?
>         



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
