Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.aster.pl ([212.76.33.56]:45318 "EHLO smtp2.aster.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932404Ab0AFTDJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jan 2010 14:03:09 -0500
Message-ID: <4B44CF62.5060405@aster.pl>
Date: Wed, 06 Jan 2010 18:58:58 +0100
From: Daro <ghost-rider@aster.pl>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: IR device at I2C address 0x7a
References: <4B324EF0.7090606@aster.pl> <20100106153909.6bce3183@hyperion.delvare>
In-Reply-To: <20100106153909.6bce3183@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean,

Thank you for your answer.
It is not the error message itself that bothers me but the fact that IR 
remote control device is not detected and I cannot use it (I checked it 
on Windows and it's working). After finding this thread I thought it 
could have had something to do with this error mesage.
Is there something that can be done to get my IR remote control working?
Thanks for your help in advance.

Best regards
Darek

W dniu 06.01.2010 15:39, Jean Delvare pisze:
> Hi Darek,
>
> Adding LMML to Cc.
>
> On Wed, 23 Dec 2009 18:10:08 +0100, Daro wrote:
>    
>> I have the problem you described at the mailing list with Asus
>> MyCinema-P7131/P/FM/AV/RC Analog TV Card:
>> IR remote control is not detected and "i2c-adapter i2c-3: Invalid 7-bit
>> address 0x7a" error occurs.
>> lspci gives the following output:
>> 04:00.0 Multimedia controller: Philips Semiconductors
>> SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
>> dmesg output I enclose in the attachment.
>> I use:
>> Linux DOMOWY 2.6.31-16-generic #53-Ubuntu SMP Tue Dec 8 04:02:15 UTC
>> 2009 x86_64 GNU/Linux
>>
>> I would be gratefull for the help on that.
>> (...)
>> subsystem: 1043:4845, board: ASUS TV-FM 7135 [card=53,autodetected]
>> (...)
>> i2c-adapter i2c-3: Invalid 7-bit address 0x7a
>> saa7133[0]: P7131 analog only, using entry of ASUSTeK P7131 Analog
>>      
> This error message will show on virtually every SAA713x-based board
> with no known IR setup. It doesn't imply your board has any I2C device
> at address 0x7a. So chances are that the message is harmless and you
> can simply ignore it.
>
>    

