Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <FlyMyPG@gmail.com>) id 1L4RI3-0007t3-9l
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 03:35:08 +0100
Received: from cpe-24-165-6-130.san.res.rr.com ([24.165.6.130])
	by cdptpa-omta04.mail.rr.com with ESMTP id
	<20081124023433.UWNB24754.cdptpa-omta04.mail.rr.com@cpe-24-165-6-130.san.res.rr.com>
	for <linux-dvb@linuxtv.org>; Mon, 24 Nov 2008 02:34:33 +0000
Message-ID: <492A12B8.9060304@gmail.com>
Date: Sun, 23 Nov 2008 18:34:32 -0800
From: Bob Cunningham <FlyMyPG@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <49287DCC.9040004@gmail.com>	<37219a840811231121u1350bf61n57109a1600f6dd92@mail.gmail.com>	<4929B192.8050707@rogers.com>	<4929FE90.2050008@gmail.com>
	<492A0478.8060101@gmail.com>
In-Reply-To: <492A0478.8060101@gmail.com>
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

Bob Cunningham wrote:
> Bob Cunningham wrote:
>> CityK wrote:
>>> Michael Krufky wrote:
>>>> On Sat, Nov 22, 2008 at 4:46 PM, Bob Cunningham <FlyMyPG@gmail.com> wrote:
>>>>   
>>>>> Hi,
>>>>>
>>>>> I just bought an AnyTV AUTV002 USB Tuner Stick from DealExtreme.  When plugged in, lsusb provides the following:
>>>>>
>>>>>   Bus 001 Device 011: ID 05e1:0400 Syntek Semiconductor Co., Ltd
>>>>>
>>>>> A quick search revealed that the au0828 driver ....
>>>>>     
>>>> Bob,
>>>>
>>>> A patch was submitted that adds support for a device with usb ID
>>>> 05e1:0400, but it did not get merged yet.
>>>>
>>>> The reason why I didn't merge the patch yet, is that there are
>>>> multiple devices out there using this USB id but they have different
>>>> internal components and no way to differentiate between the two.
>>>>
>>>> If you can open up your stick and tell us what is printed on each
>>>> chip, then I can help you get yours working.
>>> Likely (as mentioned in the related discussion/thread:
>>> http://marc.info/?l=linux-dvb&m=122472907625204&w=2):
>>>
>>> - Microtune MT213x (tuner)
>>> - Auvitek AU850x (demod)
>>> - Auvitek AU0828 (usb)
>>>
>> There are 3 chips, from the USB to the cable connector they are:
>> AU0828A
>> AU8522AA
>> MT2131F
>>
>> The silk screen text on the PC board reads "AUTV002_Ver1.0c"
>>
>> Pictures soon!
>>
>> -BobC
> 
> Hi yet again,
> 
> I checked the source, and it seems the patch I found (http://marc.info/?l=linux-dvb&m=122416362902362&w=2) had indeed not yet been committed to the tree.  I applied it to my updated source and reinstalled v4l.  The following devices now appear:
> 
> /dev/audio1
> /dev/dsp1
> /dev/dvb/adapter0
> /dev/mixer1
> /dev/ptmx
> 
> I have no idea if they are functional!  I tried running xine, but I am unfamiliar with it, so I don't know if there is a problem in the driver, or if it is a PEBKAC.
> 
> What is the preferred testing strategy?
> 
> 
> Thanks,
> 
> -BobC


As I stumbled through the maze, I was suddenly struck by a clue-by-4, and the following occurred:

    $ dvbscan /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB 
    Unable to query frontend status

I take it this is not a good thing.


-BobC

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
