Return-path: <linux-media-owner@vger.kernel.org>
Received: from rosa.stappers.it ([77.72.145.78]:50594 "EHLO rosa.stappers.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaBHMwK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Feb 2014 07:52:10 -0500
Date: Sat, 8 Feb 2014 13:45:25 +0100
From: Geert Stappers <stappers@stappers.it>
To: linux-media@vger.kernel.org
Subject: Re: Where to find the "em28xx log parser"
Message-ID: <20140208124525.GK14208@rosa.stappers.it>
References: <1391841249.2141.25.camel@fujitsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391841249.2141.25.camel@fujitsu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 08, 2014 at 07:34:09AM +0100, mjs wrote:
> Hello,
> 
> I'm trying to make a patch for a :zolid usb dvb-t receiver.
> Like to try the "em28xx log parser" to decode the usbsnoop output.
> According to:
> http://www.linuxtv.org/wiki/index.php/Bus_snooping/sniffing
> it has been out there at least once but so far no luck to find it.
> 
> So, the program or a link where to find would help.


It is the v4l-utils git repository


    git clone git://linuxtv.org/v4l-utils.git
    cd v4l-utils


Then a

    head -n 25 contrib/em28xx/parse_em28xx.pl


will reveal among other lines

    #
    # To use it, you may modprobe em28xx with reg_debug=1, and do:
    # dmesg | ./parse_em28xx.pl
    #


But that will only work
after you have set execute permissons the perl script.


Cheers
Geert Stappers

