Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KTQ31-0000JA-Vj
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 01:46:37 +0200
Received: by nf-out-0910.google.com with SMTP id g13so237250nfb.11
	for <linux-dvb@linuxtv.org>; Wed, 13 Aug 2008 16:46:32 -0700 (PDT)
Message-ID: <412bdbff0808131646t6996c4b6w9f01a23545e5d8f5@mail.gmail.com>
Date: Wed, 13 Aug 2008 19:46:32 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: hwertz@avalon.net
In-Reply-To: <20080812233514.9AC540C9@resin14.mta.everyone.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080812233514.9AC540C9@resin14.mta.everyone.net>
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

Hello Nancy,

2008/8/13 Nancy Wertz <hwertz@avalon.net>:
>      Fantastic!  I've not really gotten as much chance to mess with mine
> as I'd prefer.. I plugged it into a Windows box at a friend's house and see
> the nice HD picture (and see that it gets quite hot 8-) but that's about it
> -- work's been wiping me out.  Certainly I can give it some exercise and
> track down any bugs though (ultimately I plan to use it in a mythtv setup
> to supplement or replace my BT878-based card so it'll *definitely* get
> exercised then.)

Just to be clear, I'm actively working on the Pinnacle PCTV HD Pro
"801e" variant, not the 340e.  My hopes were that they were similar
(if not identical) devices.  However, further correspondence with the
340e owner indicates that the device uses an xc4000 tuner, for which I
do not believe there is currently any support in the V4L codebase.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
