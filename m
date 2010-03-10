Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:45714 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847Ab0CJXMP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Mar 2010 18:12:15 -0500
Received: from kabelnet-199-221.juropnet.hu ([91.147.199.221])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1NpV4T-0006hq-MB
	for linux-media@vger.kernel.org; Thu, 11 Mar 2010 00:12:13 +0100
Message-ID: <4B98287B.4030506@mailbox.hu>
Date: Thu, 11 Mar 2010 00:17:15 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] DTV2000 H Plus issues
References: <4B3F6FE0.4040307@internode.on.net> <4B3F7B0D.4030601@mailbox.hu>	 <4B405381.9090407@internode.on.net> <4B421BCB.6050909@mailbox.hu>	 <4B4294FE.8000309@internode.on.net> <4B463AC6.2000901@mailbox.hu>	 <4B719CD0.6060804@mailbox.hu> <4B745781.2020408@mailbox.hu>	 <4B7C303B.2040807@mailbox.hu> <4B7C80F5.5060405@redhat.com> <829197381002171559k10b692dcu99a3adc2f613437f@mail.gmail.com> <4B7EEC92.1090004@mailbox.hu>
In-Reply-To: <4B7EEC92.1090004@mailbox.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have finally received some feedback on DVB-T, and it reportedly works,
although with a minor bug: it was necessary to use the "cable" connector
instead of the "antenna" one. There is an updated patch at the web page
http://www.sharemation.com/IstvanV/v4l/xc4000.html that attempts to
correct this problem. It also includes a few CX88 changes that are not
related to adding support for XC4000 based cards, and could possibly be
released as separate patches:
 - implements a "sharpness" control using the CX2388x peaking filter
   and changing the notch filter
 - in two places (cx88-core.c and cx88-video.c) code that checked for
   CX88_VMUX_TELEVISION did not also check for CX88_VMUX_CABLE; this
   was the reason why selecting the audio standard did not work for the
   cable input
 - in cx88-mpeg.c, there was code that set core->input to CX88_VMUX_DVB;
   this does not seem to make sense, since core->input is an index to an
   array (core->board.input), while the CX88_VMUX_* values are not
   intended to be used as indexes, but rather values of the 'type'
   member of struct cx88_input. But it is also not obvious if this has
   any actual effect other than what is reported as the current input
   when queried by an application. In any case, I changed the code to
   search for an input of type CX88_VMUX_DVB, or set the input to 0 if
   it is not found
