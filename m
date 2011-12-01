Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41996 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab1LAP5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 10:57:36 -0500
From: "Hamad Kadmany" <hkadmany@codeaurora.org>
To: "'Andreas Oberritter'" <obi@linuxtv.org>
Cc: <linux-media@vger.kernel.org>
References: <001101ccae6d$9900b350$cb0219f0$@org> <4ED782E2.9060004@linuxtv.org> <000301ccb030$dfaa71f0$9eff55d0$@org> <4ED787D5.203@linuxtv.org> <000401ccb034$a8ec2ce0$fac486a0$@org> <4ED78F85.7020005@linuxtv.org>
In-Reply-To: <4ED78F85.7020005@linuxtv.org>
Subject: RE: Support for multiple section feeds with same PIDs
Date: Thu, 1 Dec 2011 17:57:37 +0200
Message-ID: <000501ccb041$f3f08210$dbd18630$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Andreas
 
> On 01.12.2011 16:30, Andreas Oberritter wrote:

> Yes. Feel free to enhance the demux API to your needs in order to fully
> support the features of your hardware.

I have another question in that regard: Actually, multiple filter with same
PID is assumed to be possible in case we have one filter for TS packets (for
DVR device) and another for video PES (for playback). So it seems there's
such assumption in this regard but not for sections. Is my understanding
correct?

Regards,
Hamad

