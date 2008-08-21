Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KWDBs-0005xG-3m
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 18:39:18 +0200
Received: by fg-out-1718.google.com with SMTP id e21so40590fga.25
	for <linux-dvb@linuxtv.org>; Thu, 21 Aug 2008 09:39:11 -0700 (PDT)
Message-ID: <37219a840808210939n1d9be3e0t2a976ff16d8b48c1@mail.gmail.com>
Date: Thu, 21 Aug 2008 12:39:11 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "gothic nafik" <nafik@nafik.cz>
In-Reply-To: <1219330331.15825.2.camel@dark>
MIME-Version: 1.0
Content-Disposition: inline
References: <1219330331.15825.2.camel@dark>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dib0700 and analog broadcasting
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

On Thu, Aug 21, 2008 at 10:52 AM, gothic nafik <nafik@nafik.cz> wrote:
>
> hi,
>
> i have problems with my tv tuner. It is hybrid (analog receiver, digital
> receiver, radio fm reciver) tv tuner with chipset dib7700. I had to hack
> dib0700 module and update a line with my product id and vendor id
> (because my hardware was not there). It is tv tuner in notebook Asus
> M51SN.
>
[snip]
>
> Digital tv is maybe working, I do not know, becasue in my region is not
> digital broadcasting yet. But I want to watch analog tv or listen to
> radio. And I am not sure, but I need device /dev/video or /dev/video0
> (/dev/radio is not created too) for watching analog broadcasting (module
> dib0700 did not create any /dev/video, just /dev/dvb/*)? Am I right?

The driver currently does not support analog video.

I am working on adding analog video support to the dvb-usb framework,
but it is far from ready, and lowest on my priority list.  The good
news is that I made some very nice progress last month, but I wouldn't
expect any kind of release for months.

Side note:  I said something very similar to the above last year.  I
made a lot of good rpogress recently, but I wont have time to get back
to it until a few weeks from now.

You should consider your device a digital-only tv stick for now, under Linux.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
