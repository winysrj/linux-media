Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp125.rog.mail.re2.yahoo.com ([206.190.53.30])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <cityk@rogers.com>) id 1L4Kp3-00054s-Hw
	for linux-dvb@linuxtv.org; Sun, 23 Nov 2008 20:40:47 +0100
Message-ID: <4929B192.8050707@rogers.com>
Date: Sun, 23 Nov 2008 14:40:02 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
References: <49287DCC.9040004@gmail.com>
	<37219a840811231121u1350bf61n57109a1600f6dd92@mail.gmail.com>
In-Reply-To: <37219a840811231121u1350bf61n57109a1600f6dd92@mail.gmail.com>
Cc: Bob Cunningham <FlyMyPG@gmail.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] AnyTV AUTV002 USB ATSC/QAM Tuner Stick
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

Michael Krufky wrote:
> On Sat, Nov 22, 2008 at 4:46 PM, Bob Cunningham <FlyMyPG@gmail.com> wrote:
>   
>> Hi,
>>
>> I just bought an AnyTV AUTV002 USB Tuner Stick from DealExtreme.  When plugged in, lsusb provides the following:
>>
>>   Bus 001 Device 011: ID 05e1:0400 Syntek Semiconductor Co., Ltd
>>
>> A quick search revealed that the au0828 driver ....
>>     
>
> Bob,
>
> A patch was submitted that adds support for a device with usb ID
> 05e1:0400, but it did not get merged yet.
>
> The reason why I didn't merge the patch yet, is that there are
> multiple devices out there using this USB id but they have different
> internal components and no way to differentiate between the two.
>
> If you can open up your stick and tell us what is printed on each
> chip, then I can help you get yours working.

Likely (as mentioned in the related discussion/thread:
http://marc.info/?l=linux-dvb&m=122472907625204&w=2):

- Microtune MT213x (tuner)
- Auvitek AU850x (demod)
- Auvitek AU0828 (usb)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
