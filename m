Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:57043 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935581AbZLGUzT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2009 15:55:19 -0500
Received: by ey-out-2122.google.com with SMTP id d26so1231830eyd.19
        for <linux-media@vger.kernel.org>; Mon, 07 Dec 2009 12:55:25 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Marcelo Blanes <marcelo_blanes@yahoo.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: New DibCom based ISDB-T device
Date: Mon, 7 Dec 2009 21:55:21 +0100
References: <4B02B3B3.5050502@redhat.com> <alpine.LRH.2.00.0912071248380.13793@pub6.ifh.de> <387457.1542.qm@web54203.mail.re2.yahoo.com>
In-Reply-To: <387457.1542.qm@web54203.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912072155.21588.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 07 December 2009 21:25:25 Marcelo Blanes wrote:
> Hi Patrick,
> 
> Ok I can test. Should I replace only the file dib8000.c or update the
>  entire linuxtv project?

Yes, please use the v4l-dvb repository from 

http://linuxtv.org/hg/~pb/v4l-dvb/

not only the dib8000.c

PS: Please, don't chop off mailing lists when replying to a message received by 
one, You never know if someone else is following and this one may have the 
same questions as you.

-- 
Patrick 
http://www.kernellabs.com/
