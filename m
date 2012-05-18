Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:55373 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839Ab2ERHHA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 03:07:00 -0400
Date: Fri, 18 May 2012 09:08:29 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 0/3] gspca: kinect cleanup, ov534 port to control
 framework
Message-ID: <20120518090829.292bd671@tele>
In-Reply-To: <1337204566-2212-1-git-send-email-ospite@studenti.unina.it>
References: <1337204566-2212-1-git-send-email-ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 16 May 2012 23:42:43 +0200
Antonio Ospite <ospite@studenti.unina.it> wrote:

> The second patch removes the dependency between auto gain and auto white
> balance, I'd like to hear Jean-Francois on this, the webcam (the ov772x
> sensor) is able to set the two parameters independently and the user can
> see the difference of either, is there a reason why we were preventing
> the user from doing so before?

Hi Antonio,

I added this dependency by the git commit 2d19a2c1186d86e3
on Thu, 12 Nov 2009 (the original patch was done under mercurial).

Looking in my archives, I retrieved this mail I have sent to you,
Max Thrun, kaswy, baptiste_lemarie, Martin Drake and Jim Paris:

On Thu, 12 Nov 2009 13:24:43 +0100 I wrote:

> On Thu, 12 Nov 2009 11:13:32 +0100
> Antonio Ospite <ospite@studenti.unina.it> wrote:
> 
> > On Wed, 11 Nov 2009 19:13:51 -0500
> > Max Thrun <bear24rw@gmail.com> wrote:
> >   
> > > >   *I get a weird effect, something
> > > >   like a mosaic effect caused by a picture shift, at such high
> > > > frame rates (also at 640x480@60), I need to verify if it is my
> > > > usb host which is weak.*  
> 	[snip] 
> > Maybe the End Of Frame detection logic is still imperfect, but I have
> > to admit I haven't looked at it lately.
> > You are heading to face/object tracking, aren't you? Very interesting.  
> 
> When adding the ov965x, I removed the check of the image size. May you
> try to set it back? (sorry, I have no patch - the check must be done
> at 2 places, just before adding the LAST_PACKET - the 2nd is enclosed in
> #if 0)
> 
> > > *  * Brightness control in guvcview doesn't seem to work.*
> > > 
> > > Confirmed. Easy fix though:  
> 	[snip]
> > Thanks, please send patches, they are so easy to create from Mercurial
> > that I don't think you have many excuses for not doing so :)  
> 
> Thanks also from me. I already did and uploaded the fix.
> 
> > > > *  * AWB doesn't have any effect?*
> > > >  
> > > I notice its effect if i start uvcview, enable auto gain, then
> > > enable awb.
> > >  
> > 
> > If there is a strict dependency between these two settings,
> > shouldn't the driver enforce it?  
> 	[snip]
> 
> It should! This asks for a change in the main gspca. I will try to do
> it quickly.

Otherwise, you are right, the ov7670 and ov7729 datasheets do not talk
about a possible AGC and AWB dependency...

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
