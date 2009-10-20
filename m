Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:49619 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbZJTNQo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 09:16:44 -0400
Date: Tue, 20 Oct 2009 15:16:42 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Romont Sylvain <psgman24@yahoo.fr>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	tskd2@yahoo.co.jp
Subject: Re: Re : ISDB-T tuner
In-Reply-To: <750990.6802.qm@web25608.mail.ukl.yahoo.com>
Message-ID: <alpine.LRH.1.10.0910201512430.24115@pub3.ifh.de>
References: <340263.68846.qm@web25604.mail.ukl.yahoo.com> <4ADD3341.3050202@yahoo.co.jp> <alpine.LRH.1.10.0910200935120.3543@pub2.ifh.de> <750990.6802.qm@web25608.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 20 Oct 2009, Romont Sylvain wrote:

> Dibcom's tuner is only working in brazil no?
> the Brazil's ISDB-T and Japanese one is not excatly same, no?

On the physical layer it is exactly the same. It is the content 
(video/audio/data inside the MPEG2 transport-stream) which differs in the 
two countries. This is typically not handled by the 'tuner', but by the 
'backend'.

This 'backend' is either another hardware chip or a software-stack. This 
is what has to be different between Japan and Brazil.

--

Patrick 
http://www.kernellabs.com/
