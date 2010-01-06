Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52476 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755234Ab0AFBvx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jan 2010 20:51:53 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: linux-media@vger.kernel.org
Subject: Re: av7110 error reporting
Date: Wed, 6 Jan 2010 02:44:39 +0100
References: <4B3BC2F2.30806@dommel.be>
In-Reply-To: <4B3BC2F2.30806@dommel.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001060244.42935@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Johan wrote:
> I need some guidance on error messages..
> 
> The machine receives these messages in the systemlog (dmesg)
> 
> [ 7673.168026] dvb-ttpci: StartHWFilter error  buf 0b07 0010 07e9 b96a  
> ret 0  handle ffff
> [ 7674.192025] dvb-ttpci: StartHWFilter error  buf 0b07 0010 07ee b96a  
> ret 0  handle ffff
> [ 7675.224025] dvb-ttpci: StartHWFilter error  buf 0b07 0010 07f3 b96a  
> ret 0  handle ffff
> [ 7676.248128] dvb-ttpci: StartHWFilter error  buf 0b07 0010 07f9 b96a  
> ret 0  handle ffff
> [ 7677.280026] dvb-ttpci: StartHWFilter error  buf 0b07 0010 07fd b96a  
> ret 0  handle ffff
> [ 7678.312025] dvb-ttpci: StartHWFilter error  buf 0b07 0010 0803 b96a  
> ret 0  handle ffff
> 
> These start as soon as I view or record a channel, and obviously fills 
> up the log quickly.
> 
> I believe the code that generates these messages is at the bottom of 
> this message (part of av7110.c). This code was introduced in 2005 to 
> improve error reporting.

True.

> Currently I run today's v4l-dvb (using a hg update), and kernel 
> 2.6.31-16. (Ubuntu), however the issue occurred in older combinations as 
> well (over a year ago), so it is not introduced by the last kernels or 
> DVB driverset.
>
> The message seems to be triggered by the variable "handle" being larger 
> then 32. On my system it always reports ffff.

Handle == ffff means that the av7110 was not able to create a new filter
entry. This will happen if there are already 32 active filters.

Does it happen for all channels, or only for a specific one?
If the latter is true: Which channel is causing the problem?
Does it have a large number of audio pids?

> Am I looking at faulty hardware, or can I resolve this issue more 
> elegant than just disabling the fault report?
> (keep in mind that I do not have a programming/coding background)

You may disable the warning, but be warned that some parts of the data
will not be recorded due to missing filter entries...

Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
