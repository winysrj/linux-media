Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1JoNi9-0006GZ-HY
	for linux-dvb@linuxtv.org; Tue, 22 Apr 2008 20:59:27 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Tue, 22 Apr 2008 20:54:58 +0200
References: <mailman.1.1206183601.26852.linux-dvb@linuxtv.org>
	<4801D77A.1070106@googlemail.com> <4803B5BB.5050208@googlemail.com>
In-Reply-To: <4803B5BB.5050208@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804222054.59221@orion.escape-edv.de>
Cc: Andrea <mariofutire@googlemail.com>
Subject: Re: [linux-dvb] [PATCH] 2/3: implement DMX_SET_BUFFER_SIZE for dvr
Reply-To: linux-dvb@linuxtv.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Andrea wrote:
> Andrea wrote:
> > Andrea wrote:
> >> Ok.
> >>
> >> I've changed the second patch to
> >> 1) allocate the new buffer before releasing the old one
> >> 2) use spin_[un]lock_irq
> >>
> >> 3) On top of that, I have rearranged the code of DMX_SET_BUFFER_SIZE 
> >> for the demux so that it does the same as the dvr (i.e. allocate the 
> >> new buffer before releasing the old one). I think it is a good idea 
> >> that 2 very similar functions are implemented in the same way. (if you 
> >> don't agree, or if you think a 3rd separate patch for this point is a 
> >> better idea, let me know.)
> >>
> >> PS: Both patches 1/3 and 2/3 are against a clean v4l-dvb tree. I do 
> >> not know how to generate incremental patch for 2/3.
> >>
> >> Let me know what you think about that.
> >>
> >> Andrea
> > 
> > I've fixed the patch to pass the "make checkpatch" check.
> > 
> > Andrea
> 
> Implementation of DMX_SET_BUFFER_SIZE for dvr.
> Synchronization of the code of DMX_SET_BUFFER_SIZE for demux and dvr.
> 
> Signed-off-by: Andrea Odetti <mariofutire@gmail.com>

Committed to HG. Thanks.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
