Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43400 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab3KRRn7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Nov 2013 12:43:59 -0500
Message-ID: <528A51DD.8000502@iki.fi>
Date: Mon, 18 Nov 2013 19:43:57 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH RFC] libv4lconvert: SDR conversion from U8 to FLOAT
References: <1384103776-4788-1-git-send-email-crope@iki.fi> <1384179541.1949.24.camel@palomino.walls.org>
In-Reply-To: <1384179541.1949.24.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11.11.2013 16:19, Andy Walls wrote:
> On Sun, 2013-11-10 at 19:16 +0200, Antti Palosaari wrote:
>> Convert unsigned 8 to float 32 [-1 to +1], which is commonly
>> used format for baseband signals.
>
> Hi Annti,
>
> I don't think this a good idea.  Floating point representations are
> inherently non-portable.  Even though most everything now uses IEEE-754
> representation, things like denormaliazed numbers may be treated
> differently by different machines.  If someone saves the data to a file,
> endianess issues aside, there are no guarantees that a different machine
> reading is going to interpret all the floating point data from that file
> properly.
>
> I really would recommend staying with scaled integer representations or
> explicit integer mantissa, exponent representations.

Do you mean scaled presentation like a  sample is always 32 signed 
integer and what ever ADC resolution is, it is scaled to 32-bit signed 
int and returned?

What I would like to implement is 8-bit int, 16-bit int and maybe 32-bit 
int (if there comes ADC outputting more than 16-bit). These all 
conversions are done inside Kernel, which actually has price about 
nothing as it is simple integer math with bit shifting (scaling == bit 
shifting). If you do that kind of conversion on USB URB interrupt at the 
same time as memory copy from URB to videobuf2 is needed, it is 
basically free.

Then it is up to caller to select int8, int16, int32 and driver does the 
rest, selects actual ADC resolution using info like sampling rate.

Also returning SDR floats directly from Kernel driver could be very 
handy, but as floats are not allowed in Kernel...


But now all conversions are in the libv4l. However, it is possible to 
add new formats to driver later - removing existing formats from driver 
is about impossible.

regards
Antti

-- 
http://palosaari.fi/
