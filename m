Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-35-i3.italiaonline.it ([212.48.25.209]:40771 "EHLO
	libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751875AbbCVWhU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2015 18:37:20 -0400
Message-ID: <1260119380.6141581427063838962.JavaMail.httpd@webmail-52.iol.local>
Date: Sun, 22 Mar 2015 23:37:18 +0100 (CET)
From: "pier.cvn@libero.it" <pier.cvn@libero.it>
Reply-To: "pier.cvn@libero.it" <pier.cvn@libero.it>
To: linux-media@vger.kernel.org
Subject: DVB-T Receivers Latency
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I was wondering if anyone had any idea of how much latency a DVB-T receiver 
can add, in the path between radiofrequency and the MPEG-TS stream. I have 
100ms of unwanted latency I can't explain in an application I'm developing, so 
I was faulting either the tx modulator or the rx demodulator latency for it. In 
my specific case I'm using a 292e as receiver, that seems to have DSP filters 
in it, and could very well be the cause of this tenth of a second delay.

I was going to buy a couple more receivers to measure the differences, but I 
was wondering if anyone had any analytic input before wasting money that way.

Thank you.
