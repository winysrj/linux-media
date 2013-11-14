Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3248 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3KNNwT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Nov 2013 08:52:19 -0500
Message-ID: <5284D53D.9020603@xs4all.nl>
Date: Thu, 14 Nov 2013 14:50:53 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH RFC] libv4lconvert: SDR conversion from U8 to FLOAT
References: <1384103776-4788-1-git-send-email-crope@iki.fi> <1384179541.1949.24.camel@palomino.walls.org> <5280EBD4.5010505@xs4all.nl> <5284D410.4010706@iki.fi>
In-Reply-To: <5284D410.4010706@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/14/13 14:45, Antti Palosaari wrote:
> On 11.11.2013 16:38, Hans Verkuil wrote:
>> On 11/11/2013 03:19 PM, Andy Walls wrote:
>>> On Sun, 2013-11-10 at 19:16 +0200, Antti Palosaari wrote:
>>>> Convert unsigned 8 to float 32 [-1 to +1], which is commonly
>>>> used format for baseband signals.
>>>
>>> Hi Annti,
>>>
>>> I don't think this a good idea.  Floating point representations are
>>> inherently non-portable.  Even though most everything now uses IEEE-754
>>> representation, things like denormaliazed numbers may be treated
>>> differently by different machines.  If someone saves the data to a file,
>>> endianess issues aside, there are no guarantees that a different machine
>>> reading is going to interpret all the floating point data from that file
>>> properly.
>>>
>>> I really would recommend staying with scaled integer representations or
>>> explicit integer mantissa, exponent representations.
>>
>> For what it's worth: ALSA does support float format as well (both LE and BE).
> 
> I want use existing data formats and that [-1 to +1] scaled 32-bit IEEE-754 floating point is de facto format for SDR application (actually pair of floats as a complex).
> 
> Doing conversion inside libv4lconvert makes it very easy for write application. Currently I have implemented GNU Radio and SDRsharp plugins that feeds data from device via libv4l2 using mmap and conversion.
> 
> Thanks to pointing endianess issue, I didn't though it all. I suspect those apps just relies to local endianess. So do I have to implement float format conversion with both endianess?

I would say that it should be written with endianness conversion in mind. It's not
likely to be used on a big-endian system, but it should be possible to support it
without too much work.

Regards,

	Hans
