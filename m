Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1Kpjkk-0006HG-El
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 15:15:59 +0200
Received: by nf-out-0910.google.com with SMTP id g13so1020536nfb.11
	for <linux-dvb@linuxtv.org>; Tue, 14 Oct 2008 06:15:52 -0700 (PDT)
Message-ID: <412bdbff0810140615q741c9c02i7d0f1deb47eef715@mail.gmail.com>
Date: Tue, 14 Oct 2008 09:15:52 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Paul Guzowski" <guzowskip@linuxmail.org>
In-Reply-To: <412bdbff0810140611q60a5f040g3bd02942111861e3@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20081014115855.1E8D37BD4F@ws5-10.us4.outblaze.com>
	<412bdbff0810140609n27da7d62xa7fd453005fb4b8f@mail.gmail.com>
	<412bdbff0810140611q60a5f040g3bd02942111861e3@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Ubuntu 8.10 and Pinnacle HDTV Pro usb stick
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

On Tue, Oct 14, 2008 at 9:11 AM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> On Tue, Oct 14, 2008 at 9:09 AM, Devin Heitmueller
> <devin.heitmueller@gmail.com> wrote:
>> Is this the 800e or the 801e version of the Pinnacle PCTV HD Pro?
>
> Nevermind my question about whether it's the 800e or the 801e.  If
> you're doing analog then it's got to be the 800e (the analog support
> for the 801e is unimplemented).

Sorry to keep replying to myself.

Wait a second, you're using Ubuntu 8.10?  The Pinnacle 800e is
supported in the stock distribution, so unless you have some other
reason to you shouldn't need to be building the v4l-dvb source at all.
 It should "just work".

If you have some other device that requires the newer code, then
indeed see my above message about doing a clean checkout.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
