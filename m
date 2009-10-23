Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:62822 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbZJWMrl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 08:47:41 -0400
Date: Fri, 23 Oct 2009 14:47:42 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: Details about DVB frontend API
Message-ID: <20091023144742.0459b84d@hyperion.delvare>
In-Reply-To: <829197380910221227sc3b6398xbd3061e8483ac41@mail.gmail.com>
References: <20091022211330.6e84c6e7@hyperion.delvare>
	<829197380910221227sc3b6398xbd3061e8483ac41@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

On Thu, 22 Oct 2009 15:27:20 -0400, Devin Heitmueller wrote:
> On Thu, Oct 22, 2009 at 3:13 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > Hi folks,
> >
> > I am looking for details regarding the DVB frontend API. I've read
> > linux-dvb-api-1.0.0.pdf, it roughly explains what the FE_READ_BER,
> > FE_READ_SNR, FE_READ_SIGNAL_STRENGTH and FE_READ_UNCORRECTED_BLOCKS
> > commands return, however it does not give any information about how the
> > returned values should be interpreted (or, seen from the other end, how
> > the frontend kernel drivers should encode these values.) If there
> > documentation available that would explain this?
> >
> > For example, the signal strength. All I know so far is that this is a
> > 16-bit value. But then what? Do greater values represent stronger
> > signal or weaker signal? Are 0x0000 and 0xffff special values? Is the
> > returned value meaningful even when FE_HAS_SIGNAL is 0? When
> > FE_HAS_LOCK is 0? Is the scale linear, or do some values have
> > well-defined meanings, or is it arbitrary and each driver can have its
> > own scale? What are the typical use cases by user-space application for
> > this value?
> >
> > That's the kind of details I'd like to know, not only for the signal
> > strength, but also for the SNR, BER and UB. Without this information,
> > it seems a little difficult to have consistent frontend drivers.
> >
> > Thanks,
> > --
> > Jean Delvare
> 
> I try to raise this every six months or so.  Check the mailing list
> archive for "SNR" in the subject line.
>
> Yes, it's all screwed up and inconsistent across demods.  I took a
> crack at fixing it a few months ago by proposing a standard (and even
> offering to fix up all the demods to be consistent), and those efforts
> were derailed by some individuals who wanted what I would consider a
> "perfect interface" at the cost of something that worked for 98% of
> the userbase (I'm not going to point any fingers).  And what did we
> get as a result?  Nothing.
> 
> I could have had this problem solved six months ago for 98% of the
> community, and instead we are right where we have been since the
> beginning of the project.
> 
> /me stops thinking about this and goes and gets some coffee....

Sorry, I didn't mean to restart a war. I really expected a standard to
exist but be possibly undocumented. I did not expect all these values
to not be standardized at all :( Thanks to all who answered anyway. I
sincerely hope that we can improve the situation in a near future.

I am not too familiar with DVB driver development, but I believe that
even loose standards would be much better than no standards at all. And
strict standards might not be possible to implement properly anyway, in
case we do not have detailed specifications of the hardware (which is
relatively frequent as I understand it.)

Taking the example of the signal strength, I think I would be fine with
the following description: 16-bit value, 0 means weakest signal
(possibly no signal at all), 0xffff means strongest signal. I suspect
user-space applications would already be able to do something about
this.

Thanks,
-- 
Jean Delvare
