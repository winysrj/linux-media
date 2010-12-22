Return-path: <mchehab@gaivota>
Received: from smtp5-g21.free.fr ([212.27.42.5]:54262 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab0LVIpu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 03:45:50 -0500
Date: Wed, 22 Dec 2010 09:47:52 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Sudhindra Nayak <sudhindra.nayak@gmail.com>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: Quickcam express: Not able to capture video
Message-ID: <20101222094752.0802a578@tele>
In-Reply-To: <AANLkTikjOG14Db=S3Dk6AC53zTpv=fyY4X+HtC16sa_+@mail.gmail.com>
References: <AANLkTinwrr=vphwVq+dSi2ceL2+qBG_-GMGZHHYujYW4@mail.gmail.com>
	<AANLkTikjOG14Db=S3Dk6AC53zTpv=fyY4X+HtC16sa_+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wed, 22 Dec 2010 10:45:14 +0530
Sudhindra Nayak <sudhindra.nayak@gmail.com> wrote:

> Hi all,
> 
> I'm using a 'Logitech Quickcam Express' (046d:0840) camera to capture
> video. I'm using the STV06xx driver for this camera. I'm using a v4l2
> example code as my application along with the above mentioned driver.
	[snip]
> When I run the application, the kernel crashes. I'm running the
> application on the AT91 linux4sam kernel running on an
> AT91SAM9G45-EKES board. I've included the error messages below:
> 
> gspca: [a.out] open
> gspca: frame alloc frsz: 106560
> gspca: reqbufs st:0 c:4
	[snip]
> gspca: packet [0] o:0 l:847
> STV06xx: Packet of length 0 arrived
> gspca: packet [1] o:1023 l:63
> STV06xx: Packet of length 1023 arrived
> Unable to handle kernel NULL pointer dereference at virtual address
> 00000040 pgd = c0004000
> [00000040] *pgd=00000000
> Internal error: Oops: 17 [#1]
> Modules linked in:
> CPU: 0    Not tainted  (2.6.30 #17)
> PC is at stv06xx_pkt_scan+0x3c/0x1e0
> LR is at stv06xx_pkt_scan+0x20/0x1e0
	[snip]
> Any suggestions??

Hi,

(do not use the mailing list at redhat.com. The new one is linux-media
- see Cc:)

Your kernel is rather old. If you cannot change to a newer one (at
least 2.6.32 or, better, 2.6.34), may you get and try the last gspca
test version from my web page (see below)?

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
