Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:35831 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481AbZJEKEj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2009 06:04:39 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1031524fge.1
        for <linux-media@vger.kernel.org>; Mon, 05 Oct 2009 03:02:51 -0700 (PDT)
Date: Mon, 5 Oct 2009 13:02:48 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Andy Walls <awalls@radix.net>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>, hverkuil@xs4all.nl
Subject: Re: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV
	M116 for newer kernels
Message-ID: <20091005100248.GA15806@moon>
References: <1254584660.3169.25.camel@palomino.walls.org> <20091004222347.GA31609@moon> <1254707677.9896.10.camel@palomino.walls.org> <20091005085031.GA17431@moon> <20091005110402.059e9830@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005110402.059e9830@hyperion.delvare>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 05, 2009 at 11:04:02AM +0200, Jean Delvare wrote:
> On Mon, 5 Oct 2009 11:50:31 +0300, Aleksandr V. Piskunov wrote:
> > > Try:
> > > 
> > > # modprobe ivtv newi2c=1
> > > 
> > > to see if that works first. 
> > > 
> > 
> > udelay=10, newi2c=0  => BAD
> > udelay=10, newi2c=1  => BAD
> > udelay=5,  newi2c=0  => OK
> > udelay=5,  newi2c=1  => BAD
> 
> The udelay value is only used by i2c-algo-bit, not newi2c, so the last
> test was not needed.
> 

Yup, also tried udelay=4, IR controller handles it without problems,
though cx25840 and xc2028 doesn't seem to like the 125 KHz frequency,
refusing to communicate. xc2028 even stopped responding, requiring a cold
reboot.

So for M116 board, the most stable combination seems to be 100 KHz i2c bus
and 150ms polling delay (up from 100 default). With this combination
I can quickly press 1234567890 on remote and driver gets the combination
without any losses.
