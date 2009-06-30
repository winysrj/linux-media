Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta05.westchester.pa.mail.comcast.net ([76.96.62.48]:37930
	"EHLO QMTA05.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754917AbZF3TsB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 15:48:01 -0400
From: George Czerw <gczerw@comcast.net>
Reply-To: gczerw@comcast.net
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [linux-dvb] Hauppauge HVR-1800 not working at all
Date: Tue, 30 Jun 2009 15:48:02 -0400
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <200906301301.04604.gczerw@comcast.net> <4A4A64F9.6070807@linuxtv.org> <829197380906301227q52e7b215p359adaa3206dba79@mail.gmail.com>
In-Reply-To: <829197380906301227q52e7b215p359adaa3206dba79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906301548.02518.gczerw@comcast.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 30 June 2009 15:27:30 Devin Heitmueller wrote:
> On Tue, Jun 30, 2009 at 3:18 PM, Michael Krufky<mkrufky@linuxtv.org> wrote:
> >> Mike, thanks for the reply.  Two questions...
> >>
> >> 1.  What do you mean by "spigots"?
> >>
> >> 2.  By the tuner module, do you mean the cx23885??
> >>
> >> Output of lsmod shows that cx25840, cx23885 & cx2341x are loaded
> >>
> >> cx25840                27856  0
> >>         cx23885                85552  0
> >>               cx2341x                12800  1 cx23885
> >>                     videobuf_dma_sg        12160  1 cx23885
> >>                           videobuf_dvb            6848  1 cx23885
> >>                                 dvb_core               86112  1
> >> videobuf_dvb videobuf_core          17888  3
> >> cx23885,videobuf_dma_sg,videobuf_dvb              v4l2_common
> >>  16220  3 cx25840,cx23885,cx2341x                           videodev
> >>       40320  3 cx25840,cx23885,v4l2_common                      
> >> v4l1_compat 13440  1 videodev
> >>  btcx_risc               4772  1 cx23885
> >>       tveeprom               11872  1 cx23885
> >
> > Please, never remove cc from the public mailinglist.  (cc re-added)
> >
> > When I said 'tuner' module, I meant 'tuner' module :-P
> >
> > Hope this helps,
> >
> > Mike
>
> To clarify Mike's point, he means there is a module called "tuner"
> that you should see in the lsmod.  Also, when he refers to spigots, he
> is referring to the F-connectors on the edge card that you would
> connect the coax cable to.
>
> Devin

Devin, thanks for the reply.

Lsmod showed that "tuner" was NOT loaded (wonder why?), a "modprobe tuner" 
took care of that and now the HVR-1800 is displaying video perfectly and the 
tuning function works.  I guess that I'll have to add "tuner" into 
modprobe.preload.d????  Now if only I can get the sound functioning along with 
the video!

George

