Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.179])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KYru0-0004JI-5G
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 02:31:50 +0200
Received: by ik-out-1112.google.com with SMTP id c21so383818ika.1
	for <linux-dvb@linuxtv.org>; Thu, 28 Aug 2008 17:31:44 -0700 (PDT)
Message-ID: <412bdbff0808281731t7641e4d1kf86058e071c7d5fb@mail.gmail.com>
Date: Thu, 28 Aug 2008 20:31:44 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Thomas Goerke" <tom@goeng.com.au>,
	"Patrick Boettcher" <patrick.boettcher@desy.de>
In-Reply-To: <008001c9096a$f315df10$d9419d30$@com.au>
MIME-Version: 1.0
Content-Disposition: inline
References: <004f01c90921$248fe2b0$6dafa810$@com.au>
	<412bdbff0808280824s288de72el297dda0556d6ca4d@mail.gmail.com>
	<007f01c90965$344da360$9ce8ea20$@com.au>
	<412bdbff0808281638h7e911b37n4d5043bf40b42d65@mail.gmail.com>
	<008001c9096a$f315df10$d9419d30$@com.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge WinTV-NOVA-T-500 New Firmware
	(dvb-usb-dib0700-1.20.fw) causes problems
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

On Thu, Aug 28, 2008 at 8:05 PM, Thomas Goerke <tom@goeng.com.au> wrote:
> I did a little more debugging and it seems that the I still have a problem
> with the .20 version.  However, you only see it after a cold reset ie when
> you need to load the firmware.  See below for the first dmesg which is with
> the .20 firmware.  As you can see the card is found but only in a cold
> state.  The second dmesg is with the .10 firmware and the card is found
> firstly in a cold state and then in a warm state.  Each of these dmesg
> outputs have been after a power off from the power supply for 10 seconds ie
> no power to backplane.

Wow, that's so early in the loading process for the device, it's hard
to see how that can have anything to do with my i2c changes.

Patrick, do you have any changelogs that describe the differences
between 1.10 and 1.20 other than the addition of the new i2c API?

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
