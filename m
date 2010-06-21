Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.newportit.com ([65.99.194.148]:35318 "EHLO wapdot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756951Ab0FUPsQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 11:48:16 -0400
Subject: Re: How to use aux input on ATI TV Wonder 600 USB?
From: Steve Freitas <sflist@ihonk.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <AANLkTil3akZ0OAahETLyHv9Wc0eG3UrEz3RAmsg7GSlU@mail.gmail.com>
References: <1277132966.27109.24.camel@phat>
	 <AANLkTil3akZ0OAahETLyHv9Wc0eG3UrEz3RAmsg7GSlU@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 08:48:13 -0700
Message-ID: <1277135293.27109.32.camel@phat>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-06-21 at 11:22 -0400, Devin Heitmueller wrote:
> On Mon, Jun 21, 2010 at 11:09 AM, Steve Freitas <sflist@ihonk.com> wrote:
> > Hi all,
> >
> > I have an ATI TV Wonder 600 USB and have successfully used it for its
> > DVB features, thanks to the work of many of you on this list. However,
> > this device also has an auxiliary s-video/composite input[1] which I'd
> > like to use in VLC, and I can't figure out how. Is there any capability
> > in the driver to switch to that?
> 
> Yes, it's fully supported.  But bear in mind it's an analog input, so
> you need to use a V4L application as opposed to something designed for
> DVB.  Once you use an analog app (such as tvtime), just toggle over to
> input 1 for composite or input 2 for S-Video (input zero is the analog
> tuner input).

That was just the help I needed. Thanks! Would it be appropriate for me
to add that input number information to the wiki page[1]?

Steve

[1] http://www.linuxtv.org/wiki/index.php/ATI/AMD_TV_Wonder_HD_600_USB

