Return-path: <linux-media-owner@vger.kernel.org>
Received: from li248-118.members.linode.com ([173.255.238.118]:60643 "EHLO
	kahlo.theo.to" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753240Ab3EUMMT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 08:12:19 -0400
Message-ID: <519B649C.9040903@theo.to>
Date: Tue, 21 May 2013 08:12:12 -0400
From: Ted To <rainexpected@theo.to>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: InstantFM
References: <51993390.6080202@theo.to> <5199C8FA.9060704@redhat.com> <519A4464.7060006@theo.to> <519A6DBB.60608@theo.to> <519B23A7.90504@redhat.com>
In-Reply-To: <519B23A7.90504@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 05/21/2013 03:35 AM, Hans de Goede wrote:
> Hi,
> 
> On 05/20/2013 08:38 PM, Ted To wrote:
> <snip>
> 
>> Actually, playing around with it some more (the version in the stable
>> repository), it appears to be picking something up.  "radio -s" produces
>> the following:
>>
>> $ radio -s
> q> baseline at 1.00
>> Station  0:  88.10 MHz - 4.00
>> Station  1:  88.90 MHz - 3.00
>> Station  2:  89.70 MHz - 2.00
>> Station  3:  91.50 MHz - 2.00
>> Station  4:  92.35 MHz - 3.00
>> Station  5:  93.10 MHz - 3.00
>> Station  6:  95.10 MHz - 3.00
>> Station  7:  95.90 MHz - 2.00
>> Station  8:  97.80 MHz - 4.00
>> Station  9:  99.10 MHz - 2.00
>> Station 10: 100.45 MHz - 2.00
>> Station 11: 101.90 MHz - 2.00
>> Station 12: 102.70 MHz - 2.00
>> Station 13: 104.25 MHz - 4.00
>> Station 14: 105.75 MHz - 3.00
>> Station 15: 106.50 MHz - 5.00
>> tuned 88.10 MHz
>>
>> I assume that the last number is a measure of signal strength?
> 
> Yes, more or less.
> 
>> The problem is that no sound is produced.  FYI, gnomeradio gives a
>> 'Could not open "/dev/mixer"!' error.  There seem to be some bugs
>> reported regarding this problem.
> 
> Right, have you also tried with the latest version of radio ? The
> 3.103 version has digital audio loopbacking support, so it will
> read audio from the usb stick (which show up as a usb soundcard)
> and then send it to your default alsa device, also see radio -help
> output.

Unfortunately 3.103 (from the debian unstable repository) does not
appear to work at all for me.  If I set the frequency:

radio -f 88.5

I get:

Tuning to 88.50 MHz
Invalid freq '138650000'. Current freq out of range?

When scanning:

radio -s

produces no output whatsoever before going to the curses interface set
at frequency 138.65.

> About setting the frequency not working, I've just tried with
> my own si470x device, and this works fine:
> radio -f 97.6
> 
> As for the reported hardware / software version, my usb-stick has:
> 
> radio-si470x 4-2:1.2: software version 1, hardware version 7
> 
> Where as your has:
> 
> radio-si470x 2-3:1.2: software version 0, hardware version 7
> radio-si470x 2-3:1.2: This driver is known to work with software version 7,
> radio-si470x 2-3:1.2: but the device has software version 0.
> 
> Since my device works fine, in the latest driver the software version check
> has been lowered to version 1. And if we can get yours to work too, we can
> lower it even further.
> 
> Which kernel version are you using ?

3.2.0-4-amd64

I could try the liquorix kernel (3.8) if you thought it might help.

Thanks,
Ted
