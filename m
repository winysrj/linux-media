Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KTjAe-00024P-9z
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 22:11:45 +0200
Received: by ug-out-1314.google.com with SMTP id x30so21602ugc.20
	for <linux-dvb@linuxtv.org>; Thu, 14 Aug 2008 13:11:40 -0700 (PDT)
Message-ID: <412bdbff0808141311p264d327ayb9e736f290326371@mail.gmail.com>
Date: Thu, 14 Aug 2008 16:11:40 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Nicolas Will" <nico@youplala.net>
In-Reply-To: <1218743866.8654.2.camel@youkaida>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0808141157t241748b4n5d82b15fcbc18d4a@mail.gmail.com>
	<1218743866.8654.2.camel@youkaida>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Possible bug in dib0700_core.c i2c transfer function
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

On Thu, Aug 14, 2008 at 3:57 PM, Nicolas Will <nico@youplala.net> wrote:
> I, for one, am very interested in this.
>
> I cannot code or really understand the details, but could this explain
> the more or less regular i2c read failures or even write failures
> eventually leading to device lock-ups that we are still experiencing if
> we are a bit too agressive?

Also, what device are you describing when you refer to your i2c
problem?  That might help narrow down whether we are talking about an
xc5000 issue or a dib0700 issue.

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
