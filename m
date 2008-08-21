Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.239])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KW8x6-0002Ij-0M
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 14:07:44 +0200
Received: by rv-out-0506.google.com with SMTP id b25so977181rvf.41
	for <linux-dvb@linuxtv.org>; Thu, 21 Aug 2008 05:07:37 -0700 (PDT)
Message-ID: <d9def9db0808210507pa76088cx28a955b1840e2147@mail.gmail.com>
Date: Thu, 21 Aug 2008 14:07:37 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Alex Speed Kjeldsen" <alex.kjeldsen@gmail.com>
In-Reply-To: <20080821124658.549ced6c@ask-gnewsense>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080821124658.549ced6c@ask-gnewsense>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-T USB Device which doesn't require non-free
	software
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

On Thu, Aug 21, 2008 at 12:46 PM, Alex Speed Kjeldsen
<alex.kjeldsen@gmail.com> wrote:
> I run the fully free OS gNewSense, which basically is Ubuntu 8.04 with all the non-free stuff removed.
>
> Could anyone recommend a DVB-T (or hybrid DVB-T/Analog) USB device which would work in this environment without requiring non-free drivers or firmware?
>

I am not aware that there are any devices available which support as
many videostandards as those devices which use firmware.
As for em28xx based devices there have been a couple of
em2870-zl10353-mt2060 based devices around.
Whatever devices you'll use with xc3028, xc3028L, xc4000, xc5000
they'll require a firmware esp. because those silicon tuners require
special firmware/codes for the different modes. Same counts for many
Micronas designs.

I can recommend the Terratec Hybrid XS FM which is fully supported,
you can get them for a good price on Ebay what I saw yesterday when
looking at all their prices.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
