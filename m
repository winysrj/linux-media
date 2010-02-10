Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062Ab0BJWDi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 17:03:38 -0500
Message-ID: <4B732D33.4010503@redhat.com>
Date: Wed, 10 Feb 2010 20:03:31 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Carlos Jenkins <carlos.jenkins.perez@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Want to help in MSI TV VOX USB 2.0
References: <f535cc5a1002100021u37bf47a5y50a0a90873a082e2@mail.gmail.com> 	<f535cc5a1002101058h4d8e4bd1p6fd03abd4f724f52@mail.gmail.com> 	<f535cc5a1002101101k709bbe9bv504cf33fab14dedc@mail.gmail.com> 	<f535cc5a1002101102w146050c5v91ddc6ec86542153@mail.gmail.com> 	<4B731A10.9000108@redhat.com> <f535cc5a1002101304j76efd298p7f8040511ff2b2e1@mail.gmail.com>
In-Reply-To: <f535cc5a1002101304j76efd298p7f8040511ff2b2e1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Carlos Jenkins wrote:
> As noted on the first mail, NTSC, same as US
> (http://es.wikipedia.org/wiki/Archivo:NTSC-PAL-SECAM.svg)
> 
>> So, you may need to adjust the parameters bellow. For NTSC and 6 MHz channels, the command syntax
>> is:
>>
>> mplayer -tv driver=v4l2:device=/dev/video0:norm=PAL-M:chanlist=us-bcast tv://
> 
> PAL-M? It should not be NTSC something?  Anyway, I'll try that later.

Sorry, it should be NTSC. I forgot to replace from my setup.

-- 

Cheers,
Mauro
