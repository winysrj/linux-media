Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50400 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788AbbCNJPh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 05:15:37 -0400
Message-ID: <5503FC2D.8070603@xs4all.nl>
Date: Sat, 14 Mar 2015 10:15:25 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCHv2 00/21] marvell-ccic: drop and fix formats
References: <1426061428-47019-1-git-send-email-hverkuil@xs4all.nl> <20150313172801.6bc4bf75@lwn.net> <55035DA4.2020903@xs4all.nl>
In-Reply-To: <55035DA4.2020903@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/13/2015 10:59 PM, Hans Verkuil wrote:
> Hi Jon,
> 
> On 03/13/2015 10:28 PM, Jonathan Corbet wrote:
>> On Wed, 11 Mar 2015 09:10:24 +0100
>> Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>>> After some more testing I realized that the 422P format produced
>>> wrong colors and I couldn't get it to work. Since it never worked and
>>> nobody complained about it (and it is a fairly obscure format as well)
>>> I've dropped it.
>>
>> I'm not sure how that format came in anymore; I didn't add it.  No
>> objections to its removal.
> 
> It came in with the patches from Marvell.
> 
>>> I also tested RGB444 format for the first time, and that had wrong colors
>>> as well, but that was easy to fix. Finally there was a Bayer format
>>> reported, but it was never implemented. So that too was dropped.
>>
>> The RGB444 change worries me somewhat; that was the default format on the
>> XO1 and worked for years.  I vaguely remember some discussions about the
>> ordering of the colors there, but that was a while ago.  Did you test it
>> with any of the Sugar apps?
> 
> I've tested with the 'Record' app, and that picks a YUV format, not RGB444.
> Are there other apps that I can test with where you can select the capture
> format?

Urgh. I did some more digging and this driver really supported a big endian
version of RGB444. So the description in the documentation of the RGB444
format and what this driver returns is different.

It looks like Michael Schimek's question regarding endianness went unanswered:
http://www.spinics.net/lists/vfl/msg28921.html

He probably assumed the same order as for RGB555/565 formats.

I have three options:

1) fix the driver as I did in my patch so RGB444 follows the documentation.
2) add a new RGB444X big endian pixel format and switch the driver to that.
   So RGB444 is no longer supported, instead RGB444X is now supported. Apps
   will have to change PIX_FMT_RGB444 to PIX_FMT_RGB444X.
3) add support for both RGB444 and RGB444X to the driver.

Note that it is not possible to change the RGB444 documentation since this
format is used in other drivers as well, and there it is in proper little
endian format.

I am actually favoring option 2, since that prevents current applications
using RGB444 from working with the new kernel, but it is easy to fix by
changing RGB444 to RGB444X. OLPC specific apps can even just assume that
RGB444 and RGB444X are the same, and so they will work with both the new
and old driver.

Let me know what you prefer.

Regards,

	Hans
