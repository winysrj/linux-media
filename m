Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1Kip0I-0004Qo-5T
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 13:27:27 +0200
Received: by fg-out-1718.google.com with SMTP id e21so279632fga.25
	for <linux-dvb@linuxtv.org>; Thu, 25 Sep 2008 04:27:23 -0700 (PDT)
Message-ID: <d9def9db0809250427o338aef56q87fdee87f18ddcb8@mail.gmail.com>
Date: Thu, 25 Sep 2008 13:27:21 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Janne Grunau" <janne-dvb@grunau.be>
In-Reply-To: <200809251313.10640.janne-dvb@grunau.be>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080923181628.10797e0b@mchehab.chehab.org>
	<48DB6A94.2040508@linuxtv.org>
	<d9def9db0809250345v674861a0k3d4b5f2c765e4152@mail.gmail.com>
	<200809251313.10640.janne-dvb@grunau.be>
Cc: Manu Abraham <abraham.manu@gmail.com>, Greg KH <greg@kroah.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Marcel Siegert <mws@linuxtv.org>, Michael Krufky <mkrufky@linuxtv.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [ANNOUNCE] DVB API improvements
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

On Thu, Sep 25, 2008 at 1:13 PM, Janne Grunau <janne-dvb@grunau.be> wrote:
> On Thursday 25 September 2008 12:45:51 Markus Rechberger wrote:
>> what's the matter of merging both? please let us discuss that, the
>> APIs shouldn't have a big impact on each other.
>> Does it break someone's neck to have both?
>
> They will stick both forever in the kernel and either applications or
> drivers have to support both. Realistically both drivers and
> applications will support both.
>
> This is a stupid compromise which doesn't solve anything. A decision was
> made we should live with it.
>

Janne, as from my side we already delivered vendor specific drivers
with vendor specific interfaces
to a couple of customers and also patched the enduser applications for
it since the API didn't provide the necessary
features.
I don't see that there's a restriction on a single API for it, BSD
guys simply put a compatibility layer infront of their API
in order to support linux applications while having the full flexibility.
Although it's your opinion and I respect it.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
