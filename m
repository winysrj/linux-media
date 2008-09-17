Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KfmdT-0002F6-Jq
	for linux-dvb@linuxtv.org; Wed, 17 Sep 2008 04:19:21 +0200
Received: by ey-out-2122.google.com with SMTP id 25so1331001eya.17
	for <linux-dvb@linuxtv.org>; Tue, 16 Sep 2008 19:19:16 -0700 (PDT)
Message-ID: <412bdbff0809161919l12e18a72y67217a3767ca9567@mail.gmail.com>
Date: Tue, 16 Sep 2008 22:19:16 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Jonathan Coles" <jcoles0727@rogers.com>
In-Reply-To: <48D06713.2050302@rogers.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <48D06713.2050302@rogers.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] More impossible instructions
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

On Tue, Sep 16, 2008 at 10:10 PM, Jonathan Coles <jcoles0727@rogers.com> wrote:
> Thinking I might need firmware for xc3028, I went to your Xceive
> XC3028/XC2028 Wiki page. The instructions under "How to Obtain the
> Firmware" contain this gem:
>
> #       3) run the script:
> #               linux/Documentation/video4linux/extract_xc3028.pl
>
> So where is this? /linux? ~/linux?
> I eventually realized is
> http://linuxtv.org/hg/v4l-dvb/file/tip/linux/Documentation/video4linux/extract_xc3028.pl.
> But if I try to download it, I get an XML file instead.
>
> Is there a way to get this script other than copying and pasting it line
> by line from the browser?

If you hg cloned the v4l-dvb repository, you'll find the script in
already on your workstation in v4l-dvb/linux/Documentation/video4linux

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
