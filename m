Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54928 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab1KUXSt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 18:18:49 -0500
Received: by ywt32 with SMTP id 32so5267824ywt.19
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 15:18:48 -0800 (PST)
Date: Mon, 21 Nov 2011 20:24:21 -0300
From: Ezequiel <elezegarcia@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org, hdegoede@redhat.com,
	ospite@studenti.unina.it
Subject: Re: Cleanup proposal for media/gspca
Message-ID: <20111121232421.GA2575@devel2>
References: <20111116013445.GA5273@localhost>
 <CALF0-+V+rEYi1of3jUGeVZsF2Ms215k0_CQjJx0qnPDUuC1BQQ@mail.gmail.com>
 <20111117110716.6343d46c@tele>
 <20111119185950.GB3048@localhost>
 <20111120082429.06ad5a32@tele>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111120082429.06ad5a32@tele>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 20, 2011 at 08:24:29AM +0100, Jean-Francois Moine wrote:
> 
> Hi Ezequiel,
> 
> It is not a minor patch, but maybe you don't know about object
> programming.
> 
> As it is defined, a gspca device _is_ a video device, as a gspca
> subdriver is a gspca device, and as a video device is a device: each
> lower structure is contained in a higher one.
> 
> Your patch defines the gspca structure as a separate entity which is
> somewhat related to a video device by two reverse pointers. It
> complexifies the structure accesses, adds more code and hides the
> nature of a gspca device.
> 

Hi Jef, 

Thanks for the explanation, I have things much clear now.
I didn't realize linux coding style enforces so explicitly OOP.

I based my patch on tm6000 driver and your
previous mail about the -supposedly- ugly cast:

  gspca_dev = (struct gspca_dev *) video_devdata(file);

Now it doesn't seems so ugly, I guess I went too far.
Still, maybe the 'container_of' trick could make thins
easier to understand.

Thanks again for your patience,
Ezequiel.

