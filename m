Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43939 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab3KOTL3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Nov 2013 14:11:29 -0500
Message-ID: <528671DF.7040707@iki.fi>
Date: Fri, 15 Nov 2013 21:11:27 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH RFC] libv4lconvert: SDR conversion from U8 to FLOAT
References: <1384103776-4788-1-git-send-email-crope@iki.fi> <5280D83C.5060809@xs4all.nl> <5280DE3D.5040408@iki.fi>
In-Reply-To: <5280DE3D.5040408@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11.11.2013 15:40, Antti Palosaari wrote:
> On 11.11.2013 15:14, Hans Verkuil wrote:
>> On 11/10/2013 06:16 PM, Antti Palosaari wrote:
>>> Convert unsigned 8 to float 32 [-1 to +1], which is commonly
>>> used format for baseband signals.


> I am also going to make some tests to find out if actual float
> conversion is faster against pre-calculated LUT, in Kernel or in
> libv4lconvert and so. Worst scenario I have currently is Mirics ADC with
> 14-bit resolution => 16384 quantization levels => 32-bit float LUT will
> be 16384 * 4 = 65536 bytes. Wonder if that much big LUT is allowed to
> library - but maybe you could alloc() and populate LUT on the fly if
> needed. Or maybe native conversion is fast enough.

That integer to float conversion uses quite much CPU still, even I use 
only 2M sampling rate.

When I do it inside Kernel, in URB completion handler at the same time 
when copying data to videobuf2, using pre-calculated LUTs and using mmap 
it eats 0.5% CPU to transfer stream to app.

When I do same but using libv4lconvert as that patch, it takes ~11% CPU.

And it was only 2M sampling rate, Mirics could go something like 15M.

I wonder if I can optimize libv4lconvert to go near in Kernel LUT 
conversion...

CPU: AMD Phenom(tm) II X4 955 Processor

regards
Antti

-- 
http://palosaari.fi/
