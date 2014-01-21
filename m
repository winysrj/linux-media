Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63530 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbaAUTt1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jan 2014 14:49:27 -0500
Received: by mail-wi0-f180.google.com with SMTP id d13so4811050wiw.7
        for <linux-media@vger.kernel.org>; Tue, 21 Jan 2014 11:49:25 -0800 (PST)
Received: from [192.168.0.123] (host86-170-10-210.range86-170.btcentralplus.com. [86.170.10.210])
        by mx.google.com with ESMTPSA id hv3sm12696638wib.5.2014.01.21.11.49.24
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 21 Jan 2014 11:49:25 -0800 (PST)
Message-ID: <52DECF44.1070609@googlemail.com>
Date: Tue, 21 Jan 2014 19:49:24 +0000
From: Robert Longbottom <rongblor@googlemail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
References: <52DD977E.3000907@googlemail.com> <1c25db0a-f11f-4bc0-b544-692140799b2a@email.android.com> <7D00B0B1-8873-4CB2-903F-8B98749C75FF@googlemail.com> <20140121101950.GA13818@minime.bse>
In-Reply-To: <20140121101950.GA13818@minime.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/01/2014 10:19, Daniel Glöckner wrote:
> On Tue, Jan 21, 2014 at 09:27:38AM +0000, Robert Longbottom wrote:
>> On 20 Jan 2014, at 10:55 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>>> Robert Longbottom <rongblor@googlemail.com> wrote:
>>>> Chips on card:
 >
> Can you upload high resolution pictures of both sides of the card
> somewhere? Something where we can follow the tracks to these chips.
> Scanning the card with 300dpi should be enough.

Here are some high-res pictures of both sides of the card.  Scanned at 
600dpi (300dpi the tracks were very close).  Good idea to scan it by the 
way, I like that, much better result than with a digital camera.

http://www.flickr.com/photos/astrofraggle/12073752546/sizes/l/
http://www.flickr.com/photos/astrofraggle/12073651306/sizes/l/

(click original size at the top right for full res)


>>>> 1x 35.46895M Crystal
>
> Few cards use an 8x PAL Fsc crystal. Most have an NTSC crystal
> (28.6363 MHz) and rely on the PLL for PAL. Maybe this helps to rule
> out some card numbers.

I did have a look down the cardlist for ones with PLL_35 (?), but it 
didn't help me.  I dont think there are any with 4 inputs.  Assuming 
thats the right thing to do.

Thanks,
Rob.
