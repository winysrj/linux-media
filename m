Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.169])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <robert.golding@gmail.com>) id 1KUZSB-0003tZ-FI
	for linux-dvb@linuxtv.org; Sun, 17 Aug 2008 06:01:21 +0200
Received: by wf-out-1314.google.com with SMTP id 27so1502005wfd.17
	for <linux-dvb@linuxtv.org>; Sat, 16 Aug 2008 21:01:14 -0700 (PDT)
Message-ID: <ae5231870808162101t470b57cbu29653fec0c9b66e9@mail.gmail.com>
Date: Sun, 17 Aug 2008 13:31:13 +0930
From: "Robert Golding" <robert.golding@gmail.com>
To: "Jonathan Hummel" <jhhummel@bigpond.com>
In-Reply-To: <1218883590.16051.6.camel@mistress>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080816013510.AF253104F0@ws1-3.us4.outblaze.com>
	<ae5231870808152114j273efbd4g2ce0b25ffce251e6@mail.gmail.com>
	<1218883590.16051.6.camel@mistress>
Cc: LinuxTV DVB list <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200
	H - DVB Only support
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

2008/8/16 Jonathan Hummel <jhhummel@bigpond.com>:
> On Sat, 2008-08-16 at 13:44 +0930, Robert Golding wrote:
>> Whoops, sent to wrong place this sent to mail list, sorry
>>
>> I have finally got the modules to load the PxDVR 3200 H I bought,
>> however, now I am getting "Failed to lock channel" error messages from
>> MeTV.
>> The 'channels.conf' file is correct as I used for my Dvico DVB-T.
>>
>>  I have replaced the Dvico with the Leadtek because I wanted to be
>> able to get local radio and also use the PCI-e channel since I have
>> many of them and only one PCI slot.
>>
>> The card is auto-recognised and loads all dvb modules, including fw
>> and frontends.
>>
>> One other thing, I attached an MS drive and tried it in windows [that
>> is another wholly different story :-) ] and it worked very well.  I
>> had occation to compare the channels info to each other and the Linux
>> version is OK.
>>
>> Any information, no matter how small, to show how I might fix this
>> would be greatly apprecited
>>
>
> Rob
>
> I've been using Me-TV for a while now on a DTV2000H Card, and recently
> set up the 3200H card as well, with a lot (and I mean a lot) of help
> from Stephen. In my experience, you only really get this message when
> the card is getting no reception. Other similar errors which relate to
> accessing the card itself happen when another TV programme, such as Myth
> is already loaded and locked onto the card.
>
> I'm not sure radio works on these cards without a lot of effort and
> stuffing around each and every time you want to use it. I've never
> gotten the 2000H to work on radio, so didn't even bother with the 3200H
> though.
>
> As Stephen said, this card is a bit sensitive to firmware and drivers,
> as the patch to allow this card is relatively new (days old).
>
> cheers
>
> Jon
>
>

It seems that kernel 2.6.27 (what I was using) is different enough
that the modules and fw from Stephens downloads won't work properly.

I went back to 2.6.25 and it worked there, so I tried 2.6.26 and it
worked there as well.

These are the steps I had to do so it would load properly;
1) Compile kernel WITHOUT 'multimedia'
i.e. #
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

& reboot with new kernel (if it was the kernel you were already booted
too, don't bother)

2) Download Stephens latest media patches
#> wget http://linuxtv.org/hg/~stoth/v4l-dvb/archive/tip.tar.bz2
extract to current dir, then;
#> make all
#> make install

3) Download Stephens firmware and follow instructions in
/Documentation/video4linux/extract_xc3028.pl

4) Reboot machine to load all the correct modules and fw, then open
favourite tuner prog (I use Me-TV) and enjoy the viewing.

-- 
Regards,	Robert

..... Some people can tell what time it is by looking at the sun, but
I have never been able to make out the numbers.
---
Errata: Spelling mistakes are not intentional, however, I don't use
spell checkers because it's too easy to allow the spell checker to
make the decisions and use words that are out of context for that
being written, i.e. their/there, your/you're, threw/through and even
accept/except, not to mention foreign (I'm Australian) English
spelling, i.e. colour/color, socks/sox, etc,.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
