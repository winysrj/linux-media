Return-path: <linux-media-owner@vger.kernel.org>
Received: from deliverator5.ecc.gatech.edu ([130.207.185.175]:35517 "EHLO
	deliverator5.ecc.gatech.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753676AbZFHKbD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2009 06:31:03 -0400
Received: from deliverator5.ecc.gatech.edu (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id 251881800E7
	for <linux-media@vger.kernel.org>; Mon,  8 Jun 2009 06:31:05 -0400 (EDT)
Received: from mail7.gatech.edu (bigip.ecc.gatech.edu [130.207.185.140])
	by deliverator5.ecc.gatech.edu (Postfix) with ESMTP id 9A8661800E2
	for <linux-media@vger.kernel.org>; Mon,  8 Jun 2009 06:31:04 -0400 (EDT)
Received: from [192.168.0.131] (bigip.ecc.gatech.edu [130.207.185.140])
	(Authenticated sender: gtg131s)
	by mail7.gatech.edu (Postfix) with ESMTP id 744362C8939
	for <linux-media@vger.kernel.org>; Mon,  8 Jun 2009 06:31:04 -0400 (EDT)
Message-ID: <4A2CE866.4010602@gatech.edu>
Date: Mon, 08 Jun 2009 06:31:02 -0400
From: David Ward <david.ward@gatech.edu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: cx18, s5h1409: chronic bit errors, only under Linux
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a Hauppauge WinTV-HVR-1600 that I am using to capture ATSC and 
clear QAM programming from cable television (Comcast of Chattanooga).  
This card uses the cx18 and s5h1409 kernel modules.

There are frequent bursts of bit errors occurring every few seconds in 
the incoming transport stream, when I have the card tuned under Linux.  
This causes artifacts in the received video as well as skipping in the 
received audio, to the point that it is practically unwatchable.  
However, under Windows on the same system/capture card, I can tune to 
the same programs with nearly perfect reception (no bit errors).  Also 
these programs appear on my TV with great quality as well.  The problem 
is happening on all of several different frequencies/programs that I 
have tried, although it is more pronounced on some programs 
(particularly ATSC) than others.

I have tried the latest v4l-dvb development sources under both kernel 
2.6.24 and kernel 2.6.29, and additionally I have tried to use the 
unmodified v4l-dvb from kernel 2.6.29.  Additionally, I have tried both 
the recommended cx23418 firmware from linuxtv.org, as well as the newer 
firmware provided by latest the Hauppauge drivers for Windows (which I 
am using successfully under Windows).  Unfortunately they all produce 
the same results.

I primarily use MythTV to capture the programs to a file, and the 
resulting file exhibits these problems.  However, I can also see the bit 
errors when I simply use the 'azap' application to tune the card 
directly (and also read the dvr0 device into a file).  The BER and UNC 
values reported by 'azap' are non-zero approximately one out of every 
five samples; then they are usually around 0x200, though this varies.  
The BER and UNC values are almost always identical, i.e., no error 
correction is taking place, only error detection.  Additionally I am not 
seeing any TS continuity or TEI flag errors, as detectable in the system 
log with the latest changeset.

I have tried to rule out other possible causes such as a weak input 
signal (by hooking the capture card directly to the household cable 
television input, bypassing all coaxial splitters) and system-specific 
issues (by trying this on three different systems).  However, to me it 
seems that the problem must be originating from an issue in the kernel 
modules for this card.

I understand that having some errors in the transport stream is 
unavoidable, and I have tried postprocessing with an application such as 
Project-X.  However, it does not magically take care of this -- the 
length of the video is reduced by about 20% and the resulting video 
jumps around constantly.

Please let me know how I should proceed in solving this.  I would be 
happy to provide samples of captured video, results from new tests, etc.

Thanks,

David Ward
