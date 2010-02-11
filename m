Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:55948 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756843Ab0BKTcn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 14:32:43 -0500
Received: from kabelnet-194-138.juropnet.hu ([91.147.194.138])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1Nfej9-0005pp-Qt
	for linux-media@vger.kernel.org; Thu, 11 Feb 2010 20:30:02 +0100
Message-ID: <4B745C18.2060908@mailbox.hu>
Date: Thu, 11 Feb 2010 20:35:52 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: DTV2000 H Plus issues
References: <4B3F6FE0.4040307@internode.on.net> <4B3F7B0D.4030601@mailbox.hu>	 <4B405381.9090407@internode.on.net> <4B421BCB.6050909@mailbox.hu>	 <4B4294FE.8000309@internode.on.net> <4B463AC6.2000901@mailbox.hu>	 <4B719CD0.6060804@mailbox.hu> <4B745781.2020408@mailbox.hu> <829197381002111121g5244471bj148d38aa8958800c@mail.gmail.com>
In-Reply-To: <829197381002111121g5244471bj148d38aa8958800c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/11/2010 08:21 PM, Devin Heitmueller wrote:

> Is the DTV7 support actually tested?  Or are you just blindly adding
> the code in the hope that it works?  I'm just asking because the last
> time I spoke to you, you actually didn't have access to a DVB-T signal
> source.

Hi! It is indeed not tested yet, and the other DTV modes are not
either. Is there anything that needs to be done additionally to make
the DTV7 mode work, other than the already added different frequency
offset ((-7000000/2)+1250000=-2250000), firmware type (DTV7), and
video standard (XC4000_DTV7) ?

> Also, I'm not sure I'm comfortable with the way the mutex is
> implemented here.  Is this logic copied from some other driver (and if
> so, which one), or did you come up with it yourself?

The mutex idea is from the XC3028 driver. Since the code is organized
differently there, it is not implemented exactly the same way, but it
is similar.
