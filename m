Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:47678 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab1KTHYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 02:24:05 -0500
Date: Sun, 20 Nov 2011 08:24:29 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Ezequiel <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Cleanup proposal for media/gspca
Message-ID: <20111120082429.06ad5a32@tele>
In-Reply-To: <20111119185950.GB3048@localhost>
References: <20111116013445.GA5273@localhost>
	<CALF0-+V+rEYi1of3jUGeVZsF2Ms215k0_CQjJx0qnPDUuC1BQQ@mail.gmail.com>
	<20111117110716.6343d46c@tele>
	<20111119185950.GB3048@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 19 Nov 2011 15:59:50 -0300
Ezequiel <elezegarcia@gmail.com> wrote:

> Hi Jef,
> 
> I just sent a patch to linux-media for this little issue. 
> 
> I realize it is only a very minor patch, 
> so I am not sure If I am helping or just annoying the developers ;)
> 
> Anyway, if you could check the patch I would appreciate it. 
	[snip]
> Again, hope the patch helps, 

Hi Ezequiel,

It is not a minor patch, but maybe you don't know about object
programming.

As it is defined, a gspca device _is_ a video device, as a gspca
subdriver is a gspca device, and as a video device is a device: each
lower structure is contained in a higher one.

Your patch defines the gspca structure as a separate entity which is
somewhat related to a video device by two reverse pointers. It
complexifies the structure accesses, adds more code and hides the
nature of a gspca device.

No, your patch does not help...

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
