Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1Ker3k-0003II-IZ
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 14:50:40 +0200
Received: by nf-out-0910.google.com with SMTP id g13so920215nfb.11
	for <linux-dvb@linuxtv.org>; Sun, 14 Sep 2008 05:50:32 -0700 (PDT)
Message-ID: <412bdbff0809140550w7c6bdeaag567039de5af590db@mail.gmail.com>
Date: Sun, 14 Sep 2008 08:50:32 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Andreas Oberritter" <obi@linuxtv.org>
In-Reply-To: <48CC8338.6050405@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0809131441k5f38931cr7d64dc3871c37987@mail.gmail.com>
	<48CC3651.5040502@linuxtv.org>
	<412bdbff0809131528h22171a3am434cd5e2500f40db@mail.gmail.com>
	<48CC8338.6050405@linuxtv.org>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Power management and dvb framework
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

On Sat, Sep 13, 2008 at 11:21 PM, Andreas Oberritter <obi@linuxtv.org> wrote:
> The sleep callback gets called automatically some seconds after the last
> user closed the frontend device.

Great.  That sounds like the ideal place to bring everything down.  Is
that scheduled via a timer?  And does it still get called if the
frontend gets reopened before the timer expires?

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
