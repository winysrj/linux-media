Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47316 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab1ENTat (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 May 2011 15:30:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [PATCHv2] v4l: Add M420 format definition
Date: Sat, 14 May 2011 21:31:46 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
References: <1305277915-8383-1-git-send-email-laurent.pinchart@ideasonboard.com> <201105131643.41364.laurent.pinchart@ideasonboard.com> <1305379915.2434.35.camel@localhost>
In-Reply-To: <1305379915.2434.35.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105142131.47200.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Andy,

On Saturday 14 May 2011 15:31:55 Andy Walls wrote:
> On Fri, 2011-05-13 at 16:43 +0200, Laurent Pinchart wrote:
> > On Friday 13 May 2011 14:01:32 Guennadi Liakhovetski wrote:
> > > Couldn't spot any problems with the patch except:
> > > 
> > > On Fri, 13 May 2011, Laurent Pinchart wrote:
> > > > From: Hans de Goede <hdegoede@redhat.com>
> > > > 
> > > > M420 is an hybrid YUV 4:2:2 packet/planar format. Two Y lines are
> > > 
> > > Didn't you mean "4:2:0"?
> > 
> > Yep. I'll fix that. Thanks for the review.
> > 
> > > And if I wanted to nit-pick, I think, it should be "a hybrid," I'm not
> > > a native-speaker though;)
> 
> Yes, "a hybrid" is the correct form.
> 
> <digression>
> The use of "a" or "an" is a speech rule; not a spelling rule.  If the
> word begins with a consonant sound, "a" is used; if the word begins with
> a vowel sound, "-n" is appended, so "an" is used.
> 
> The initial sounds of English words that begin with "h", "u", and "y"
> can't be determined by the inital letter alone.  One has to know how to
> pronounce the word to choose the correct form:
> 
> 	a hint
> 	a unit
> 	a yard
> 
> 	an hour
> 	an umbrella
> 	an yttrium atom
> 
> The rule for appending "-n" to "a" before a vowel sound allows faster
> speech.  Without the "-n" before a vowel sound, an English speaker is
> going to pronounce the "a" either as a dipthong or with a trailing
> glottal stop.  Either will slow down speech ever so slightly.
> </digression>

I love your digressions about the English language, please keep them coming 
:-)

-- 
Regards,

Laurent Pinchart
