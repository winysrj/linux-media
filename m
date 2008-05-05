Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m45F7GSU031204
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 11:07:16 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m45F6xZr016843
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 11:07:00 -0400
Date: Mon, 5 May 2008 17:06:33 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Arne Caspari <arne@unicap-imaging.org>
Message-ID: <20080505150632.GA955@daniel.bse>
References: <1209972947.7502.0.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209972947.7502.0.camel@localhost>
Cc: video4linux-list@redhat.com
Subject: Re: RAW/Bayer format FOURCCs
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Mon, May 05, 2008 at 09:35:47AM +0200, Arne Caspari wrote:
> I am looking for the correct FOURCC to use for a RAW Bayer format: RGGB
> 16 bit. 
> 
> In the v4l2 specification, there is V4L2_PIX_FMT_SBGGR8 ( 'BA81' ) for
> BGGR 8 bit and V4L2_PIX_FMT_SBGGR16 ( 'BA82' ) for BGGR 16 bit. I do not
> really see a pattern in the FOURCC assignment here. Does anybody know
> what the correct FOURCC should look like? 

There is no pattern.

The BA8x FourCCs were invented by Luca Risolia:
http://marc.info/?l=linux-video&m=108062090927323

The BYRx FourCCs are used by CineForm's products when they put raw
pictures into AVI and MOV. David Newman's post on dvinfo.net is probably
the source for the fourcc.org entries. Looking at CineForm's NEO player
I see up to BYR3. Some update logs on the CineForm website mention BYR4.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
