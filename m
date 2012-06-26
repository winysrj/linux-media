Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39752 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab2FZSN5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 14:13:57 -0400
Received: by yenl2 with SMTP id l2so207558yen.19
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2012 11:13:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE9FA7F.60800@netscape.net>
References: <4FE9FA7F.60800@netscape.net>
Date: Tue, 26 Jun 2012 14:13:56 -0400
Message-ID: <CAGoCfiyWLdtNVX-2CT9PraAvq-4WL3vUjqaw8o7+S-10R-eCQw@mail.gmail.com>
Subject: Re: dheitmueller/cx23885_fixes.git and mygica x8507
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 26, 2012 at 2:07 PM, Alfredo Jesús Delaiti
<alfredodelaiti@netscape.net> wrote:
> Hi all
>
> I tried the patches made by Devin Heitmueller, and returned soundto the
> plate mygica X8507.
> Has not corrected the green band that appears on the left side and shrinks
> the image by changing a little the aspect ratio, compresses a bit
> horizontally. With kernel versions 3.0, 3.1 and 3.2 that did not happen.

Hello Alfredo,

Thanks for testing.  Glad to hear you're having some success with
those patches.  A few questions about your specific board (since I
don't have the actual hardware):

1.  Which cx2388x based chip does it have?  cx23885?  cx23887?  cx23888?
2.  Specifically which video standard are you using?  NTSC?  PAL-BG?  PAL-DK?
3.  What input are you capturing on?  Tuner?  Composite?  S-video?
4.  Can you provide a screenshot showing the problem?
5.  Are you capturing raw video, or using MPEG encoder (assuming your
board has a cx23417)?

My guess is this is some sort of problem with the video standard
selection.  All of my testing thus far has been with NTSC-M, so I
would guess there is probably some general regression in PAL or SECAM
support (which should be pretty easy to fix once I have the answers to
the above questions).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
