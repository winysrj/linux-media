Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:52302 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZKGLaH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 06:30:07 -0500
Message-ID: <4AF55A40.4070109@freemail.hu>
Date: Sat, 07 Nov 2009 12:30:08 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca pac7302: simplify init sequence
References: <4AF540BF.8000905@freemail.hu> <20091107115411.51d213e3@tele>
In-Reply-To: <20091107115411.51d213e3@tele>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jef,
Jean-Francois Moine wrote:
> On Sat, 07 Nov 2009 10:41:19 +0100
> Németh Márton <nm127@freemail.hu> wrote:
> 
>> The init sequence contains register writes which are overwritten
>> later. Remove these redundant writes from the init sequence.
> 	[snip]
> 
> Hello Németh,
> 
> I am not sure it is a good idea. The webcam may need some
> initialization values to start working before the control are applied.
> Also, if any problem occurs, it is not easy to find the differences
> with the ms-win traces.

OK, maybe this change was made too early. I also reverted this change and
I'll send my next patch without modifying the init sequence.

Regards,

	Márton Németh

