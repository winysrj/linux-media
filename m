Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1LHph9-0005vM-Nj
	for linux-dvb@linuxtv.org; Wed, 31 Dec 2008 02:16:24 +0100
Received: by qw-out-2122.google.com with SMTP id 9so2644659qwb.17
	for <linux-dvb@linuxtv.org>; Tue, 30 Dec 2008 17:16:19 -0800 (PST)
Message-ID: <412bdbff0812301716r3a9d069ax2c4438fdf5c5d9e7@mail.gmail.com>
Date: Tue, 30 Dec 2008 20:16:19 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: sonofzev@iinet.net.au
In-Reply-To: <59495.1230686092@iinet.net.au>
MIME-Version: 1.0
Content-Disposition: inline
References: <59495.1230686092@iinet.net.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVICO dual express incorrect readback of firmware
	message (2.6.28 kernel)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Tue, Dec 30, 2008 at 8:14 PM, sonofzev@iinet.net.au
<sonofzev@iinet.net.au> wrote:
>
> oops.. didn't finish the last sentence.. at the time I checked dmesg this
> morning, it was displaying this behaviour but nothing was being recorded or
> watched at that moment in time.
>
> In the short term is this something that might be worked around by going
> back to hg drivers, or would you prefer I stick with the in-kernel ones, to
> help work out what is happening.

Are you saying you upgrade to 2.6.28 from the hg?  I would be very
surprised if this issue wasn't in the latest hg as well.

I would upgrade to the latest hg, and then debug it from there.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
