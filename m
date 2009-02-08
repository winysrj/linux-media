Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:55458 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbZBHVhZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Feb 2009 16:37:25 -0500
Message-ID: <498F50AE.4080004@free.fr>
Date: Sun, 08 Feb 2009 22:37:50 +0100
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Jason Harvey <softdevice@jasonline.co.uk>
CC: linux-media@vger.kernel.org
Subject: Re: CinergyT2 not working with newer alternative driver
References: <4984E50D.8000506@jasonline.co.uk> <49857A09.9020302@free.fr> <49859A71.70701@jasonline.co.uk> <4986925A.9040800@free.fr> <498697B5.10200@jasonline.co.uk>
In-Reply-To: <498697B5.10200@jasonline.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jason Harvey wrote:
> Thierry Merle wrote:
>> Jason Harvey wrote:
>>  
>>> Thierry Merle wrote:
>>>    
>>>> Hi Jason,
>>>> Jason Harvey wrote:
>>>>  
>>>>      
>>>>> I have been successfully using VDR with two CinergyT2s for 18 months.
>>>>> After adding a Hauppage NOVA-S2-HD I updated my v4l-dvb drivers hoping
>>>>> to get S2 capability and test a newer VDR for HD reception.
>>>>>
>>>>> The CinergyT2s stopped working. The kernel module loads, the blue leds
>>>>> flash as expected but they don't lock on to a signal for long.
>>>>> Signal strength shown in femon is erratic and a lock only rarely
>>>>> achieved.
>>>>>
>>>>> I checked through the mercurial tree to see what had changed.
>>>>> It looks like the following change is the one that stops the
>>>>> CinergyT2s
>>>>> working on my system.
>>>>> http://git.kernel.org/?p=linux/kernel/git/mchehab/devel.git;a=commit;h=986bd1e58b18c09b753f797df19251804bfe3e84
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> I deleted the newer version of the module and replace it with the
>>>>> previous deleted code.
>>>>> Make'd and installed the old version works as expected.
>>>>>
>>>>> Machine they're plugged into is running Fedora 10,
>>>>> 2.6.27.12-170.2.5.fc10.i686
>>>>> I downloaded the current v4l-dvb today (31Jan2009) and tried it all
>>>>> again before posting this message.
>>>>>
>>>>> Not sure where to look next, I did start to capture the USB traffic to
>>>>> see if I could spot the difference...
>>>>>
>>>>>             
>>>> Please take a look at the message logs (dmesg).
>>>> You can follow the instructions described here
>>>> http://www.linuxtv.org/wiki/index.php/Testing_your_DVB_device
>>>> and report where it fails.
>>>>
>>>> I use tzap like this: tzap -c $HOME/.tzap/channels.conf -s -t 120 -r
>>>> -o output.mpg "SomeChannel"
>>>> I am able to play with mplayer too.
>>>> Regards,
>>>> Thierry
>>>>         
>>> Hi Thierry,
>>>
>>> Thank you for the quick reply.
>>> I should have looked in dmesg before...
>>> Checking dmesg before I used tzap shows a problem. dvb-usb: recv bulk
>>> message failed: -110
>>>
>>> **** Extract of dmesg ****
>>>
>>> dvb-usb: found a 'TerraTec/qanu USB2.0 Highspeed DVB-T Receiver' in warm
>>> state.
>>> dvb-usb: will pass the complete MPEG2 transport stream to the software
>>> demuxer.
>>> DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T
>>> Receiver)
>>> DVB: registering adapter 0 frontend 0 (TerraTec/qanu USB2.0 Highspeed
>>> DVB-T Receiver)...
>>> input: IR-receiver inside an USB DVB receiver as
>>> /devices/pci0000:00/0000:00:1a.7/usb1/1-1/input/input8
>>> dvb-usb: schedule remote query interval to 50 msecs.
>>> dvb-usb: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully
>>> initialized and connected.
>>> dvb-usb: found a 'TerraTec/qanu USB2.0 Highspeed DVB-T Receiver' in warm
>>> state.
>>> dvb-usb: will pass the complete MPEG2 transport stream to the software
>>> demuxer.
>>> DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T
>>> Receiver)
>>> DVB: registering adapter 1 frontend 0 (TerraTec/qanu USB2.0 Highspeed
>>> DVB-T Receiver)...
>>> input: IR-receiver inside an USB DVB receiver as
>>> /devices/pci0000:00/0000:00:1d.7/usb2/2-5/input/input9
>>> dvb-usb: schedule remote query interval to 50 msecs.
>>> dvb-usb: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully
>>> initialized and connected.
>>> usbcore: registered new interface driver cinergyT2
>>>
>>> dvb-usb: recv bulk message failed: -110
>>> dvb-usb: recv bulk message failed: -110
>>>
>>> ****
>>>
>>> Running tzap fails to tune/lock
>>>
>>> #tzap -a 0 -c channels.conf_dvbt -s -t 120 -r -o output.mpg "BBC ONE"
>>>
>>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>> reading channels from file 'channels.conf_dvbt'
>>> tuning to 505833330 Hz
>>> video pid 0x0258, audio pid 0x0259
>>> status 01 | signal c11f | snr 0000 | ber ffffffff | unc ffffffff |
>>>
>>> No more messages in dmesg.
>>>
>>> I shut down the PC, removed all power, unplugged the CinergyT2s, gave it
>>> twenty seconds and powered back up.
>>> Once it had booted I plugged in one of the devices and the dmesg output
>>> below.
>>>
>>>
>>> usb 2-5: new high speed USB device using ehci_hcd and address 3
>>> usb 2-5: config 1 interface 0 altsetting 0 bulk endpoint 0x1 has invalid
>>> maxpacket 64
>>> usb 2-5: config 1 interface 0 altsetting 0 bulk endpoint 0x81 has
>>> invalid maxpacket 64
>>> usb 2-5: configuration #1 chosen from 1 choice
>>> usb 2-5: New USB device found, idVendor=0ccd, idProduct=0038
>>> usb 2-5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>>> usb 2-5: Product: Cinergy T?
>>> usb 2-5: Manufacturer: TerraTec GmbH
>>> dvb-usb: found a 'TerraTec/qanu USB2.0 Highspeed DVB-T Receiver' in warm
>>> state.
>>> dvb-usb: will pass the complete MPEG2 transport stream to the software
>>> demuxer.
>>> DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T
>>> Receiver)
>>> DVB: registering adapter 1 frontend 0 (TerraTec/qanu USB2.0 Highspeed
>>> DVB-T Receiver)...
>>> input: IR-receiver inside an USB DVB receiver as
>>> /devices/pci0000:00/0000:00:1d.7/usb2/2-5/input/input9
>>> dvb-usb: schedule remote query interval to 50 msecs.
>>> dvb-usb: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully
>>> initialized and connected.
>>> usbcore: registered new interface driver cinergyT2
>>> dvb-usb: recv bulk message failed: -110
>>>
>>> Cannot tzap or scan.
>>>
>>> With the old version of the driver I don't have any trouble at all.
>>>
>>>     
>> I do have this bulk message error too, sometimes (this is a timeout on
>> recv).
>> I can tune channels but I think I have a particular version of the
>> CinergyT2 (there are several).
>> You can turn on the debug infos:
>> modprobe dvb-core dvbdev_debug=1 debug=1
>> modprobe dvb-usb-cinergyT2 debug=7
>> and see again dmesg...
>>   
> 
> Dmesg on plugging in the device as follows :-
> 
>    usb 2-5: new high speed USB device using ehci_hcd and address 3
>    usb 2-5: config 1 interface 0 altsetting 0 bulk endpoint 0x1 has
>    invalid maxpacket 64
>    usb 2-5: config 1 interface 0 altsetting 0 bulk endpoint 0x81 has
>    invalid maxpacket 64
>    usb 2-5: configuration #1 chosen from 1 choice
>    usb 2-5: New USB device found, idVendor=0ccd, idProduct=0038
>    usb 2-5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>    usb 2-5: Product: Cinergy T?
>    usb 2-5: Manufacturer: TerraTec GmbH
>    dvb-usb: found a 'TerraTec/qanu USB2.0 Highspeed DVB-T Receiver' in
>    warm state.
>    dvb-usb: will pass the complete MPEG2 transport stream to the
>    software demuxer.
>    DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T
>    Receiver)
>    DVB: register adapter1/demux0 @ minor: 4 (0x04)
>    DVB: register adapter1/dvr0 @ minor: 5 (0x05)
>    DVB: register adapter1/net0 @ minor: 6 (0x06)
>    DVB: registering adapter 1 frontend 0 (TerraTec/qanu USB2.0
>    Highspeed DVB-T Receiver)...
>    DVB: register adapter1/frontend0 @ minor: 7 (0x07)
>    input: IR-receiver inside an USB DVB receiver as
>    /devices/pci0000:00/0000:00:1d.7/usb2/2-5/input/input9
>    dvb-usb: schedule remote query interval to 50 msecs.
>    dvb-usb: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully
>    initialized and connected.
>    usbcore: registered new interface driver cinergyT2
> 
> 
> tzap -a 1 -c channels.conf_dvbt -s -t 120 -r -o output.mpg "BBC ONE"
> only puts the following two lines into dmesg :-
> 
> function : dvb_dvr_open
> cinergyt2_fe_sleep() Called
> 
> Not much there really!
> 
> Regards, Jason
Another thing, do you know the firmware version of your tuner?
I have the 1.06 version.
Look at lsusb -vvv, this is the "bcdDevice" line for the CinergyT2 device.
Sorry but I have no idea of the origin of the problem.
If I had time I would compare USB dumps between the old driver and the new one for the same tuning operation.

Regards,
Thierry
