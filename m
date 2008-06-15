Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Sun, 15 Jun 2008 14:09:58 -0500
From: David Engel <david@istwok.net>
To: Steven Toth <stoth@linuxtv.org>
Message-ID: <20080615190958.GA6792@opus.istwok.net>
References: <20080613163914.GA31437@opus.istwok.net>
	<4852AB58.9010806@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4852AB58.9010806@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] A couple HVR-1800 questions
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

On Fri, Jun 13, 2008 at 01:16:08PM -0400, Steven Toth wrote:
> David Engel wrote:
>> First, what is the status of the analog capture capability?  My search
>> ...
>
> The analog encoder is running with the tree form linuxtv.org. It has  
> some cleanup video ioctl2 rework going on by another dev here, but it's  
> functional as is. It's usable today.

Thanks for the repsonse, Steven.

>> Second, as far as I can tell, the hardware can perform simultaneous
>> analog and digital captures.  Is that correct and, if so, does/will
>> the Linux driver support it?
>
> Yes and yes.
>
> Typically the analog video devices are exposed as /dev/video0 (analog  
> preview) /dev/video1 (encoder output) and /dev/dvb/... for the digital 
> side.

Excellent.

Regarding the encoder and preview devices, that's different than the
ivtv convention of using /dev/video(N) and and /dev/video(N+16).  Is
there a reason you did it differently and should it be standardized
across drivers?

David
-- 
David Engel
david@istwok.net

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
