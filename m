Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o6BGs88L022596
	for <video4linux-list@redhat.com>; Sun, 11 Jul 2010 12:54:08 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id o6BGruYp007357
	for <video4linux-list@redhat.com>; Sun, 11 Jul 2010 12:53:57 -0400
Date: Sun, 11 Jul 2010 18:53:05 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Roger Oberholtzer <roger@opq.se>
Subject: Re: SUGGESTION FOR A Linux based Card
Message-ID: <20100711165305.GA2547@minime.bse>
References: <AANLkTim5LXb__zh-N2pumq7nfSDlqnwW8RDrEw47DErd@mail.gmail.com>
	<000501cb1ed4$f45da930$dd18fb90$@com>
	<1278656777.18926.2.camel@acme.pacific>
	<000001cb1f84$0feb8af0$2fc2a0d0$@com>
	<1278712488.24682.6.camel@manta.site>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1278712488.24682.6.camel@manta.site>
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Fri, Jul 09, 2010 at 11:54:48PM +0200, Roger Oberholtzer wrote:
> BT878 is not lower quality (in my
> opinion when using these cards in systems to capture images for
> high-speed image processing).

The BT878 has an 8 bit ADC with gain controlled so that the back porch
samples as 0x38. The successor CX23880 already uses a 10 bit ADC.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
