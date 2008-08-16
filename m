Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.228])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <robert.golding@gmail.com>) id 1KUDBw-0005Vn-5N
	for linux-dvb@linuxtv.org; Sat, 16 Aug 2008 06:15:05 +0200
Received: by wr-out-0506.google.com with SMTP id 50so1361050wra.13
	for <linux-dvb@linuxtv.org>; Fri, 15 Aug 2008 21:15:00 -0700 (PDT)
Message-ID: <ae5231870808152114j273efbd4g2ce0b25ffce251e6@mail.gmail.com>
Date: Sat, 16 Aug 2008 13:44:59 +0930
From: "Robert Golding" <robert.golding@gmail.com>
To: "LinuxTV DVB list" <linux-dvb@linuxtv.org>
In-Reply-To: <20080816013510.AF253104F0@ws1-3.us4.outblaze.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080816013510.AF253104F0@ws1-3.us4.outblaze.com>
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

Whoops, sent to wrong place this sent to mail list, sorry

I have finally got the modules to load the PxDVR 3200 H I bought,
however, now I am getting "Failed to lock channel" error messages from
MeTV.
The 'channels.conf' file is correct as I used for my Dvico DVB-T.

 I have replaced the Dvico with the Leadtek because I wanted to be
able to get local radio and also use the PCI-e channel since I have
many of them and only one PCI slot.

The card is auto-recognised and loads all dvb modules, including fw
and frontends.

One other thing, I attached an MS drive and tried it in windows [that
is another wholly different story :-) ] and it worked very well.  I
had occation to compare the channels info to each other and the Linux
version is OK.

Any information, no matter how small, to show how I might fix this
would be greatly apprecited

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
