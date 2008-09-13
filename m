Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dvb-t@iinet.com.au>) id 1KeN6j-0004wU-A8
	for linux-dvb@linuxtv.org; Sat, 13 Sep 2008 06:51:43 +0200
Message-ID: <364182F867A246399A9763EB79AEA92D@mce>
From: "David" <dvb-t@iinet.com.au>
To: <crope@iki.fi>
References: <DA670E4156FE4C8DB883E07249860A77@CRAYXT5><48AE5818.1090102@iki.fi>
	<582F06C81BBE431CAAC4B75432B12578@mce>
Date: Sat, 13 Sep 2008 14:51:31 +1000
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] USB DVB-T Tuner with Alfa AF9015 + Philips TDA18211
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

From: "David" <dvb-t@iinet.com.au>
To: "Antti Palosaari" <crope@iki.fi>
Cc: <linux-dvb@linuxtv.org>
Sent: Thursday, September 11, 2008 11:54 AM
Subject: Re: [linux-dvb] USB DVB-T Tuner with Alfa AF9015 + Philips TDA18211


>> David wrote:
>>> Hi All
>>>
>>> I have been offered this low cost device.
>>> Just to enquire if any work is has already been done or is underway, to
>>> support devices with this chipset and tuner combination.
>>
>> Could you try http://linuxtv.org/hg/~anttip/af9015 . Download firmware
>> from
>> http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw
>> . It should work if your device has reference design USB-IDs, if not new
>> USB-IDs should be added to the driver.
>>
>> regards
>> Antti
>> -- 
>> http://palosaari.fi/
>
> Hi Antti
>
> Thanks very much for your reply and apologies for the delay in my response
> as I only received a sample of this unit today.
>
> I tested it in a box that already had your driver installed for use with a
> Leadtek Winfast Dongle Gold (which, incidentally works extremely well, 
> thank
> you for your efforts.)
>
> I ran a dmesg and the system sees it as:-
> [ 23.514189] input: NEWMI USB2.0 DVB-T TV Stick as
> /devices/pci0000:00/0000:00:04.1/usb4/4-6/4-6:1.1/input/input1
>
> The af9015 driver complains:
> [ 34.055777] dvb_usb_af9015: disagrees about version of symbol
> dvb_usb_device_init
>
> lsusb returns:
> Bus 004 Device 003: ID 15a4:9016
>
> Regards
> David

Hi Antii

As a follow up to this I had another look at it today.
I remembered I had also been testing a DVICO Dual Digital 4 r2 card in this 
box.
I decided to reload a disk image of a MythBuntu installation that originally 
had a Winfast Dongle Gold installed.
Happy to report that the device works perfectly, without requiring any 
changes to settings.

Regards
David

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
