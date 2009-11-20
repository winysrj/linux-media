Return-path: <linux-media-owner@vger.kernel.org>
Received: from 78.218.95.91.static.ter-s.siw.siwnet.net ([91.95.218.78]:37074
	"EHLO alefors.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbZKTNo7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 08:44:59 -0500
Received: from TERMINAL1 ([10.0.0.1]:48909)
	by alefors.se with [XMail 1.26 ESMTP Server]
	id <S5FF> for <linux-media@vger.kernel.org> from <magnus@alefors.se>;
	Fri, 20 Nov 2009 14:45:02 +0100
From: =?iso-8859-1?Q?Magnus_H=F6rlin?= <magnus@alefors.se>
To: <linux-media@vger.kernel.org>
Subject: SV: SV: [linux-dvb] NOVA-TD exeriences?
Date: Fri, 20 Nov 2009 14:45:01 +0100
Message-ID: <003401ca69e7$a8e7dd10$9b65a8c0@Sensysserver.local>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
In-Reply-To: <4B0694F7.7070604@stud.uni-hannover.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>  >
>  > Hi again. Just got my two new NOVA-TD's and at a first glance they
> seemed to
>  > perform well. Closer inspections however revealed that I see exactly
> the same
>  > issues as Soeren. Watching live TV with VDR on one adaptor while
> constantly
>  > retuning the other one using:
>  > while true;do tzap -x svt1;done
>  > gives a short glitch in the VDR stream on almost every tzap. Another
> 100EUR down
>  > the drain. I'll probably buy four NOVA-T's instead just like I
> planned to at
>  > first.
>  >
>  > /Magnus H
> 
> Slowly, slowly. Magnus, you want to support dibcom with another 100EUR for
> there poor performance in fixing the firmware?
> Please test my patches, the nova-td is running fine with these patches,
> at least for me.
> 
> Patrick, any progress here? Will dibcom fix the firmware, or will you
> integrate the
> patches? Or what can I do to go on?
> 
> Regards,
> Soeren
> 
> 

Thanks Soeren, maybe I jumped to the wrong conclusions here. I actually
thought this came down to bad hardware design instead of a driver/firmware
issue. Unfortunately your patches made no difference here but I won't give
up that easily. If they made your problems disapperar there should be hope
for me too and I'll be glad to help in the development. I can live with the
glitches in the mean time if there's hope for improvement since I mostly
watch DVB-S these days. I'm running the stock Ubuntu Karmic 2.6.31 kernel
and standard linuxtv drivers from hg. I also have four TT S2-1600 cards in
there.
/Magnus


