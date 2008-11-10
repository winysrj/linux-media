Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from u15184586.onlinehome-server.com ([82.165.244.70])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mark@metrofindings.com>) id 1KzgMo-0000tw-Cf
	for linux-dvb@linuxtv.org; Tue, 11 Nov 2008 00:40:26 +0100
From: Mark Kimsal <mark@metrofindings.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
Date: Mon, 10 Nov 2008 18:39:41 -0500
References: <200810160925.51556.mark@metrofindings.com>
	<200810170957.39975.mark@metrofindings.com>
	<37219a840811081258t484f4bc8ib86111e080bff1e2@mail.gmail.com>
In-Reply-To: <37219a840811081258t484f4bc8ib86111e080bff1e2@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811101839.41841.mark@metrofindings.com>
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
> >> You say that ATSC works -- does it work on more than just one channel?
> >>  If ATSC works, then QAM should work as well.  NTSC is not yet
> >> supported in the Linux driver.
> >>
> >> Can you show me the dmesg output when the driver loads?  Also, can you
> >> give me the exact name of the device (from the retail package) ?
> >
> > Yes, more than one channel works.  I do see the module TDA18721 loaded
> > along with a couple other.  Again, I'm not 100% sure that this is the
> > woodbury, but it works.  I can scan channels, I've watched 4-5 stations. 
> > It seems to kernel oops every once in a while on very static-y stations.
>
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
>
> or, by some strange chance, the my2130 in your stick might be tuned to
> some default frequency that just happens to have channels.
>
> I asked you if you were able to receive multiple channels -- are they
> all on the same frequency, or are they on different frequencies?

I don't think they're all on the same frequency.  I'm not 100% sure of the 
terminology, but I ran scandvb and it locked on to about 6 local broadcast 
channels.  I'm fairly certain that they are different frequencies, but I 
don't have the channels conf file in front of my to say for certain.  How 
likely is it that 6 channels from 3 different broadcast corps would be on the 
same "frequency"?

> Would it be possible for you to open up the device and take some
> hi-res digital photos?

I've tried and tried.  I'm afraid it's going to break if I tear at the case 
anymore.  It's not mine and the vendor's Website doesn't list it for sale 
anymore :(

UPDATE: Okay, one bloody fingernail later... it's open.  I'll send pics when I 
can get them.  But right away I see:

 1 NXP Chip: TDA 18271HDC2
 1 Auvitek Chip: AU8522AA
 1 Auvitek Chip: AU0828A


> > I just upgraded to 2.6.27 and it doesn't work anymore.  Modprobing au0828
> > does not load up any other modules like the tda18721 and does not create
> > a /dev/dvb folder.  This is a problem with the latest hg tip of v4l-dvb.
>
> I will have to take a look into this -- I haven't tested 2.6.27
> enough, myself.  If there is a problem, then we'll have to fix it for
> the 2.6.27.y stable series.

This is a problem with the install scripts, not with 2.6.27.
My distro has gzipped modules so the 'make install' command did not overwrite 
the default mod.ko.gz.  'make rmmod' or whatever the specific make target is 
in this project removes both the mod.ko files and the mod.ko.gz files.  So, 
uninstalling then installing works.  Nothing to do with 2.6.27.


> Auvitek is the chip manufacturer.  Lets go with the name "Syntek" for
> now.  I've seen this in retail packaging using the name, "Syntek
> Teledongle" ...



-- 
***************************************************************************
Electronic Mail is not secure, may not be read every day, and should not be 
used for urgent or sensitive issues.

Mark Kimsal
http://biz.metrofindings.com/
fax: 866-375-1590

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
