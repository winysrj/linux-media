Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mk-outboundfilter-1.mail.uk.tiscali.com ([212.74.114.37])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dcharvey@dsl.pipex.com>) id 1Jeo77-0007u2-P1
	for linux-dvb@linuxtv.org; Thu, 27 Mar 2008 10:09:40 +0100
Message-ID: <47EB642F.3050606@dsl.pipex.com>
Date: Thu, 27 Mar 2008 09:09:03 +0000
From: David Harvey <dcharvey@dsl.pipex.com>
MIME-Version: 1.0
To: Philip Pemberton <lists@philpem.me.uk>
References: <mailman.81.1206506075.819.linux-dvb@linuxtv.org>
	<47EA17BE.3080409@dsl.pipex.com> <47EACB93.7050400@philpem.me.uk>
In-Reply-To: <47EACB93.7050400@philpem.me.uk>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Nova - t disconnects
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

Philip Pemberton wrote:
> David Harvey wrote:
>>  MT2060: successfully identified (IF1 = 1220)
>> [ 589.459712] input: IR-receiver inside an USB DVB receiver as 
>> /devices/pci0000:00/0000:00:13.2/usb3/3-8/input/input16
>> [ 589.470534] dvb-usb: schedule remote query interval to 150 msecs.
>> [ 589.470540] dvb-usb: Hauppauge Nova-T Stick successfully 
>> initialized and connected.
>> [ 606.300175] hub 3-0:1.0: port 8 disabled by hub (EMI?), re-enabling...
>> [ 606.300181] usb 3-8: USB disconnect, address 11
>> [ 606.312990] mt2060 I2C write failed
>> [ 608.563167] mt2060 I2C write failed
>> [ 608.563243] mt2060 I2C write failed (len=2)
>> [ 608.563246] mt2060 I2C write failed (len=6)
>
> ...
>
> Here's your problem:
>
>> 00:00.0 Host bridge: ATI Technologies Inc RS480 Host Bridge (rev 01)
> ...
>> 00:13.0 USB Controller: ATI Technologies Inc IXP SB400 USB Host 
>> Controller
>> 00:13.1 USB Controller: ATI Technologies Inc IXP SB400 USB Host 
>> Controller
>> 00:13.2 USB Controller: ATI Technologies Inc IXP SB400 USB2 Host 
>> Controller
>
> USB2 on ATI chipsets is hopelessly, horrendously broken. A Cardbus 
> USB2 card (or in the case of a desktop, a PCI USB2 card) should fix 
> this -- the NEC chipset based boards are (from what I've heard) the 
> best of the bunch, but VIA based boards aren't (too) bad.
>

I see!  I'll try and get hardy (and therefore the 2.6.24 kernel testing 
on my hopelessly underpowered mythbackend (Epia Mini itx 1Ghz) to offer 
some feedback from another chipset combo

Cheers,

dh

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
