Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:38696 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbZFZLtT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 07:49:19 -0400
Subject: Re: Bah!  How do I change channels?
From: Andy Walls <awalls@radix.net>
To: George Adams <g_adams27@hotmail.com>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>
References: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 07:50:01 -0400
Message-Id: <1246017001.4755.4.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-06-25 at 23:04 -0400, George Adams wrote:
> Having gotten my Pinnacle HDTV Pro Stick working again under some old
> v4l drivers, I'm now facing a much more mundane problem - I can't
> figure out how to use the command line to change the channel.
> 
> The video feed (a closed-circuit feed) that's coming to the card is
> over a coax cable, and is on (analog) channel 3.  My goal is to take
> the input and use Helix Encoder to produce RealVideo output that can
> be played using Real Player (yeah, not the ideal situation, but it's
> what we're using for now)
> 
> Helix Producer (unlike "mencoder/mplayer") doesn't have the ability to
> change the channel - it can only take whatever is coming over the
> channel that the Pinnacle device is currently tuned to.  Devin pointed
> me to the "v4lctl" command, but I'm not having any luck with it yet.  

I use either v4l2-ctl or ivtv-tune

$ ivtv-tune -d /dev/video0 -t us-bcast -c 3
/dev/video0: 61.250 MHz

$ v4l2-ctl -d /dev/video0 -f 61.250
Frequency set to 980 (61.250000 MHz)


Regards,
Andy


