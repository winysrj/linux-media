Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:59196 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756068Ab0I3VtA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 17:49:00 -0400
Message-ID: <4CA505C9.1040400@iki.fi>
Date: Fri, 01 Oct 2010 00:48:57 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@anciens.enib.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	eric.valette@free.fr
Subject: Re: [PATCH] v4l/dvb: add support for AVerMedia AVerTV Red HD+ (A850T)
References: <1285795123-11046-1-git-send-email-yann.morin.1998@anciens.enib.fr> <201009301956.50154.yann.morin.1998@anciens.enib.fr> <4CA4F640.7030206@iki.fi> <201009302309.58546.yann.morin.1998@anciens.enib.fr>
In-Reply-To: <201009302309.58546.yann.morin.1998@anciens.enib.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Moi Yann

On 10/01/2010 12:09 AM, Yann E. MORIN wrote:
> Antti, All,
>
> On Thursday 30 September 2010 22:42:40 Antti Palosaari wrote:
>> On 09/30/2010 08:56 PM, Yann E. MORIN wrote:
>>> OK. The number of supported devices is already 9 in all sections, so I guess
>>> I'll have to add a new entry in the af9015_properties array, before I can
>>> add a new device, right?
>> Actually you are using too old code as base. You should take latest GIT
>> media tree and 2.6.37 branch.
>
> I'm using the latest tree from:
>    git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
>
> Is that OK?

No, it is too old. Correct tree is staging/v2.6.37 at:
http://git.linuxtv.org/media_tree.git

>> IIRC max is currently 12 devices per entry.
>
> Yes, the array in the struct has 12 entries, but the comments in the
> af9015 code said: "/* max 9 */". So I stuck to the comment.

That`s since count is increased after comment. I have changed it already.

> I would make use of the entries left. The af9015_properties is an array
> with currently 3 entries. Each entries currently all have 9 device
> description. Do you prefer that I add the new description:
> - in the first entry,
> - just below the existing A850, (my pick)
> - or in the last entry?

Add it to the first free slot find. It was TerraTec Cinergy T Dual RC I 
added lastly. If there is free space put it just behind that, otherwise 
to the first free slot in next entry. This entry/dev count really sucks 
a little bit, it should be fixed if possible... but as now we left it.

> And to answer your previous question:
>> Are you sure it does also have such bad eeprom content? Is that really
>> needed? What it happens without this hack?
>
> Yes, I just tried without the hack and it breaks. With the hack, it works.
> I can provide the failing dmesg output if needed (see working one below).

OK, then hack is needed.

>>> And what is the intrinsic difference between adding a new device section,
>>> compared to adding a new PID to an existing device (just curious) ?
>> Not much more than a little bit different device name. Technically you
>> can add all IDs to one device, but I feel better to add new entry per
>> device. If device name is same but only ID is different it typically
>> means different hw revision and in that case I would like to put those
>> same for same entry. In that case device is also a little bit different
>> - at least case colour.
>
> OK, got it. I'm afraid the A850T is just a A850 re-branded for the french
> market. Here is the relevant dmesg output when I plug the stick (with my
> changes applied on a 2.6.35.6):
>
> [12547.002398] usb 3-3.1: new high speed USB device using ehci_hcd and address 9
> [12547.090226] usb 3-3.1: New USB device found, idVendor=07ca, idProduct=850b
> [12547.090228] usb 3-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [12547.090230] usb 3-3.1: Product: A850 DVBT
> [12547.090231] usb 3-3.1: Manufacturer: AVerMedia
> [12547.090232] usb 3-3.1: SerialNumber: 302970601989000
> [12547.093558] input: AVerMedia A850 DVBT as /class/input/input14
> [12547.093603] generic-usb 0003:07CA:850B.000A: input,hidraw6: USB HID v1.01 Keyboard [AVerMedia A850 DVBT] on usb-0000:07:02.2-3.1/input1
> [12547.488128] dvb-usb: found a 'AverMedia AVerTV Red HD+' in cold state, will try to load a firmware
> [12547.492200] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
> [12547.563986] dvb-usb: found a 'AverMedia AVerTV Red HD+' in warm state.
> [12547.564032] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> [12547.564372] DVB: registering new adapter (AverMedia AVerTV Red HD+)
> [12547.572230] af9013: firmware version:5.1.0
> [12547.576731] DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
> [12547.581615] MXL5005S: Attached at address 0xc6
> [12547.581653] input: IR-receiver inside an USB DVB receiver as /class/input/input15
> [12547.581656] dvb-usb: schedule remote query interval to 150 msecs.
> [12547.581658] dvb-usb: AverMedia AVerTV Red HD+ successfully initialized and connected.
> [12547.678851] usbcore: registered new interface driver dvb_usb_af9015
>
> See the part that reads:
>    input: AVerMedia A850 DVBT as /class/input/input14
>           ^^^^^^^^^^^^^^^^^^^
>
> This is no kernel message, and (I guess) it comes as the ID string from the
> device. It also appears on a machine where I have no DVB support.

Yes, it comes from eeprom, also lsusb should show it (lsusb -vvd usb-id)

> So I believe the patch is OK in the state, unless you really want a new
> device description, instead of adding to the existing A850 ( yes, granted,
> it's not the same color ;-] ). What is your final word? ;-)

Hmm, now I like it when it is identified as AverMedia AVerTV Red HD+.
>
> Anyway, before you get action and push this patch, Eric helped in the testing
> so far. Maybe he'll want to add his tested-by?
>
> Thank you very much for your comments and guidance!
>
> Regards,
> Yann E. MORIN.
>

If you can make patch against latest 2.6.37 pointed I it will be OK. 
Also possible remote could be nice... 2.6.37 af9015 have totally 
different remote implementation.

thanks,
Antti
-- 
http://palosaari.fi/
