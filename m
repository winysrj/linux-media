Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1JoNi8-0006GQ-SS
	for linux-dvb@linuxtv.org; Tue, 22 Apr 2008 20:59:28 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Tue, 22 Apr 2008 20:54:15 +0200
References: <mailman.1.1206183601.26852.linux-dvb@linuxtv.org>
	<4801D735.6040905@googlemail.com> <4803B5B0.8070803@googlemail.com>
In-Reply-To: <4803B5B0.8070803@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804222054.15360@orion.escape-edv.de>
Cc: Andrea <mariofutire@googlemail.com>
Subject: Re: [linux-dvb] [PATCH] 1/3: BUG FIX in dvb_ringbuffer_flush
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
> >> I've just added a comment to patch 1/3.
> >> I post it here again.
> >>
> >> This patch fixes the bug in DMX_SET_BUFFER_SIZE for the demux.
> >> Basically it resets read and write pointers to 0 in case they are 
> >> beyond the new size of the buffer.
> >>
> >> In the next patch (2/3) I rewrite this function to behave the same as 
> >> the new DMX_SET_BUFFER_SIZE for the dvr.
> >> I thought it is a good idea for the 2 very similar ioctl to be 
> >> implemented in the same way.
> >>
> >> Andrea
> > 
> > I've fixed some formatting errors reported by "make checkpatch".
> > 
> > Andrea
> 
> 
> This patch fixes a bug in DMX_SET_BUFFER_SIZE in case the buffer shrinks.
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
