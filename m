Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KRZyV-0004hb-1j
	for linux-dvb@linuxtv.org; Fri, 08 Aug 2008 23:58:20 +0200
Received: by nf-out-0910.google.com with SMTP id g13so1111473nfb.11
	for <linux-dvb@linuxtv.org>; Fri, 08 Aug 2008 14:58:15 -0700 (PDT)
Message-ID: <412bdbff0808081458v418449c4q6db215cf83e3ead0@mail.gmail.com>
Date: Fri, 8 Aug 2008 17:58:15 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: Xaero <kknull0@gmail.com>
In-Reply-To: <57ed08da0808081449m598af353n7edf908551753318@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <57ed08da0808081449m598af353n7edf908551753318@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle pctv hybrid pro stick 340e support
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

2008/8/8 Xaero <kknull0@gmail.com>:
> Hi,
> I'm trying to make the 340e card work. (This is a reply to Gerard post, I've
> just subscribed to this list and I didn't know how to reply, sorry :D)
> I have the same lsusb output as Gerard. but I can't get more information
> from dmesg:
> I get only
>
> usb 6-8: new high speed USB device using ehci_hcd and address 8
> usb 6-8: configuration #1 chosen from 1 choice
>
> when the card is plugged. (maybe I have to configure some kernel options?)
>
> Btw, I tried the dib0770 modules (following Albert's instructions) , and no
> dvb devices are created, so i don't think they'rer the right drivers (I'm
> not sure again, dmesg doesn't write anything)...
> Suggestion?

I'm not sure how similar the 340e is to the "Pinnacle PCTV HD Pro USB"
stick that's available in the United States, but it's possible they're
similar devices:

http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Pro_Stick_(801e)

Why don't you open it up and see if it's got the same components?

I have been working on it for the last few days, and I'm pretty close
to having it working.  Once I do, adding another USB ID would be
pretty simple.  I should have a patch for digital support toward the
end of next week (I will be out of town until then).

If it's not the same device, you should create a page in the Wiki
comparable to the one above, containing all of the chips that the
device includes (so at least people will know definitively that it's
not supported and what it is composed of).

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
