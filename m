Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:45607 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZCVJsb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2009 05:48:31 -0400
Date: Sun, 22 Mar 2009 10:45:54 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: "Trent Piepho" <xyzzy@speakeasy.org>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: qv4l2 (was [PATCH] LED control)
Message-ID: <20090322104554.5c56698e@free.fr>
In-Reply-To: <36896.62.70.2.252.1237279540.squirrel@webmail.xs4all.nl>
References: <36896.62.70.2.252.1237279540.squirrel@webmail.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 17 Mar 2009 09:45:40 +0100 (CET)
"Hans Verkuil" <hverkuil@xs4all.nl> wrote:
	[snip]
> > Actually, there are a few programs that can handle the webcam
> > parameters. In fact I know only 'v4l2-ctl': I did not succeeded to
> > compile qv4l2
> 
> What compile errors do you get?
> 
> If you do not have qt3 installed, then it will be interesting to see
> if you can compile the qv4l2 in my ~hverkuil/v4l-dvb-qv4l2 tree which
> is qt4. It still needs more cleanup and tweaking before I can merge
> that in the v4l-dvb tree, though.

Hello Hans,

Yes, I have qt4. I got your tree and the qv4l2 generation is OK.

I could change the controls of my webcam (but, indeed, the JPEG
parameters).

Little problem: if I directly do 'start capture', the program loops
displaying the single word: 'dqbuf'.

Otherwise, streaming works fine, but the CPU load is heavy: 85%
(vm: 40Mb) versus 60% with gtk+ (vm: 15Mb) and 8% with vlc (vm: 137Mb).

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
