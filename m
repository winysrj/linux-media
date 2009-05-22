Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f103.google.com ([209.85.216.103]:45125 "EHLO
	mail-px0-f103.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZEVQ41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 12:56:27 -0400
Received: by pxi1 with SMTP id 1so1436161pxi.33
        for <linux-media@vger.kernel.org>; Fri, 22 May 2009 09:56:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d9def9db0905220936r6b37c7ferd7cefec0afc18ff0@mail.gmail.com>
References: <1243003530.24983.8.camel@pc67246619>
	 <829197380905220828i2b8cf7e4h6f067b996fd72fab@mail.gmail.com>
	 <d9def9db0905220936r6b37c7ferd7cefec0afc18ff0@mail.gmail.com>
Date: Fri, 22 May 2009 12:56:29 -0400
Message-ID: <829197380905220956q4f4d1376vd4c07e0f53e4f261@mail.gmail.com>
Subject: Re: Review of the Linux driver for the TerraTec Cinergy HTC USB XS HD
	stick
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Ad Denissen <ad.denissen@hccnet.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 22, 2009 at 12:36 PM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> You still mistake that the important drivers are not implemented in
> Kernelspace, because
> of that there will never be a _requirement_ to merge the chipdrivers
> in order to get it work.
> For example DVB-C/T, all control commands are sent to the frontend
> device node all those
> commands are intercepted at userlevel while still being compatible
> with legacy applications like
> kaffeine or dvbscan.
>
> regards,
> Markus

It wasn't really my intent to get into the details of your
implementation (kernel space versus user space).  The important
message is that the solution you are providing is a commercial, closed
source solution.  If that meets his needs, then great.  If Ad's goal
is to get support into the Linux mainline, then it needs to be both
open source and in the kernel.

Regards,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
