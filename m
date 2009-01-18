Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout05.t-online.de ([194.25.134.82]:42964 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762809AbZARLL3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2009 06:11:29 -0500
Message-ID: <49730E31.7030808@t-online.de>
Date: Sun, 18 Jan 2009 12:10:41 +0100
From: Detlef Rohde <rohde.d@t-online.de>
MIME-Version: 1.0
To: Roberto Ragusa <mail@robertoragusa.it>
CC: Antti Palosaari <crope@iki.fi>, Jochen Friedrich <jochen@scram.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCHv4] Add Freescale MC44S803 tuner driver
References: <496F9A1C.7040602@scram.de> <49722758.8030801@iki.fi> <49726547.7020903@t-online.de> <49726ABB.6060003@robertoragusa.it>
In-Reply-To: <49726ABB.6060003@robertoragusa.it>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Good morning Roberto,
thanks for the firmware file which finally helped getting my DVB-T
running! I pasted it in the /lib/firmware tree and could get a new message:

Jan 18 11:42:56 detlef-laptop kernel: [ 7677.396309] usb 4-3.3: new high
speed USB device using ehci_hcd and address 6
Jan 18 11:42:56 detlef-laptop kernel: [ 7677.517469] usb 4-3.3:
configuration #1 chosen from 1 choice
Jan 18 11:42:56 detlef-laptop kernel: [ 7677.548306] dvb-usb: found a
'TerraTec Cinergy T USB XE' in cold state, will try to load a firmware
Jan 18 11:42:56 detlef-laptop kernel: [ 7677.548318] firmware:
requesting dvb-usb-af9015.fw
Jan 18 11:42:56 detlef-laptop kernel: [ 7677.564421] dvb-usb:
downloading firmware from file 'dvb-usb-af9015.fw'
Jan 18 11:42:56 detlef-laptop kernel: [ 7677.648439] dvb-usb: found a
'TerraTec Cinergy T USB XE' in warm state.
Jan 18 11:42:56 detlef-laptop kernel: [ 7677.651636] dvb-usb: will pass
the complete MPEG2 transport stream to the software demuxer.
Jan 18 11:42:56 detlef-laptop kernel: [ 7677.653060] DVB: registering
new adapter (TerraTec Cinergy T USB XE)
Jan 18 11:42:57 detlef-laptop kernel: [ 7678.103047] af9013: firmware
version:4.95.0
Jan 18 11:42:57 detlef-laptop kernel: [ 7678.108177] DVB: registering
adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
Jan 18 11:42:57 detlef-laptop kernel: [ 7678.127280] mc44s803:
successfully identified (ID = 14)
Jan 18 11:42:57 detlef-laptop kernel: [ 7678.128910] dvb-usb: TerraTec
Cinergy T USB XE successfully initialized and connected.
When compiling Antti's source I have tried "make install" in one step as
root and got the message that "install" needs additional parameters.
Same happened when trying first only "make" and next "install".

Anyway using Kaffeine my TV is running now! There are some configuration
issues with this program but hopefully I will fix it soon. Thanks again
and have a nice Sunday!

Regards
Detlef



Roberto Ragusa schrieb:
> Detlef Rohde wrote:
>   
>> Hi All,
>> I have to apologize being a stupid newbie not able to put Antti's latest
>> source (mc44s803-71b0ef33303a) into my kernel (2.6.27-11-generic).
>> Have performed successfully a "make", but running "install" failed
>> because of missed option settings for this operation. I am uncertain if
>> I must set a path directory. Is'nt there a symbolic link to the right
>> directory?
>>     
>
> I don't understand what is happening.
> What kind of error message you get?
>
> Hmm, are you running "install" instead of "make install"?
>
>  "make" compiled lots of not needed stuff here, but my system
>   
>> needs only a firmware file:
>> (Copied from /var/log/messages)
>> Jan 17 23:22:21 detlef-laptop kernel: [  155.512517] dvb-usb: found a
>> 'TerraTec Cinergy T USB XE' in cold state, will try to load a firmware
>> Jan 17 23:22:21 detlef-laptop kernel: [  155.512530] firmware:
>> requesting dvb-usb-af9015.fw
>> Jan 17 23:22:21 detlef-laptop kernel: [  155.526289] dvb_usb_af9015:
>> probe of 4-3.3:1.0 failed with error -2
>>
>> Maybe Antti can post me one which I simply can paste into /lib/firmware?
>>     
>
> Here is the firmware I use.
>
> http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw
>
>   
>> Hopefully one of you can give an advice..
>>     
>
> I tried. :-)
>
>   


-


