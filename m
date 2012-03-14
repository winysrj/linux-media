Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759677Ab2CNUlH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 16:41:07 -0400
Date: Wed, 14 Mar 2012 16:41:01 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Steffen Barszus <steffenbpunkt@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: nuvoton-cir on Intel DH67CL
Message-ID: <20120314204101.GG3729@redhat.com>
References: <20120314071037.43f650e4@grobi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314071037.43f650e4@grobi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 14, 2012 at 07:10:37AM +0100, Steffen Barszus wrote:
> Hi !
> 
> I'm using above board which has a nuvoton-cir onboard (as most Intel
> Media boards) - It shows itself as NTN0530. 
> 
> The remote function works without a problem (loaded RC6 MCE keytable). 
> 
> What doesn't work is wake from S3 and wake from S5. There are some
> rumors that installing Windows 7 and corresponding drivers has a
> positive effect (for some it seems to be enough to do it one time,
> others need to redo this from time to time (power loss?). This leads me
> to believe, that some hardware initialization is missing. 
> 
> I'm about to try latest linux-media tree next days, but i believe
> there hasn't been any change on this driver. 
> 
> My questions: 
> - any idea of what i should look at ?
> - any change on the driver i could try ? 
> - *IF* i go to install Win7 and drivers - anything i could to to help
>   tracking down what this does in order to make the driver work out
>   of the box on linux ?
> 
> As a lot of Sandy Bridge Boards to have this chip lately - it would
> be nice if this could just work or is my impression, that this is a
> general problem in this hardware wrong ?   

My only nuvoton hardware works perfectly w/resume via IR after commit
3198ed161c9be9bbd15bb2e9c22561248cac6e6a, but its possible what you've got
is a newer hardware variant with some slightly different registers to
tweak. What does the driver identify your chip as in dmesg?

As of commit 362d3a3a9592598cef1d3e211ad998eb844dc5f3, the driver will
bind to anything with the PNP ID of NTN0530, but will spew a warning in
dmesg if its not an explicitly recognized chip.

-- 
Jarod Wilson
jarod@redhat.com

