Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta09.westchester.pa.mail.comcast.net ([76.96.62.96]:55500
	"EHLO QMTA09.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752939AbZF3U3H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 16:29:07 -0400
From: George Czerw <gczerw@comcast.net>
Reply-To: gczerw@comcast.net
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [linux-dvb] Hauppauge HVR-1800 not working at all
Date: Tue, 30 Jun 2009 16:29:09 -0400
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <200906301301.04604.gczerw@comcast.net> <200906301548.02518.gczerw@comcast.net> <829197380906301256w2f0a701ak2332d9ec2cfae35e@mail.gmail.com>
In-Reply-To: <829197380906301256w2f0a701ak2332d9ec2cfae35e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906301629.09142.gczerw@comcast.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 30 June 2009 15:56:08 Devin Heitmueller wrote:
> On Tue, Jun 30, 2009 at 3:48 PM, George Czerw<gczerw@comcast.net> wrote:
> > Devin, thanks for the reply.
> >
> > Lsmod showed that "tuner" was NOT loaded (wonder why?), a "modprobe
> > tuner" took care of that and now the HVR-1800 is displaying video
> > perfectly and the tuning function works.  I guess that I'll have to add
> > "tuner" into modprobe.preload.d????  Now if only I can get the sound
> > functioning along with the video!
> >
> > George
>
> Admittedly, I don't know why you would have to load the tuner module
> manually on the HVR-1800.  I haven't had to do this on other products?
>
> If you are doing raw video capture, then you need to manually tell
> applications where to find the ALSA device that provides the audio.
> If you're capturing via the MPEG encoder, then the audio will be
> embedded in the stream.
>
> Devin

Well a shutdown and restart reveals that "tuner" is not being loaded 
automagically, so I'll have to go the modprobe.preload.d route.

I found a cx88_alsa driver listed, but I'm not sure how to go about getting 
the system to use it.  I'll have to do some more research into this audio 
issue because it's way over my head.

