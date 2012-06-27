Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-ma03.mx.aol.com ([64.12.206.41]:62671 "EHLO
	imr-ma03.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab2F0DqV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 23:46:21 -0400
Message-ID: <4FEA80C3.90102@netscape.net>
Date: Wed, 27 Jun 2012 00:40:51 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: dheitmueller/cx23885_fixes.git and mygica x8507
References: <4FE9FA7F.60800@netscape.net> <CAGoCfiyWLdtNVX-2CT9PraAvq-4WL3vUjqaw8o7+S-10R-eCQw@mail.gmail.com>
In-Reply-To: <CAGoCfiyWLdtNVX-2CT9PraAvq-4WL3vUjqaw8o7+S-10R-eCQw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hika Devin

El 26/06/12 15:13, Devin Heitmueller escribió:
> On Tue, Jun 26, 2012 at 2:07 PM, Alfredo Jesús Delaiti
> <alfredodelaiti@netscape.net> wrote:
>> Hi all
>>
>> I tried the patches made by Devin Heitmueller, and returned soundto the
>> plate mygica X8507.
>> Has not corrected the green band that appears on the left side and shrinks
>> the image by changing a little the aspect ratio, compresses a bit
>> horizontally. With kernel versions 3.0, 3.1 and 3.2 that did not happen.
> Hello Alfredo,
>
> Thanks for testing.  Glad to hear you're having some success with
> those patches.  A few questions about your specific board (since I
> don't have the actual hardware):
>
> 1.  Which cx2388x based chip does it have?  cx23885?  cx23887?  cx23888?

CX23885
> 2.  Specifically which video standard are you using?  NTSC?  PAL-BG?  PAL-DK?
PAL-Nc and NTSC (ntsc is fine at 765 pixels)
> 3.  What input are you capturing on?  Tuner?  Composite?  S-video?
Tuner
> 4.  Can you provide a screenshot showing the problem?
Yes, but read below
> 5.  Are you capturing raw video, or using MPEG encoder (assuming your
> board has a cx23417)?
Raw video, not have a cx23417
>
> My guess is this is some sort of problem with the video standard
> selection.  All of my testing thus far has been with NTSC-M, so I
> would guess there is probably some general regression in PAL or SECAM
> support (which should be pretty easy to fix once I have the answers to
> the above questions).
>
> Devin
>
The problem was that tvtime was set to 768, by passing a resolution to 
720 was solved. Sorry for not having tried before.
With a resolution of 720 pixels the image looks good.
My sincere apologies and thanks.

Alfredo

-- 
Dona tu voz
http://www.voxforge.org/es

