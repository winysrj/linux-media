Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.230])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <whauger@gmail.com>) id 1KYQMB-0005Yj-Tc
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 21:07:15 +0200
Received: by rv-out-0506.google.com with SMTP id b25so5245rvf.41
	for <linux-dvb@linuxtv.org>; Wed, 27 Aug 2008 12:06:59 -0700 (PDT)
Message-ID: <6f94e1a00808271206g5468a666o25ed81698c5afeb8@mail.gmail.com>
Date: Wed, 27 Aug 2008 21:06:59 +0200
From: "Werner Hauger" <whauger@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <20080827091948.GA2479@optima.lan>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080825122741.GB17421@optima.lan>
	<48B2E1DC.2080605@beardandsandals.co.uk>
	<6f94e1a00808261235g130cf9b9h9b09f11249a01ebe@mail.gmail.com>
	<20080827091948.GA2479@optima.lan>
Subject: Re: [linux-dvb] TT S2-3200 + CI Extension
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

Hi

On Wed, Aug 27, 2008 at 11:19 AM, Martin Hurton <martin.hurton@gmail.com> wrote:
>
> The revision of my CI board is 1.1.

Ok.

> When I comment out the above code, I can see the "CI interface
> initialised" message, but cannot see the "dvb_ca adapter 0: DVB CAM
> detected and initialised successfully" one. The CA is not working.

Good, that means there is communication between the TT-3200 and the CI
board. The firmware version reported by your CI was preventing any
attempt to communicate. A few lines further down from your change is
another version check that decides if polling or interrupts should be
used:

// version 0xa2 of the CI firmware doesn't generate interrupts
        if (ci_version == 0xa2) {
                ca_flags = 0;
                budget_ci->ci_irq = 0;
        } else {
                ca_flags = DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE |
                                DVB_CA_EN50221_FLAG_IRQ_FR |
                                DVB_CA_EN50221_FLAG_IRQ_DA;
                budget_ci->ci_irq = 1;
        }

The default is interrupts which you say doesn't work. You can try
adding your CI version to the if section test (or rearranging the
whole if/else section so that the two values are always set as per the
if section) to see if polling gets your CAM initialised.

Werner

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
