Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from u15184586.onlinehome-server.com ([82.165.244.70])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mark@metrofindings.com>) id 1KzhUd-0005MO-BP
	for linux-dvb@linuxtv.org; Tue, 11 Nov 2008 01:52:32 +0100
From: Mark Kimsal <mark@metrofindings.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
Date: Mon, 10 Nov 2008 19:51:53 -0500
References: <200810160925.51556.mark@metrofindings.com>
	<200810170957.39975.mark@metrofindings.com>
	<37219a840811081258t484f4bc8ib86111e080bff1e2@mail.gmail.com>
In-Reply-To: <37219a840811081258t484f4bc8ib86111e080bff1e2@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811101951.53108.mark@metrofindings.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add syntek corp device to au0828
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

On Saturday 08 November 08, Michael Krufky wrote:
> On Fri, Oct 17, 2008 at 8:57 AM, Mark Kimsal <mark@metrofindings.com> wrote:
> > On Thursday 16 October 2008 11:11:39 am you wrote:
> >> I thought this stick had an MT2130 inside -- looks like you've got
> >> another revision with a TDA18271... very interesting :-)
> >>
> It's definitely not a "woodbury", but if the woodbury configuration is
> working for you, then it could be similar.
>
> The really strange thing is that I have a device in my hand with usb
> ID 05e1:0400 .  I opened it up, and there is an mt2130 and an au8502.
>
> This is _not_ a tda18271c2 and an au8522.  So, the fact that the
> tda18271c2 + au8522 driver combination is working for you tells us
> that multiple configurations are out there that all have the same usb
> ID.
> Would it be possible for you to open up the device and take some
> hi-res digital photos?

I have updated the wiki with a hi-res photo.  I can e-mail an even higher 
resolution image off-list if it is required.  Contact my directly for shots 
of the back of the device (nothing interesting), my stock photos are twice as 
large as what's on the wiki.

http://linuxtv.org/wiki/index.php/Sabrent_TV-USBHD

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
